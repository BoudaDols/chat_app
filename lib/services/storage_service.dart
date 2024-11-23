import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import 'dart:convert';

class StorageService {
  final FlutterSecureStorage _secureStorage;
  final encrypt.Key _key;
  final encrypt.IV _iv;
  
  StorageService() : 
    _secureStorage = const FlutterSecureStorage(),
    _key = encrypt.Key.fromSecureRandom(32),
    _iv = encrypt.IV.fromSecureRandom(16);

  // Encrypt data
  String _encryptData(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    return encrypter.encrypt(data, iv: _iv).base64;
  }

  // Decrypt data
  String _decryptData(String encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    return encrypter.decrypt64(encryptedData, iv: _iv);
  }

  // Hash sensitive data (like passwords)
  String _hashData(String data) {
    final bytes = utf8.encode(data);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // Store sensitive data securely
  Future<void> storeSecureData(String key, String value) async {
    final encryptedValue = _encryptData(value);
    await _secureStorage.write(key: key, value: encryptedValue);
  }

  // Retrieve sensitive data
  Future<String?> getSecureData(String key) async {
    final encryptedValue = await _secureStorage.read(key: key);
    if (encryptedValue == null) return null;
    return _decryptData(encryptedValue);
  }

  // Delete sensitive data
  Future<void> deleteSecureData(String key) async {
    await _secureStorage.delete(key: key);
  }

  // Store user session data
  Future<void> storeUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(userData);
    final encryptedData = _encryptData(userJson);
    await prefs.setString('user_session', encryptedData);
  }

  // Get user session data
  Future<Map<String, dynamic>?> getUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    final encryptedData = prefs.getString('user_session');
    if (encryptedData == null) return null;
    
    final decryptedData = _decryptData(encryptedData);
    return json.decode(decryptedData);
  }

  // Clear user session
  Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_session');
  }

  // Store user preferences (non-sensitive data)
  Future<void> storePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  // Get user preference
  Future<dynamic> getPreference(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.get(key);
  }
}