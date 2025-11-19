// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_login_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GoogleLoginRequest _$GoogleLoginRequestFromJson(Map<String, dynamic> json) {
  return _GoogleLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$GoogleLoginRequest {
  String get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'code_verifier')
  String get codeVerifier => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_info')
  DeviceInfo? get deviceInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GoogleLoginRequestCopyWith<GoogleLoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GoogleLoginRequestCopyWith<$Res> {
  factory $GoogleLoginRequestCopyWith(
          GoogleLoginRequest value, $Res Function(GoogleLoginRequest) then) =
      _$GoogleLoginRequestCopyWithImpl<$Res, GoogleLoginRequest>;
  @useResult
  $Res call(
      {String code,
      @JsonKey(name: 'code_verifier') String codeVerifier,
      @JsonKey(name: 'device_info') DeviceInfo? deviceInfo});

  $DeviceInfoCopyWith<$Res>? get deviceInfo;
}

/// @nodoc
class _$GoogleLoginRequestCopyWithImpl<$Res, $Val extends GoogleLoginRequest>
    implements $GoogleLoginRequestCopyWith<$Res> {
  _$GoogleLoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? codeVerifier = null,
    Object? deviceInfo = freezed,
  }) {
    return _then(_value.copyWith(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      codeVerifier: null == codeVerifier
          ? _value.codeVerifier
          : codeVerifier // ignore: cast_nullable_to_non_nullable
              as String,
      deviceInfo: freezed == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as DeviceInfo?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DeviceInfoCopyWith<$Res>? get deviceInfo {
    if (_value.deviceInfo == null) {
      return null;
    }

    return $DeviceInfoCopyWith<$Res>(_value.deviceInfo!, (value) {
      return _then(_value.copyWith(deviceInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GoogleLoginRequestImplCopyWith<$Res>
    implements $GoogleLoginRequestCopyWith<$Res> {
  factory _$$GoogleLoginRequestImplCopyWith(_$GoogleLoginRequestImpl value,
          $Res Function(_$GoogleLoginRequestImpl) then) =
      __$$GoogleLoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String code,
      @JsonKey(name: 'code_verifier') String codeVerifier,
      @JsonKey(name: 'device_info') DeviceInfo? deviceInfo});

  @override
  $DeviceInfoCopyWith<$Res>? get deviceInfo;
}

/// @nodoc
class __$$GoogleLoginRequestImplCopyWithImpl<$Res>
    extends _$GoogleLoginRequestCopyWithImpl<$Res, _$GoogleLoginRequestImpl>
    implements _$$GoogleLoginRequestImplCopyWith<$Res> {
  __$$GoogleLoginRequestImplCopyWithImpl(_$GoogleLoginRequestImpl _value,
      $Res Function(_$GoogleLoginRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? codeVerifier = null,
    Object? deviceInfo = freezed,
  }) {
    return _then(_$GoogleLoginRequestImpl(
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String,
      codeVerifier: null == codeVerifier
          ? _value.codeVerifier
          : codeVerifier // ignore: cast_nullable_to_non_nullable
              as String,
      deviceInfo: freezed == deviceInfo
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as DeviceInfo?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GoogleLoginRequestImpl implements _GoogleLoginRequest {
  const _$GoogleLoginRequestImpl(
      {required this.code,
      @JsonKey(name: 'code_verifier') required this.codeVerifier,
      @JsonKey(name: 'device_info') this.deviceInfo});

  factory _$GoogleLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$GoogleLoginRequestImplFromJson(json);

  @override
  final String code;
  @override
  @JsonKey(name: 'code_verifier')
  final String codeVerifier;
  @override
  @JsonKey(name: 'device_info')
  final DeviceInfo? deviceInfo;

  @override
  String toString() {
    return 'GoogleLoginRequest(code: $code, codeVerifier: $codeVerifier, deviceInfo: $deviceInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleLoginRequestImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.codeVerifier, codeVerifier) ||
                other.codeVerifier == codeVerifier) &&
            (identical(other.deviceInfo, deviceInfo) ||
                other.deviceInfo == deviceInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, code, codeVerifier, deviceInfo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GoogleLoginRequestImplCopyWith<_$GoogleLoginRequestImpl> get copyWith =>
      __$$GoogleLoginRequestImplCopyWithImpl<_$GoogleLoginRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GoogleLoginRequestImplToJson(
      this,
    );
  }
}

abstract class _GoogleLoginRequest implements GoogleLoginRequest {
  const factory _GoogleLoginRequest(
          {required final String code,
          @JsonKey(name: 'code_verifier') required final String codeVerifier,
          @JsonKey(name: 'device_info') final DeviceInfo? deviceInfo}) =
      _$GoogleLoginRequestImpl;

  factory _GoogleLoginRequest.fromJson(Map<String, dynamic> json) =
      _$GoogleLoginRequestImpl.fromJson;

  @override
  String get code;
  @override
  @JsonKey(name: 'code_verifier')
  String get codeVerifier;
  @override
  @JsonKey(name: 'device_info')
  DeviceInfo? get deviceInfo;
  @override
  @JsonKey(ignore: true)
  _$$GoogleLoginRequestImplCopyWith<_$GoogleLoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) {
  return _DeviceInfo.fromJson(json);
}

/// @nodoc
mixin _$DeviceInfo {
  String get platform => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_agent')
  String get userAgent => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_id')
  String? get deviceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'app_version')
  String? get appVersion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DeviceInfoCopyWith<DeviceInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DeviceInfoCopyWith<$Res> {
  factory $DeviceInfoCopyWith(
          DeviceInfo value, $Res Function(DeviceInfo) then) =
      _$DeviceInfoCopyWithImpl<$Res, DeviceInfo>;
  @useResult
  $Res call(
      {String platform,
      @JsonKey(name: 'user_agent') String userAgent,
      @JsonKey(name: 'device_id') String? deviceId,
      @JsonKey(name: 'app_version') String? appVersion});
}

/// @nodoc
class _$DeviceInfoCopyWithImpl<$Res, $Val extends DeviceInfo>
    implements $DeviceInfoCopyWith<$Res> {
  _$DeviceInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = null,
    Object? userAgent = null,
    Object? deviceId = freezed,
    Object? appVersion = freezed,
  }) {
    return _then(_value.copyWith(
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      userAgent: null == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DeviceInfoImplCopyWith<$Res>
    implements $DeviceInfoCopyWith<$Res> {
  factory _$$DeviceInfoImplCopyWith(
          _$DeviceInfoImpl value, $Res Function(_$DeviceInfoImpl) then) =
      __$$DeviceInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String platform,
      @JsonKey(name: 'user_agent') String userAgent,
      @JsonKey(name: 'device_id') String? deviceId,
      @JsonKey(name: 'app_version') String? appVersion});
}

/// @nodoc
class __$$DeviceInfoImplCopyWithImpl<$Res>
    extends _$DeviceInfoCopyWithImpl<$Res, _$DeviceInfoImpl>
    implements _$$DeviceInfoImplCopyWith<$Res> {
  __$$DeviceInfoImplCopyWithImpl(
      _$DeviceInfoImpl _value, $Res Function(_$DeviceInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? platform = null,
    Object? userAgent = null,
    Object? deviceId = freezed,
    Object? appVersion = freezed,
  }) {
    return _then(_$DeviceInfoImpl(
      platform: null == platform
          ? _value.platform
          : platform // ignore: cast_nullable_to_non_nullable
              as String,
      userAgent: null == userAgent
          ? _value.userAgent
          : userAgent // ignore: cast_nullable_to_non_nullable
              as String,
      deviceId: freezed == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      appVersion: freezed == appVersion
          ? _value.appVersion
          : appVersion // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DeviceInfoImpl implements _DeviceInfo {
  const _$DeviceInfoImpl(
      {required this.platform,
      @JsonKey(name: 'user_agent') required this.userAgent,
      @JsonKey(name: 'device_id') this.deviceId,
      @JsonKey(name: 'app_version') this.appVersion});

  factory _$DeviceInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeviceInfoImplFromJson(json);

  @override
  final String platform;
  @override
  @JsonKey(name: 'user_agent')
  final String userAgent;
  @override
  @JsonKey(name: 'device_id')
  final String? deviceId;
  @override
  @JsonKey(name: 'app_version')
  final String? appVersion;

  @override
  String toString() {
    return 'DeviceInfo(platform: $platform, userAgent: $userAgent, deviceId: $deviceId, appVersion: $appVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DeviceInfoImpl &&
            (identical(other.platform, platform) ||
                other.platform == platform) &&
            (identical(other.userAgent, userAgent) ||
                other.userAgent == userAgent) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.appVersion, appVersion) ||
                other.appVersion == appVersion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, platform, userAgent, deviceId, appVersion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      __$$DeviceInfoImplCopyWithImpl<_$DeviceInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DeviceInfoImplToJson(
      this,
    );
  }
}

abstract class _DeviceInfo implements DeviceInfo {
  const factory _DeviceInfo(
          {required final String platform,
          @JsonKey(name: 'user_agent') required final String userAgent,
          @JsonKey(name: 'device_id') final String? deviceId,
          @JsonKey(name: 'app_version') final String? appVersion}) =
      _$DeviceInfoImpl;

  factory _DeviceInfo.fromJson(Map<String, dynamic> json) =
      _$DeviceInfoImpl.fromJson;

  @override
  String get platform;
  @override
  @JsonKey(name: 'user_agent')
  String get userAgent;
  @override
  @JsonKey(name: 'device_id')
  String? get deviceId;
  @override
  @JsonKey(name: 'app_version')
  String? get appVersion;
  @override
  @JsonKey(ignore: true)
  _$$DeviceInfoImplCopyWith<_$DeviceInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
