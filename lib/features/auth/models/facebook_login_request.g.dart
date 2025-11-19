// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facebook_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FacebookLoginRequestImpl _$$FacebookLoginRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$FacebookLoginRequestImpl(
      code: json['code'] as String,
      codeVerifier: json['code_verifier'] as String,
      deviceInfo: json['device_info'] == null
          ? null
          : DeviceInfo.fromJson(json['device_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FacebookLoginRequestImplToJson(
        _$FacebookLoginRequestImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'code_verifier': instance.codeVerifier,
      'device_info': instance.deviceInfo,
    };
