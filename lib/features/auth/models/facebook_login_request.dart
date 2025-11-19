/// Facebook 登入請求 DTO
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:money_manager/features/auth/models/google_login_request.dart';

part 'facebook_login_request.freezed.dart';
part 'facebook_login_request.g.dart';

@freezed
class FacebookLoginRequest with _$FacebookLoginRequest {
  const factory FacebookLoginRequest({
    required String code,
    @JsonKey(name: 'code_verifier') required String codeVerifier,
    @JsonKey(name: 'device_info') DeviceInfo? deviceInfo,
  }) = _FacebookLoginRequest;

  factory FacebookLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$FacebookLoginRequestFromJson(json);
}
