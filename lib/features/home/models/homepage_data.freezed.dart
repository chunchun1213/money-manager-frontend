// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'homepage_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HomepageData _$HomepageDataFromJson(Map<String, dynamic> json) {
  return _HomepageData.fromJson(json);
}

/// @nodoc
mixin _$HomepageData {
  User get user => throw _privateConstructorUsedError;
  ConstructionContent get content => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HomepageDataCopyWith<HomepageData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomepageDataCopyWith<$Res> {
  factory $HomepageDataCopyWith(
          HomepageData value, $Res Function(HomepageData) then) =
      _$HomepageDataCopyWithImpl<$Res, HomepageData>;
  @useResult
  $Res call({User user, ConstructionContent content});

  $UserCopyWith<$Res> get user;
  $ConstructionContentCopyWith<$Res> get content;
}

/// @nodoc
class _$HomepageDataCopyWithImpl<$Res, $Val extends HomepageData>
    implements $HomepageDataCopyWith<$Res> {
  _$HomepageDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as ConstructionContent,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ConstructionContentCopyWith<$Res> get content {
    return $ConstructionContentCopyWith<$Res>(_value.content, (value) {
      return _then(_value.copyWith(content: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$HomepageDataImplCopyWith<$Res>
    implements $HomepageDataCopyWith<$Res> {
  factory _$$HomepageDataImplCopyWith(
          _$HomepageDataImpl value, $Res Function(_$HomepageDataImpl) then) =
      __$$HomepageDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({User user, ConstructionContent content});

  @override
  $UserCopyWith<$Res> get user;
  @override
  $ConstructionContentCopyWith<$Res> get content;
}

/// @nodoc
class __$$HomepageDataImplCopyWithImpl<$Res>
    extends _$HomepageDataCopyWithImpl<$Res, _$HomepageDataImpl>
    implements _$$HomepageDataImplCopyWith<$Res> {
  __$$HomepageDataImplCopyWithImpl(
      _$HomepageDataImpl _value, $Res Function(_$HomepageDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? content = null,
  }) {
    return _then(_$HomepageDataImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as ConstructionContent,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HomepageDataImpl implements _HomepageData {
  const _$HomepageDataImpl({required this.user, required this.content});

  factory _$HomepageDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$HomepageDataImplFromJson(json);

  @override
  final User user;
  @override
  final ConstructionContent content;

  @override
  String toString() {
    return 'HomepageData(user: $user, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomepageDataImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, user, content);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomepageDataImplCopyWith<_$HomepageDataImpl> get copyWith =>
      __$$HomepageDataImplCopyWithImpl<_$HomepageDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HomepageDataImplToJson(
      this,
    );
  }
}

abstract class _HomepageData implements HomepageData {
  const factory _HomepageData(
      {required final User user,
      required final ConstructionContent content}) = _$HomepageDataImpl;

  factory _HomepageData.fromJson(Map<String, dynamic> json) =
      _$HomepageDataImpl.fromJson;

  @override
  User get user;
  @override
  ConstructionContent get content;
  @override
  @JsonKey(ignore: true)
  _$$HomepageDataImplCopyWith<_$HomepageDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConstructionContent _$ConstructionContentFromJson(Map<String, dynamic> json) {
  return _ConstructionContent.fromJson(json);
}

/// @nodoc
mixin _$ConstructionContent {
  String get message => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ConstructionContentCopyWith<ConstructionContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConstructionContentCopyWith<$Res> {
  factory $ConstructionContentCopyWith(
          ConstructionContent value, $Res Function(ConstructionContent) then) =
      _$ConstructionContentCopyWithImpl<$Res, ConstructionContent>;
  @useResult
  $Res call({String message, String icon});
}

/// @nodoc
class _$ConstructionContentCopyWithImpl<$Res, $Val extends ConstructionContent>
    implements $ConstructionContentCopyWith<$Res> {
  _$ConstructionContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? icon = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConstructionContentImplCopyWith<$Res>
    implements $ConstructionContentCopyWith<$Res> {
  factory _$$ConstructionContentImplCopyWith(_$ConstructionContentImpl value,
          $Res Function(_$ConstructionContentImpl) then) =
      __$$ConstructionContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String icon});
}

/// @nodoc
class __$$ConstructionContentImplCopyWithImpl<$Res>
    extends _$ConstructionContentCopyWithImpl<$Res, _$ConstructionContentImpl>
    implements _$$ConstructionContentImplCopyWith<$Res> {
  __$$ConstructionContentImplCopyWithImpl(_$ConstructionContentImpl _value,
      $Res Function(_$ConstructionContentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? icon = null,
  }) {
    return _then(_$ConstructionContentImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConstructionContentImpl implements _ConstructionContent {
  const _$ConstructionContentImpl({required this.message, required this.icon});

  factory _$ConstructionContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConstructionContentImplFromJson(json);

  @override
  final String message;
  @override
  final String icon;

  @override
  String toString() {
    return 'ConstructionContent(message: $message, icon: $icon)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConstructionContentImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.icon, icon) || other.icon == icon));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, message, icon);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConstructionContentImplCopyWith<_$ConstructionContentImpl> get copyWith =>
      __$$ConstructionContentImplCopyWithImpl<_$ConstructionContentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConstructionContentImplToJson(
      this,
    );
  }
}

abstract class _ConstructionContent implements ConstructionContent {
  const factory _ConstructionContent(
      {required final String message,
      required final String icon}) = _$ConstructionContentImpl;

  factory _ConstructionContent.fromJson(Map<String, dynamic> json) =
      _$ConstructionContentImpl.fromJson;

  @override
  String get message;
  @override
  String get icon;
  @override
  @JsonKey(ignore: true)
  _$$ConstructionContentImplCopyWith<_$ConstructionContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
