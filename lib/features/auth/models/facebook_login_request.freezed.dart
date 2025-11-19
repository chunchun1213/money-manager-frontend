// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facebook_login_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FacebookLoginRequest _$FacebookLoginRequestFromJson(Map<String, dynamic> json) {
  return _FacebookLoginRequest.fromJson(json);
}

/// @nodoc
mixin _$FacebookLoginRequest {
  String get code => throw _privateConstructorUsedError;
  @JsonKey(name: 'code_verifier')
  String get codeVerifier => throw _privateConstructorUsedError;
  @JsonKey(name: 'device_info')
  DeviceInfo? get deviceInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FacebookLoginRequestCopyWith<FacebookLoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacebookLoginRequestCopyWith<$Res> {
  factory $FacebookLoginRequestCopyWith(FacebookLoginRequest value,
          $Res Function(FacebookLoginRequest) then) =
      _$FacebookLoginRequestCopyWithImpl<$Res, FacebookLoginRequest>;
  @useResult
  $Res call(
      {String code,
      @JsonKey(name: 'code_verifier') String codeVerifier,
      @JsonKey(name: 'device_info') DeviceInfo? deviceInfo});

  $DeviceInfoCopyWith<$Res>? get deviceInfo;
}

/// @nodoc
class _$FacebookLoginRequestCopyWithImpl<$Res,
        $Val extends FacebookLoginRequest>
    implements $FacebookLoginRequestCopyWith<$Res> {
  _$FacebookLoginRequestCopyWithImpl(this._value, this._then);

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
abstract class _$$FacebookLoginRequestImplCopyWith<$Res>
    implements $FacebookLoginRequestCopyWith<$Res> {
  factory _$$FacebookLoginRequestImplCopyWith(_$FacebookLoginRequestImpl value,
          $Res Function(_$FacebookLoginRequestImpl) then) =
      __$$FacebookLoginRequestImplCopyWithImpl<$Res>;
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
class __$$FacebookLoginRequestImplCopyWithImpl<$Res>
    extends _$FacebookLoginRequestCopyWithImpl<$Res, _$FacebookLoginRequestImpl>
    implements _$$FacebookLoginRequestImplCopyWith<$Res> {
  __$$FacebookLoginRequestImplCopyWithImpl(_$FacebookLoginRequestImpl _value,
      $Res Function(_$FacebookLoginRequestImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = null,
    Object? codeVerifier = null,
    Object? deviceInfo = freezed,
  }) {
    return _then(_$FacebookLoginRequestImpl(
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
class _$FacebookLoginRequestImpl implements _FacebookLoginRequest {
  const _$FacebookLoginRequestImpl(
      {required this.code,
      @JsonKey(name: 'code_verifier') required this.codeVerifier,
      @JsonKey(name: 'device_info') this.deviceInfo});

  factory _$FacebookLoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacebookLoginRequestImplFromJson(json);

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
    return 'FacebookLoginRequest(code: $code, codeVerifier: $codeVerifier, deviceInfo: $deviceInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacebookLoginRequestImpl &&
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
  _$$FacebookLoginRequestImplCopyWith<_$FacebookLoginRequestImpl>
      get copyWith =>
          __$$FacebookLoginRequestImplCopyWithImpl<_$FacebookLoginRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacebookLoginRequestImplToJson(
      this,
    );
  }
}

abstract class _FacebookLoginRequest implements FacebookLoginRequest {
  const factory _FacebookLoginRequest(
          {required final String code,
          @JsonKey(name: 'code_verifier') required final String codeVerifier,
          @JsonKey(name: 'device_info') final DeviceInfo? deviceInfo}) =
      _$FacebookLoginRequestImpl;

  factory _FacebookLoginRequest.fromJson(Map<String, dynamic> json) =
      _$FacebookLoginRequestImpl.fromJson;

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
  _$$FacebookLoginRequestImplCopyWith<_$FacebookLoginRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
