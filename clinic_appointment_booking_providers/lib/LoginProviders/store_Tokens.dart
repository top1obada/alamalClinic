import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreTokensService {
  static Future<void> save(String jWTToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('jWTToken', jWTToken);
    await prefs.setString('refreshToken', refreshToken);
    debugPrint("Saved");
  }

  static Future<Map<String, String>?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final jWTToken = prefs.getString('jWTToken');
    final refreshToken = prefs.getString('refreshToken');
    if (jWTToken != null && refreshToken != null) {
      return {"jWTToken": jWTToken, "refreshToken": refreshToken};
    }
    return null;
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jWTToken');
    await prefs.remove('refreshToken');
    debugPrint("Cleared");
  }
}
