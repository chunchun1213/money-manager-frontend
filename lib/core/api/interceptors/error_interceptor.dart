/// 錯誤處理攔截器
///
/// 統一處理 API 錯誤並轉換為友善的繁體中文錯誤訊息
library;

import 'package:dio/dio.dart';

import 'package:money_manager/core/api/models/api_error.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = '網路連線逾時,請檢查網路設定';
        break;

      case DioExceptionType.connectionError:
        message = '網路連線失敗,請檢查網路設定';
        break;

      case DioExceptionType.badResponse:
        // 嘗試解析後端錯誤訊息
        if (err.response?.data != null) {
          try {
            final apiError =
                ApiError.fromJson(err.response!.data as Map<String, dynamic>);
            message = apiError.message;
          } catch (_) {
            message = _getDefaultErrorMessage(err.response!.statusCode);
          }
        } else {
          message = _getDefaultErrorMessage(err.response?.statusCode);
        }
        break;

      case DioExceptionType.cancel:
        message = '請求已取消';
        break;

      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        message = '發生未知錯誤,請稍後再試';
    }

    // 建立包含友善訊息的新錯誤
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: message,
      message: message,
    );

    handler.next(newError);
  }

  String _getDefaultErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return '請求參數錯誤';
      case 401:
        return '未授權,請重新登入';
      case 403:
        return '無權限存取此資源';
      case 404:
        return '請求的資源不存在';
      case 500:
        return '伺服器錯誤,請稍後再試';
      case 503:
        return '服務暫時無法使用,請稍後再試';
      default:
        return '發生錯誤 (${statusCode ?? 'unknown'}),請稍後再試';
    }
  }
}
