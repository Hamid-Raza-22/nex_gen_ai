import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/ai_client.dart';
import '../../history/data/history_repository.dart';

/// Identifies a chat session. Value equality keeps the Riverpod family stable.
@immutable
class ChatConfig {
  const ChatConfig({
    required this.id,
    required this.title,
    required this.avatar,
    required this.subtitle,
    required this.systemPrompt,
    required this.greeting,
  });

  final String id;
  final String title;
  final String avatar;
  final String subtitle;
  final String systemPrompt;
  final String greeting;

  @override
  bool operator ==(Object other) =>
      other is ChatConfig && other.id == id && other.title == title;

  @override
  int get hashCode => Object.hash(id, title);
}

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
  const ChatState({
    this.messages = const [],
    this.isSending = false,
    this.error,
  });

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
    .family<ChatController, ChatState, ChatConfig>(ChatController.new);

class ChatController extends Notifier<ChatState> {
  ChatController(this.config);

  final ChatConfig config;

  @override
  ChatState build() {
    return ChatState(
      messages: [ChatMessage(role: 'assistant', content: config.greeting)],
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
      {'role': 'system', 'content': config.systemPrompt},
      // Skip the locally generated greeting.
      for (final m in state.messages.skip(1))
        {'role': m.role, 'content': m.content},
    ];

    state = state.copyWith(
      messages: [
        ...state.messages,
        const ChatMessage(role: 'assistant', content: '', isStreaming: true),
      ],
    );

    try {
      final client = ref.read(aiClientProvider);
      var full = '';
      await for (final delta in client.chatCompletionStream(apiMessages)) {
        full += delta;
        _updateLastMessage(full, streaming: true);
      }
      if (full.isEmpty) {
        // Some gateways do not support streaming; fall back to one request.
        full = await client.chatCompletion(apiMessages);
      }
      _updateLastMessage(full, streaming: false);
      state = state.copyWith(isSending: false);
      unawaited(
        ref.read(historyEntriesProvider.notifier).record(
              HistoryEntry(
                type: HistoryType.chat,
                title: 'Chat with ${config.title}',
                snippet: text.trim(),
                timestamp: DateTime.now(),
              ),
            ),
      );
    } catch (e) {
      // Drop the empty streaming bubble and surface the error.
      state = ChatState(
        messages: state.messages.sublist(0, state.messages.length - 1),
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
}
