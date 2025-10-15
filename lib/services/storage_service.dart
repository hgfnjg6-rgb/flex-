import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/cycle_entry.dart';

class StorageService {
  static const _userKey = 'mona_user';

  final SharedPreferences prefs;

  StorageService(this.prefs);

  User? getUser() {
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;
    try {
      return User.fromRawJson(raw);
    } catch (e) {
      return null;
    }
  }

  Future<void> saveUser(User user) async {
    await prefs.setString(_userKey, user.toRawJson());
  }

  Future<void> clearUser() async {
    await prefs.remove(_userKey);
  }

  static const _entriesKey = 'mona_cycle_entries';

  List<CycleEntry> getEntries() {
    final raw = prefs.getString(_entriesKey);
    if (raw == null) return [];
    try {
      final list = json.decode(raw) as List<dynamic>;
      return list
          .map((e) => CycleEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveEntry(CycleEntry entry) async {
    final list = getEntries();
    list.removeWhere((e) => e.id == entry.id);
    list.add(entry);
    final raw = json.encode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_entriesKey, raw);
  }

  Future<void> removeEntry(String id) async {
    final list = getEntries();
    list.removeWhere((e) => e.id == id);
    final raw = json.encode(list.map((e) => e.toJson()).toList());
    await prefs.setString(_entriesKey, raw);
  }
}
