/// Token 刷新攔截器
///
/// 當收到 401 錯誤時,自動使用 refresh token 更新 access token 並重試請求
library;

import 'package:dio/dio.dart';

import 'package:money_manager/core/api/api_client.dart';
import 'package:money_manager/core/storage/secure_storage_service.dart';

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor(this._dio, this._storageService);

  final Dio _dio;
  final SecureStorageService _storageService;
  bool _isRefreshing = false;
  final List<({RequestOptions options, ErrorInterceptorHandler handler})>
      _requestQueue = [];

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 只處理 401 未授權錯誤
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // 如果是刷新 token 的請求失敗,不再重試
    if (err.requestOptions.path.contains('/auth/refresh')) {
      await _storageService.clearAuth();
      return handler.next(err);
    }

    // 如果正在刷新 token,將請求加入佇列
    if (_isRefreshing) {
      _requestQueue.add((options: err.requestOptions, handler: handler));
      return;
    }

    _isRefreshing = true;

    try {
      // 取得 refresh token
      final refreshToken = await _storageService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        await _storageService.clearAuth();
        return handler.next(err);
      }

      // 建立新的 Dio 實例避免循環呼叫
      final dio = Dio(_dio.options);
      final apiClient = ApiClient(dio);

      // 呼叫刷新 token API
      final response = await apiClient.refreshToken({
        'refresh_token': refreshToken,
      });

      // 儲存新的 tokens
      await _storageService.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        expiresIn: response.expiresIn,
      );

      // 更新原始請求的 Authorization header
      err.requestOptions.headers['Authorization'] =
          'Bearer ${response.accessToken}';

      // 重試原始請求
      final retryResponse = await _dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(retryResponse);

      // 處理佇列中的請求
      for (final item in _requestQueue) {
        item.options.headers['Authorization'] =
            'Bearer ${response.accessToken}';
        final queueResponse = await _dio.fetch<dynamic>(item.options);
        item.handler.resolve(queueResponse);
      }
      _requestQueue.clear();
    } catch (e) {
      // 刷新失敗,清除認證資訊
      await _storageService.clearAuth();

      // 拒絕佇列中的所有請求
      for (final item in _requestQueue) {
        item.handler.next(err);
      }
      _requestQueue.clear();

      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }
}
