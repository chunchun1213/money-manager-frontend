/// 使用者資料模型
library;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum AuthProvider {
  @JsonValue('google')
  google,
  @JsonValue('facebook')
  facebook,
}

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String name,
    @JsonKey(name: 'provider') required AuthProvider provider,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    String? avatarUrl,
    @JsonKey(name: 'last_sign_in_at') DateTime? lastSignInAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
