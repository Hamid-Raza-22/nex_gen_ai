import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nex_gen_ai/core/api/ai_client.dart';
import 'package:nex_gen_ai/features/ai_chat/application/chat_controller.dart';

import 'helpers.dart';

const _config = ChatConfig(
  id: 'test',
  title: 'Tester',
  avatar: 'assets/img/avatar.jpg',
  subtitle: 'Unit test persona',
  systemPrompt: 'You are a test assistant.',
  greeting: 'Hello from the test persona.',
);

class _StreamingAiClient extends AiClient {
  _StreamingAiClient(this.chunks) : super(_unusedDio);

  final List<String> chunks;
  List<Map<String, String>>? lastMessages;

  @override
  Stream<String> chatCompletionStream(List<Map<String, String>> messages) {
    lastMessages = messages;
    return Stream.fromIterable(chunks);
  }
}

class _FailingAiClient extends AiClient {
  _FailingAiClient() : super(_unusedDio);

  @override
  Stream<String> chatCompletionStream(List<Map<String, String>> messages) =>
      Stream.error(const AiNotConfiguredException());
}

/// Never used: the fakes override every method that touches the network.
final _unusedDio = Dio();

void main() {
  Future<ProviderContainer> makeContainer(AiClient client) async {
    final container = ProviderContainer(
      overrides: [
        ...await testOverrides(),
        aiClientProvider.overrideWithValue(client),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('starts with the persona greeting', () async {
    final container = await makeContainer(_StreamingAiClient(const []));
    final state = container.read(chatControllerProvider(_config));

    expect(state.messages, hasLength(1));
    expect(state.messages.first.role, 'assistant');
    expect(state.messages.first.content, 'Hello from the test persona.');
  });

  test('appends the user message and assembles streamed deltas', () async {
    final client = _StreamingAiClient(const ['Hel', 'lo ', 'world']);
    final container = await makeContainer(client);
    final notifier = container.read(chatControllerProvider(_config).notifier);

    await notifier.send('Say hello');
    final state = container.read(chatControllerProvider(_config));

    expect(state.messages, hasLength(3));
    expect(state.messages[1].content, 'Say hello');
    expect(state.messages[2].content, 'Hello world');
    expect(state.messages[2].isStreaming, isFalse);
    expect(state.isSending, isFalse);
  });

  test('sends the system prompt and skips the local greeting', () async {
    final client = _StreamingAiClient(const ['ok']);
    final container = await makeContainer(client);

    await container.read(chatControllerProvider(_config).notifier).send('Hi');

    expect(client.lastMessages, hasLength(2));
    expect(client.lastMessages!.first['role'], 'system');
    expect(client.lastMessages!.first['content'], 'You are a test assistant.');
    expect(client.lastMessages!.last['content'], 'Hi');
  });

  test('ignores empty input', () async {
    final container = await makeContainer(_StreamingAiClient(const []));
    final notifier = container.read(chatControllerProvider(_config).notifier);

    await notifier.send('   ');

    expect(container.read(chatControllerProvider(_config)).messages, hasLength(1));
  });

  test('surfaces errors and removes the pending bubble', () async {
    final container = await makeContainer(_FailingAiClient());
    final notifier = container.read(chatControllerProvider(_config).notifier);

    await notifier.send('Will fail');
    final state = container.read(chatControllerProvider(_config));

    expect(state.error, isNotNull);
    expect(state.isSending, isFalse);
    // Greeting + user message only; the empty assistant bubble is dropped.
    expect(state.messages, hasLength(2));
  });
}
