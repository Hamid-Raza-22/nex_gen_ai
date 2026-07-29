import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive.dart';

/// Overridden in main() after Hive initialization.
final historyBoxProvider = Provider<Box<Map>>(
  (ref) => throw UnimplementedError('Override in main()'),
);

final historyRepositoryProvider = Provider<HistoryRepository>(
  (ref) => HistoryRepository(ref.watch(historyBoxProvider)),
);

final historyEntriesProvider =
    NotifierProvider<HistoryEntriesNotifier, List<HistoryEntry>>(
        HistoryEntriesNotifier.new);

enum HistoryType { chat, content, logo, interior, course }

class HistoryEntry {
  const HistoryEntry({
    required this.type,
    required this.title,
    required this.snippet,
    required this.timestamp,
  });

  final HistoryType type;
  final String title;
  final String snippet;
  final DateTime timestamp;

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'title': title,
        'snippet': snippet,
        'timestamp': timestamp.toIso8601String(),
      };

  factory HistoryEntry.fromMap(Map map) => HistoryEntry(
        type: HistoryType.values.asNameMap()[map['type']] ?? HistoryType.chat,
        title: map['title'] as String? ?? '',
        snippet: map['snippet'] as String? ?? '',
        timestamp:
            DateTime.tryParse(map['timestamp'] as String? ?? '') ??
                DateTime.now(),
      );
}

class HistoryRepository {
  const HistoryRepository(this._box);

  final Box<Map> _box;

  List<HistoryEntry> getAll() {
    final entries = _box.values.map(HistoryEntry.fromMap).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  Future<void> add(HistoryEntry entry) => _box.add(entry.toMap());

  Future<void> clear() => _box.clear();
}

class HistoryEntriesNotifier extends Notifier<List<HistoryEntry>> {
  @override
  List<HistoryEntry> build() => ref.read(historyRepositoryProvider).getAll();

  Future<void> record(HistoryEntry entry) async {
    await ref.read(historyRepositoryProvider).add(entry);
    state = ref.read(historyRepositoryProvider).getAll();
  }

  Future<void> clear() async {
    await ref.read(historyRepositoryProvider).clear();
    state = [];
  }
}
