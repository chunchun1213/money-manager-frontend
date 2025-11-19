/// Google 登入請求 DTO
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_login_request.freezed.dart';
part 'google_login_request.g.dart';

@freezed
class GoogleLoginRequest with _$GoogleLoginRequest {
  const factory GoogleLoginRequest({
    required String code,
    @JsonKey(name: 'code_verifier') required String codeVerifier,
    @JsonKey(name: 'device_info') DeviceInfo? deviceInfo,
  }) = _GoogleLoginRequest;

  factory GoogleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginRequestFromJson(json);
}

@freezed
class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    required String platform,
    @JsonKey(name: 'user_agent') required String userAgent,
    @JsonKey(name: 'device_id') String? deviceId,
    @JsonKey(name: 'app_version') String? appVersion,
  }) = _DeviceInfo;

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}
