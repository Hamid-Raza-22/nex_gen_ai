import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/ai_client.dart';
import '../../ai_assistants/data/personas.dart';
import '../../history/data/history_repository.dart';

class ChatMessage {
  const ChatMessage({
    required this.role,
    required this.content,
    this.isStreaming = false,
  });

  final String role; // 'user' | 'assistant'
  final String content;
  final bool isStreaming;

  ChatMessage copyWith({String? content, bool? isStreaming}) => ChatMessage(
        role: role,
        content: content ?? this.content,
        isStreaming: isStreaming ?? this.isStreaming,
      );
}

class ChatState {
  const ChatState({this.messages = const [], this.isSending = false, this.error});

  final List<ChatMessage> messages;
  final bool isSending;
  final String? error;

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
    String? error,
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        isSending: isSending ?? this.isSending,
        error: error,
      );
}

final chatControllerProvider = NotifierProvider.autoDispose
    .family<ChatController, ChatState, String>(ChatController.new);

class ChatController extends Notifier<ChatState> {
  ChatController(this.personaId);

  final String personaId;

  Persona get _persona => personaById(personaId) ?? personas.first;

  @override
  ChatState build() {
    return ChatState(
      messages: [ChatMessage(role: 'assistant', content: _persona.greeting)],
    );
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty || state.isSending) return;

    final userMessage = ChatMessage(role: 'user', content: text.trim());
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isSending: true,
    );

    final apiMessages = <Map<String, String>>[
      {'role': 'system', 'content': _persona.systemPrompt},
      for (final m in state.messages.skip(1)) // skip local greeting
        {'role': m.role, 'content': m.content},
    ];

    state = state.copyWith(
      messages: [
        ...state.messages,
        const ChatMessage(role: 'assistant', content: '', isStreaming: true),
      ],
    );

    try {
      final stream =
          ref.read(aiClientProvider).chatCompletionStream(apiMessages);
      var full = '';
      await for (final delta in stream) {
        full += delta;
        _updateLastMessage(full, streaming: true);
      }
      if (full.isEmpty) {
        // Some gateways reject streaming; fall back to a single request.
        full = await ref.read(aiClientProvider).chatCompletion(apiMessages);
      }
      _updateLastMessage(full, streaming: false);
      state = state.copyWith(isSending: false);
      unawaited(
        ref.read(historyEntriesProvider.notifier).record(
              HistoryEntry(
                type: HistoryType.chat,
                title: 'Chat with ${_persona.name}',
                snippet: text.trim(),
                timestamp: DateTime.now(),
              ),
            ),
      );
    } catch (e) {
      // Drop the empty streaming bubble and surface the error.
      state = state.copyWith(
        messages: state.messages.sublist(0, state.messages.length - 1),
        isSending: false,
        error: '$e',
      );
    }
  }

  void _updateLastMessage(String content, {required bool streaming}) {
    final messages = [...state.messages];
    messages[messages.length - 1] = messages.last.copyWith(
      content: content,
      isStreaming: streaming,
    );
    state = state.copyWith(messages: messages);
  }

  void clearError() => state = state.copyWith();
}
