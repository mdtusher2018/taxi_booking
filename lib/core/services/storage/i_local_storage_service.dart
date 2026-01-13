import 'package:taxi_booking/core/services/storage/storage_key.dart';

abstract class ILocalStorageService {
  Future<void> saveKey(StorageKey key, dynamic value);
  Future<dynamic> readKey(StorageKey key);
  Future<void> deleteKey(StorageKey key);
  Future<void> clearPrefs();
  Future<void> clearSecure();
  Future<void> clearAll();
}
