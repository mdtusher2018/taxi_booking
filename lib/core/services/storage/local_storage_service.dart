import 'package:taxi_booking/core/services/storage/i_local_storage_service.dart';
import 'package:taxi_booking/core/services/storage/storage_key.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LocalStorageService implements ILocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  late SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  Future<void> init() async => _prefs = await SharedPreferences.getInstance();

  @override
  Future<void> saveKey(StorageKey key, dynamic value) async {
    switch (key.type) {
      case StorageKeyType.string:
        await _prefs.setString(key.key, value as String);
        break;
      case StorageKeyType.secureString:
        await _secureStorage.write(key: key.key, value: value as String);
        break;
      case StorageKeyType.bool:
        await _prefs.setBool(key.key, value as bool);
        break;
      case StorageKeyType.int:
        await _prefs.setInt(key.key, value as int);
        break;
    }
  }

  @override
  Future<dynamic> readKey(StorageKey key) async {
    switch (key.type) {
      case StorageKeyType.string:
        return _prefs.getString(key.key);
      case StorageKeyType.secureString:
        return await _secureStorage.read(key: key.key);
      case StorageKeyType.bool:
        return _prefs.getBool(key.key);
      case StorageKeyType.int:
        return _prefs.getInt(key.key);
    }
  }

  @override
  Future<void> deleteKey(StorageKey key) async {
    if (key.type == StorageKeyType.secureString) {
      await _secureStorage.delete(key: key.key);
    } else {
      await _prefs.remove(key.key);
    }
  }

  @override
  Future<void> clearPrefs() async => await _prefs.clear();

  @override
  Future<void> clearSecure() async => await _secureStorage.deleteAll();

  @override
  Future<void> clearAll() async {
    await clearPrefs();
    await clearSecure();
  }
}
