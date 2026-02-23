import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrowserHistoryViewModel extends ChangeNotifier {
  static const String _historyKey = 'browser_history';

  final List<String> _history = <String>[];

  List<String> get history => List.unmodifiable(_history.reversed);

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_historyKey) ?? <String>[];
    _history
      ..clear()
      ..addAll(raw);
    notifyListeners();
  }

  Future<void> trackUrl(String url) async {
    if (url.isEmpty || !_isHttpUrl(url)) {
      return;
    }

    if (_history.contains(url)) {
      return;
    }

    _history.add(url);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, _history);
  }

  Future<void> clearHistory() async {
    _history.clear();
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  bool _isHttpUrl(String input) {
    final uri = Uri.tryParse(input);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String toDebugJson() {
    return jsonEncode(_history);
  }
}
