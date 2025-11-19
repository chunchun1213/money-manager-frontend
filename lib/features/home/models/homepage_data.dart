/// 主頁資料模型
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:money_manager/features/auth/models/user.dart';

part 'homepage_data.freezed.dart';
part 'homepage_data.g.dart';

@freezed
class HomepageData with _$HomepageData {
  const factory HomepageData({
    required User user,
    required ConstructionContent content,
  }) = _HomepageData;

  factory HomepageData.fromJson(Map<String, dynamic> json) =>
      _$HomepageDataFromJson(json);
}

@freezed
class ConstructionContent with _$ConstructionContent {
  const factory ConstructionContent({
    required String message,
    required String icon,
  }) = _ConstructionContent;

  factory ConstructionContent.fromJson(Map<String, dynamic> json) =>
      _$ConstructionContentFromJson(json);
}
