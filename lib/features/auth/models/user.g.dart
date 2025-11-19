// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      provider: $enumDecode(_$AuthProviderEnumMap, json['provider']),
      createdAt: DateTime.parse(json['created_at'] as String),
      avatarUrl: json['avatarUrl'] as String?,
      lastSignInAt: json['last_sign_in_at'] == null
          ? null
          : DateTime.parse(json['last_sign_in_at'] as String),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'provider': _$AuthProviderEnumMap[instance.provider]!,
      'created_at': instance.createdAt.toIso8601String(),
      'avatarUrl': instance.avatarUrl,
      'last_sign_in_at': instance.lastSignInAt?.toIso8601String(),
    };

const _$AuthProviderEnumMap = {
  AuthProvider.google: 'google',
  AuthProvider.facebook: 'facebook',
};
