/// Dio HTTP 客戶端配置
///
/// 提供統一的 HTTP 客戶端實例,包含基礎設定
library;

import 'package:dio/dio.dart';

import 'package:money_manager/config/env.dart';

class DioConfig {
  DioConfig._();

  /// 建立配置好的 Dio 實例
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        validateStatus: (status) {
          // 接受 2xx 和 401 狀態碼 (401 會由 RefreshTokenInterceptor 處理)
          return status != null &&
              (status >= 200 && status < 300 || status == 401);
        },
      ),
    );

    // 在開發模式下啟用日誌
    if (Env.isDevelopment) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: false,
        ),
      );
    }

    return dio;
  }
}
