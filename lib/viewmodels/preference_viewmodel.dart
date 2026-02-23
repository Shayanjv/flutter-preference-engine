import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/preference_type.dart';

class PreferenceViewModel extends ChangeNotifier {
  static const String _prefsKey = 'product_preferences';

  final Map<int, PreferenceType> _preferences = <int, PreferenceType>{};

  Map<int, PreferenceType> get preferences => Map.unmodifiable(_preferences);

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null || raw.isEmpty) {
      return;
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _preferences
      ..clear()
      ..addEntries(
        decoded.entries.map(
          (entry) => MapEntry(
            int.parse(entry.key),
            PreferenceType.values.firstWhere(
              (value) => value.name == entry.value,
              orElse: () => PreferenceType.liked,
            ),
          ),
        ),
      );
    notifyListeners();
  }

  PreferenceType? preferenceFor(int productId) => _preferences[productId];

  Future<void> togglePreference(int productId, PreferenceType type) async {
    if (_preferences[productId] == type) {
      _preferences.remove(productId);
    } else {
      _preferences[productId] = type;
    }
    notifyListeners();
    await _persist();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final serialized = _preferences.map(
      (key, value) => MapEntry(key.toString(), value.name),
    );
    await prefs.setString(_prefsKey, jsonEncode(serialized));
  }
}
