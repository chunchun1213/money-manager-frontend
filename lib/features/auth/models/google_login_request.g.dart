// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GoogleLoginRequestImpl _$$GoogleLoginRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$GoogleLoginRequestImpl(
      code: json['code'] as String,
      codeVerifier: json['code_verifier'] as String,
      deviceInfo: json['device_info'] == null
          ? null
          : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GoogleLoginRequestImplToJson(
        _$GoogleLoginRequestImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'code_verifier': instance.codeVerifier,
      'device_info': instance.deviceInfo,
    };

_$DeviceInfoImpl _$$DeviceInfoImplFromJson(Map<String, dynamic> json) =>
    _$DeviceInfoImpl(
      platform: json['platform'] as String,
      userAgent: json['user_agent'] as String,
      deviceId: json['device_id'] as String?,
      appVersion: json['app_version'] as String?,
    );

Map<String, dynamic> _$$DeviceInfoImplToJson(_$DeviceInfoImpl instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'user_agent': instance.userAgent,
      'device_id': instance.deviceId,
      'app_version': instance.appVersion,
    };
