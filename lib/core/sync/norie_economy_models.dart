import 'dart:convert';

const economyMaxAmount = 1000000;
const economyMaxTotal = 1000000000;
const economyMaxOperations = 10000;
const economyMaxBytes = 4 * 1024 * 1024;

Map<String, dynamic> economyCopy(Map<String, dynamic> value) =>
    Map<String, dynamic>.from(jsonDecode(jsonEncode(value)) as Map);

String economyString(Object? raw, String name, {int max = 512}) {
  if (raw is! String || raw.trim().isEmpty || raw.length > max) {
    throw FormatException('Invalid economy $name.');
  }
  return raw;
}

bool economyUuid(String raw) => RegExp(
        r'^[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}$')
    .hasMatch(raw);

int economyInt(Object? raw, String name,
    {int min = 0, int max = economyMaxTotal}) {
  if (raw is! int || raw < min || raw > max) {
    throw FormatException('Invalid economy $name.');
  }
  return raw;
}

List<String> economyStrings(Object? raw, String name, {int max = 100000}) {
  if (raw is! List || raw.length > max) {
    throw FormatException('Invalid economy $name.');
  }
  final result = raw.map((v) => economyString(v, name)).toSet().toList()
    ..sort();
  return result;
}

DateTime economyDate(Object? raw, String name) {
  final text = economyString(raw, name, max: 64);
  if (!RegExp(r'(Z|[+-]\d\d:\d\d)$').hasMatch(text)) {
    throw FormatException('Economy $name must include a timezone.');
  }
  final date = DateTime.tryParse(text);
  if (date == null) throw FormatException('Invalid economy $name.');
  return date.toUtc();
}

Map<String, dynamic> economyMap(Object? raw, String name) {
  if (raw is! Map || raw.keys.any((k) => k is! String)) {
    throw FormatException('Invalid economy $name.');
  }
  return Map<String, dynamic>.from(raw);
}

void economyKeys(Map<String, dynamic> value, Set<String> keys, String name) {
  if (value.length != keys.length || value.keys.any((k) => !keys.contains(k))) {
    throw FormatException('Invalid economy $name fields.');
  }
}

Map<String, dynamic> economyBaseline(Map<String, dynamic> raw) => {
      'total_xp': economyInt(raw['total_xp'] ?? 0, 'baseline XP'),
      'credits': economyInt(raw['credits'] ?? 0, 'baseline credits'),
      'owned_shop_items':
          economyStrings(raw['owned_shop_items'] ?? [], 'items', max: 512),
      'streak_shields':
          economyInt(raw['streak_shields'] ?? 0, 'shields', max: 1000000),
      'modified_at': economyDate(
              raw['modified_at'] ??
                  raw['updated_at'] ??
                  '1970-01-01T00:00:00.000Z',
              'modified time')
          .toIso8601String(),
      'claim_keys': economyStrings(raw['claim_keys'] ?? [], 'baseline claims'),
    };

Map<String, dynamic> economyCheckpoint(Object? raw) {
  final cp = economyMap(raw, 'checkpoint');
  economyKeys(
      cp,
      {
        'id',
        'epoch',
        'through_seq',
        'total_xp',
        'credits',
        'owned_shop_items',
        'streak_shields',
        'claim_keys',
        'device_sequences'
      },
      'checkpoint');
  final sequences = economyMap(cp['device_sequences'], 'checkpoint devices');
  if (sequences.length > 10000) {
    throw const FormatException('Too many economy devices.');
  }
  final ids = sequences.keys.toList()..sort();
  for (final id in ids) {
    if (!economyUuid(id)) {
      throw const FormatException('Invalid checkpoint device UUID.');
    }
  }
  return {
    'id': economyString(cp['id'], 'checkpoint ID'),
    'epoch': economyString(cp['epoch'], 'epoch'),
    'through_seq': economyInt(cp['through_seq'], 'checkpoint sequence'),
    'total_xp': economyInt(cp['total_xp'], 'checkpoint XP'),
    'credits': economyInt(cp['credits'], 'checkpoint credits'),
    'owned_shop_items':
        economyStrings(cp['owned_shop_items'], 'checkpoint items', max: 512),
    'streak_shields':
        economyInt(cp['streak_shields'], 'checkpoint shields', max: 1000000),
    'claim_keys': economyStrings(cp['claim_keys'], 'checkpoint claims'),
    'device_sequences': {
      for (final id in ids) id: economyInt(sequences[id], 'device sequence')
    },
  };
}

