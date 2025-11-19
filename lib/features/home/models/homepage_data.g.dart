// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homepage_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HomepageDataImpl _$$HomepageDataImplFromJson(Map<String, dynamic> json) =>
    _$HomepageDataImpl(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      content:
          ConstructionContent.fromJson(json['content'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$HomepageDataImplToJson(_$HomepageDataImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'content': instance.content,
    };

_$ConstructionContentImpl _$$ConstructionContentImplFromJson(
        Map<String, dynamic> json) =>
    _$ConstructionContentImpl(
      message: json['message'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$$ConstructionContentImplToJson(
        _$ConstructionContentImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'icon': instance.icon,
    };
