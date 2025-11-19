/// 安全儲存服務
///
/// 封裝 flutter_secure_storage 提供 Token 和認證資訊的加密儲存
library;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  final FlutterSecureStorage _storage;

  // Storage keys
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyExpiresAt = 'expires_at';
  static const String _keyUserId = 'user_id';

  /// 儲存認證 tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required int expiresIn,
    String? userId,
  }) async {
    final expiresAt =
        DateTime.now().add(Duration(seconds: expiresIn)).toIso8601String();

    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
      _storage.write(key: _keyExpiresAt, value: expiresAt),
      if (userId != null) _storage.write(key: _keyUserId, value: userId),
    ]);
  }

  /// 取得 access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  /// 取得 refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  /// 取得 token 過期時間
  Future<DateTime?> getExpiresAt() async {
    final expiresAtStr = await _storage.read(key: _keyExpiresAt);
    if (expiresAtStr == null) return null;
    return DateTime.tryParse(expiresAtStr);
  }

  /// 取得使用者 ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// 檢查 token 是否已過期
  Future<bool> isTokenExpired() async {
    final expiresAt = await getExpiresAt();
    if (expiresAt == null) return true;
    return DateTime.now().isAfter(expiresAt);
  }

  /// 檢查是否需要刷新 token (距離過期時間不到 5 分鐘)
  Future<bool> needsRefresh() async {
    final expiresAt = await getExpiresAt();
    if (expiresAt == null) return true;
    final fiveMinutesBeforeExpiry =
        expiresAt.subtract(const Duration(minutes: 5));
    return DateTime.now().isAfter(fiveMinutesBeforeExpiry);
  }

  /// 清除所有認證資訊
  Future<void> clearAuth() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyExpiresAt),
      _storage.delete(key: _keyUserId),
    ]);
  }

  /// 清除所有儲存資料
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
