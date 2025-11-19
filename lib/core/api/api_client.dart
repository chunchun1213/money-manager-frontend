/// API 客戶端介面
///
/// 使用 Retrofit 定義所有後端 API 端點
library;

import 'package:dio/dio.dart';
import 'package:money_manager/features/auth/models/facebook_login_request.dart';
import 'package:money_manager/features/auth/models/google_login_request.dart';
import 'package:money_manager/features/auth/models/login_response.dart';
import 'package:money_manager/features/home/models/homepage_data.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  /// Google OAuth 登入
  @POST('/auth/login/google')
  Future<LoginResponse> loginWithGoogle(
    @Body() GoogleLoginRequest request,
  );

  /// Facebook OAuth 登入
  @POST('/auth/login/facebook')
  Future<LoginResponse> loginWithFacebook(
    @Body() FacebookLoginRequest request,
  );

  /// 登出
  @POST('/auth/logout')
  Future<void> logout();

  /// 驗證 Token
  @GET('/auth/verify')
  Future<void> verifyToken();

  /// 刷新 Token
  @POST('/auth/refresh')
  Future<LoginResponse> refreshToken(
    @Body() Map<String, String> body,
  );

  /// 取得主頁資料
  @GET('/homepage')
  Future<HomepageData> getHomepage();

  /// 刪除使用者帳號
  @DELETE('/user/delete')
  Future<void> deleteUser();
}
