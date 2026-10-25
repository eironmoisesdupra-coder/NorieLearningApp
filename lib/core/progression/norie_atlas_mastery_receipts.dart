/// Device-local deduplication stored atomically with its mastery counters.
/// This metadata must never enter the strict legacy cloud/backup record.
class AtlasMasteryReceipts {
  AtlasMasteryReceipts(this.lineage, Map<String, bool> receipts)
      : receipts = Map.unmodifiable(receipts);
  final String lineage;
  final Map<String, bool> receipts;
  static final _uuid = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
  static final _hash = RegExp(r'^[0-9a-f]{64}$');
  static const limit = 100000;

  factory AtlasMasteryReceipts.restore(Object? value) {
    if (value is! Map ||
        value.length != 3 ||
        value['version'] != 1 ||
        value['lineage'] is! String ||
        !_uuid.hasMatch(value['lineage'] as String) ||
        value['receipts'] is! Map) {
      throw const FormatException('Invalid local Atlas mastery receipts.');
    }
    final raw = value['receipts'] as Map;
    if (raw.length > limit ||
        raw.entries.any((e) =>
            e.key is! String ||
            !_hash.hasMatch(e.key as String) ||
            e.value is! bool)) {
      throw const FormatException('Invalid local Atlas answer receipt.');
    }
    return AtlasMasteryReceipts(
        value['lineage'] as String, Map<String, bool>.from(raw));
  }

  AtlasMasteryReceipts add(String receipt, bool correct) {
    if (!_hash.hasMatch(receipt)) throw ArgumentError('Invalid Atlas receipt.');
    if (receipts.containsKey(receipt)) {
      if (receipts[receipt] != correct) {
        throw StateError('Atlas answer receipt conflicts.');
      }
      return this;
    }
    if (receipts.length >= limit) {
      throw StateError(
          'Atlas receipt storage is full; existing progress is preserved.');
    }
    return AtlasMasteryReceipts(lineage, {...receipts, receipt: correct});
  }

  Map<String, Object> toJson() =>
      {'version': 1, 'lineage': lineage, 'receipts': receipts};
}