Map<String, dynamic> economyOperation(Object? raw) {
  final op = economyMap(raw, 'operation');
  economyKeys(
      op,
      {
        'id',
        'device_id',
        'device_seq',
        'kind',
        'claim_key',
        'xp',
        'credits',
        'item_id',
        'occurred_at',
        'reservation_id'
      },
      'operation');
  final id = economyString(op['id'], 'operation ID');
  final device = economyString(op['device_id'], 'device ID');
  if (!economyUuid(id) || !economyUuid(device)) {
    throw const FormatException('Economy operations need UUID identities.');
  }
  final kind = op['kind'];
  final xp = economyInt(op['xp'], 'XP', max: economyMaxAmount);
  final credits = economyInt(op['credits'], 'credits',
      min: -economyMaxAmount, max: economyMaxAmount);
  if (kind != 'reward' && kind != 'spend' && kind != 'consume_shield') {
    throw const FormatException('Unknown economy operation kind.');
  }
  final claim = economyString(op['claim_key'], 'claim');
  final item = op['item_id'];
  if (item != null) economyString(item, 'item', max: 128);
  final reservation = op['reservation_id'];
  if (reservation != null) economyString(reservation, 'reservation ID');
  if (kind == 'reward' &&
          (credits < 0 ||
              xp + credits == 0 ||
              item != null ||
              reservation != null) ||
      kind == 'spend' && (credits >= 0 || xp != 0) ||
      kind == 'consume_shield' && (credits != 0 || xp != 0 || item != null)) {
    throw const FormatException(
        'Invalid economy operation amounts or entitlement.');
  }
  return {
    'id': id,
    'device_id': device,
    'device_seq': economyInt(op['device_seq'], 'device sequence', min: 1),
    'kind': kind,
    'claim_key': claim,
    'xp': xp,
    'credits': credits,
    'item_id': item,
    'occurred_at':
        economyDate(op['occurred_at'], 'operation date').toIso8601String(),
    'reservation_id': reservation,
  };
}

bool economyCovered(
    Map<String, dynamic> operation, Map<String, dynamic>? checkpoint) {
  if (checkpoint == null) return false;
  final sequences = checkpoint['device_sequences'] as Map;
  return (sequences[operation['device_id']] as int? ?? 0) >=
      (operation['device_seq'] as int);
}

Map<String, dynamic> economyValidate(Object? raw) {
  final state = economyMap(raw, 'portable state');
  economyKeys(state, {'version', 'baseline', 'checkpoint', 'pending'},
      'portable state');
  if (state['version'] != 1) {
    throw const FormatException('Unknown economy state version.');
  }
  final baseline = economyBaseline(economyMap(state['baseline'], 'baseline'));
  final cp = state['checkpoint'] == null
      ? null
      : economyCheckpoint(state['checkpoint']);
  final pending = state['pending'];
  if (pending is! List || pending.length > economyMaxOperations) {
    throw const FormatException(
        'Economy pending queue is full; no operations removed.');
  }
  final ids = <String, Map<String, dynamic>>{};
  final seqs = <String, String>{};
  for (final rawOp in pending) {
    final op = economyOperation(rawOp);
    final id = op['id'] as String;
    if (ids.containsKey(id) && jsonEncode(ids[id]) != jsonEncode(op)) {
      throw const FormatException('Conflicting immutable economy ID.');
    }
    final sequence = '${op['device_id']}:${op['device_seq']}';
    if (seqs.containsKey(sequence) && seqs[sequence] != id) {
      throw const FormatException('Conflicting economy device sequence.');
    }
    ids[id] = op;
    seqs[sequence] = id;
  }
  final operations = ids.values.where((op) => !economyCovered(op, cp)).toList()
    ..sort((a, b) {
      final device =
          (a['device_id'] as String).compareTo(b['device_id'] as String);
      return device != 0
          ? device
          : (a['device_seq'] as int).compareTo(b['device_seq'] as int);
    });
  final result = <String, dynamic>{
    'version': 1,
    'baseline': baseline,
    'checkpoint': cp,
    'pending': operations
  };
  if (utf8.encode(jsonEncode(result)).length > economyMaxBytes) {
    throw const FormatException(
        'Economy envelope too large; operations retained.');
  }
  economyProjection(result);
  return result;
}

/// Numeric read model; never replays baseline totals as operations.
Map<String, dynamic> economyProjection(Map<String, dynamic> state) {
  final cp = state['checkpoint'] as Map<String, dynamic>?;
  final base = cp ?? state['baseline'] as Map<String, dynamic>;
  var xp = base['total_xp'] as int;
  var credits = base['credits'] as int;
  var shields = base['streak_shields'] as int;
  final items = Set<String>.from(base['owned_shop_items'] as List);
  final claims = Set<String>.from(base['claim_keys'] as List);
  final pending = (state['pending'] as List).cast<Map<String, dynamic>>();
  for (final op in pending) {
    if (economyCovered(op, cp)) continue;
    if (op['kind'] == 'reward') {
      final key = op['claim_key'] as String;
      // Portable merges retain every origin sequence. A deterministic pending
      // order projects one claim until the server confirms the first receipt.
      if (claims.add(key)) {
        xp += op['xp'] as int;
        credits += op['credits'] as int;
      }
    } else if (cp != null && op['reservation_id'] == null) {
      // Guest receipts remain in the submission queue for origin-sequence
      // disposition, but cannot transfer unfunded debits or entitlements.
      continue;
    } else if (op['kind'] == 'spend') {
      credits += op['credits'] as int;
      // Account entitlements come only from a confirmed checkpoint.
      if (cp == null && op['reservation_id'] == null) {
        final item = op['item_id'] as String?;
        if (item == 'streak-shield') {
          shields++;
        } else if (item != null) {
          items.add(item);
        }
      }
    } else if (op['kind'] == 'consume_shield') {
      shields--;
    }
  }
  if (xp < 0 ||
      credits < 0 ||
      shields < 0 ||
      xp > economyMaxTotal ||
      credits > economyMaxTotal) {
    throw const FormatException(
        'Economy projection would exceed valid balances.');
  }
  return {
    'total_xp': xp,
    'credits': credits,
    'streak_shields': shields,
    'owned_shop_items': items.toList()..sort(),
    'claim_keys': claims.toList()..sort()
  };
}

