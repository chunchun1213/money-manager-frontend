/// API 錯誤模型
///
/// 封裝後端 API 回傳的錯誤資訊
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';
part 'api_error.g.dart';

@freezed
class ApiError with _$ApiError {
  const factory ApiError({
    required String error,
    required String message,
    required DateTime timestamp,
    Map<String, dynamic>? details,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}
