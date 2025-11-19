/// 認證攔截器
///
/// 自動在請求標頭附加 Bearer Token
library;

import 'package:dio/dio.dart';

import 'package:money_manager/core/storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storageService);

  final SecureStorageService _storageService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 從 Secure Storage 讀取 access token
    final accessToken = await _storageService.getAccessToken();

    // 如果有 token,加入到 Authorization header
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 將錯誤傳遞給下一個攔截器
    handler.next(err);
  }
}