Map<String, dynamic> economyMerge(Object? first, Object? second) {
  if (first == null) {
    return economyValidate(second ??
        {
          'version': 1,
          'baseline': economyBaseline({}),
          'checkpoint': null,
          'pending': []
        });
  }
  if (second == null) return economyValidate(first);
  final a = economyValidate(first), b = economyValidate(second);
  final ac = a['checkpoint'] as Map<String, dynamic>?,
      bc = b['checkpoint'] as Map<String, dynamic>?;
  Map<String, dynamic>? cp;
  if (ac != null && bc != null) {
    if (ac['epoch'] != bc['epoch']) {
      throw const FormatException(
          'Economy epochs differ; recover from server.');
    }
    final order =
        (ac['through_seq'] as int).compareTo(bc['through_seq'] as int);
    if (order == 0 && jsonEncode(ac) != jsonEncode(bc)) {
      throw const FormatException(
          'Conflicting economy checkpoint at same sequence.');
    }
    cp = order >= 0 ? ac : bc;
    final older = order >= 0 ? bc : ac;
    for (final entry in (older['device_sequences'] as Map).entries) {
      if (((cp['device_sequences'] as Map)[entry.key] as int? ?? 0) <
          (entry.value as int)) {
        throw const FormatException(
            'Economy checkpoint lost a device watermark.');
      }
    }
    if (!(cp['claim_keys'] as List)
        .toSet()
        .containsAll(older['claim_keys'] as List)) {
      throw const FormatException('Economy checkpoint lost rewarded claims.');
    }
  } else {
    cp = ac ?? bc;
  }
  final ab = a['baseline'] as Map<String, dynamic>,
      bb = b['baseline'] as Map<String, dynamic>;
  final comparison =
      (ab['modified_at'] as String).compareTo(bb['modified_at'] as String);
  final latest = comparison > 0 ||
          comparison == 0 && jsonEncode(ab).compareTo(jsonEncode(bb)) >= 0
      ? ab
      : bb;
  final baseline = <String, dynamic>{
    ...latest,
    'total_xp': (ab['total_xp'] as int) > (bb['total_xp'] as int)
        ? ab['total_xp']
        : bb['total_xp'],
    'owned_shop_items': {
      ...(ab['owned_shop_items'] as List).cast<String>(),
      ...(bb['owned_shop_items'] as List).cast<String>()
    }.toList()
      ..sort(),
    'claim_keys': {
      ...(ab['claim_keys'] as List).cast<String>(),
      ...(bb['claim_keys'] as List).cast<String>()
    }.toList()
      ..sort(),
  };
  return economyValidate({
    'version': 1,
    'baseline': baseline,
    'checkpoint': cp,
    'pending': [...a['pending'] as List, ...b['pending'] as List]
  });
}

Map<String, dynamic> economyReservation(Object? raw) {
  final value = economyMap(raw, 'reservation');
  economyKeys(
      value,
      {
        'id',
        'device_id',
        'limit',
        'spent',
        'expires_at',
        'shield_limit',
        'shields_spent'
      },
      'reservation');
  final device = economyString(value['device_id'], 'budget device');
  if (!economyUuid(device)) {
    throw const FormatException('Invalid budget device UUID.');
  }
  final limit = economyInt(value['limit'], 'reservation limit');
  final spent = economyInt(value['spent'], 'reservation spent', max: limit);
  if (limit - spent > 650) {
    throw const FormatException(
        'Offline reservation remaining allowance exceeds 650 credits.');
  }
  final shields = economyInt(value['shield_limit'], 'shield allowance');
  return {
    'id': economyString(value['id'], 'reservation ID'),
    'device_id': device,
    'limit': limit,
    'spent': spent,
    'expires_at': economyDate(value['expires_at'], 'expiry').toIso8601String(),
    'shield_limit': shields,
    'shields_spent':
        economyInt(value['shields_spent'], 'spent shields', max: shields)
  };
}
