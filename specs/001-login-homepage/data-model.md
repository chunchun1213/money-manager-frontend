# 資料模型: 登入與主頁功能

**建立日期**: 2025-01-19  
**功能分支**: `001-login-homepage`  
**目的**: 定義前端應用程式的資料實體、狀態模型和驗證規則

---

## 模型總覽

本功能涉及以下核心資料模型：

1. **User** - 使用者帳號資訊
2. **AuthState** - 認證狀態 (Sealed Union Type)
3. **LoginRequest** - 登入請求資料
4. **LoginResponse** - 登入回應資料
5. **Session** - 會話資訊
6. **HomepageData** - 主頁資料

---

## 1. User (使用者)

### 用途
代表已認證的使用者，包含從 OAuth provider 和後端 API 取得的使用者資訊。

### 欄位定義

| 欄位名稱 | 類型 | 必填 | 說明 | 來源 |
|---------|------|------|------|------|
| `id` | String (UUID) | ✅ | 使用者唯一識別碼 | Supabase Auth |
| `email` | String | ✅ | 使用者電子郵件 | OAuth Provider |
| `name` | String | ✅ | 使用者顯示名稱 | OAuth Provider |
| `avatarUrl` | String? | ❌ | 使用者頭像 URL | OAuth Provider |
| `provider` | AuthProvider | ✅ | OAuth 提供者 (google/facebook) | Supabase Auth |
| `createdAt` | DateTime | ✅ | 帳號建立時間 | 後端 API |
| `lastSignInAt` | DateTime? | ❌ | 最後登入時間 | 後端 API |

### 驗證規則

- `id`: 必須符合 UUID 格式 (`^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$`)
- `email`: 必須符合 email 格式 (使用 `EmailValidator`)
- `name`: 不可為空字串，長度 1-100 字元
- `avatarUrl`: 若提供則必須為有效 URL (https)
- `provider`: 只能是 `google` 或 `facebook`

### Dart 實作

```dart
// lib/features/auth/models/user.dart
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
    String? avatarUrl,
    required AuthProvider provider,
    required DateTime createdAt,
    DateTime? lastSignInAt,
  }) = _User;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### 狀態轉換

```
[未登入] --OAuth 成功--> [已建立 User]
[已建立 User] --登出--> [User 清除]
[已建立 User] --Token 過期--> [User 清除 + 導向登入]
```

---

## 2. AuthState (認證狀態)

### 用途
使用 Sealed Union Type 表示應用程式的認證狀態，確保狀態處理的完整性和類型安全。

### 狀態定義

| 狀態名稱 | 說明 | 包含資料 | UI 行為 |
|---------|------|----------|---------|
| `Unauthenticated` | 未登入 | 無 | 顯示登入頁面 |
| `Loading` | 載入中 | 無 | 顯示載入指示器 |
| `Authenticated` | 已認證 | User 物件 | 顯示主頁 |
| `Error` | 錯誤 | 錯誤訊息 | 顯示錯誤提示 |

### Dart 實作

```dart
// lib/features/auth/models/auth_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_manager/features/auth/models/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  /// 未登入狀態
  const factory AuthState.unauthenticated() = Unauthenticated;
  
  /// 載入中狀態 (登入、登出、驗證過程)
  const factory AuthState.loading() = Loading;
  
  /// 已認證狀態
  const factory AuthState.authenticated(User user) = Authenticated;
  
  /// 錯誤狀態
  const factory AuthState.error(String message) = AuthError;
}
```

### 狀態轉換圖

```
[Unauthenticated]
    |
    | 使用者點擊登入按鈕
    v
[Loading]
    |
    +--OAuth 成功--> [Authenticated(user)]
    |
    +--OAuth 失敗--> [Error(message)] --使用者重試--> [Unauthenticated]
    
[Authenticated(user)]
    |
    | 使用者點擊登出
    v
[Loading] --登出完成--> [Unauthenticated]
    
[Authenticated(user)]
    |
    | Token 過期
    v
[Error(message)] --自動清理--> [Unauthenticated]
```

---

## 3. LoginRequest (登入請求)

### 用途
封裝發送給後端 API 的登入請求資料。

### 欄位定義

#### GoogleLoginRequest

| 欄位名稱 | 類型 | 必填 | 說明 | 限制 |
|---------|------|------|------|------|
| `code` | String | ✅ | Google OAuth authorization code | 不可為空 |
| `codeVerifier` | String | ✅ | PKCE code verifier | 43-128 字元 |
| `deviceInfo` | DeviceInfo? | ❌ | 裝置資訊 | - |

#### FacebookLoginRequest

| 欄位名稱 | 類型 | 必填 | 說明 | 限制 |
|---------|------|------|------|------|
| `code` | String | ✅ | Facebook OAuth authorization code | 不可為空 |
| `codeVerifier` | String | ✅ | PKCE code verifier | 43-128 字元 |
| `deviceInfo` | DeviceInfo? | ❌ | 裝置資訊 | - |

#### DeviceInfo (子模型)

| 欄位名稱 | 類型 | 必填 | 說明 |
|---------|------|------|------|
| `platform` | String | ✅ | 平台資訊 (如 "iOS 17.0", "Android 14") |
| `userAgent` | String | ✅ | HTTP User-Agent 字串 |
| `deviceId` | String? | ❌ | 裝置唯一識別碼 (用於多裝置管理) |
| `appVersion` | String? | ❌ | App 版本號 (如 "1.0.0") |

### 驗證規則

- `platform`: 必須符合 "iOS X.X" 或 "Android XX" 格式
- `userAgent`: 標準 HTTP User-Agent 字串,不可為空
- `deviceId`: 若提供則用於識別同一裝置的多次登入
- `appVersion`: 若提供則必須符合 SemVer 格式 (X.Y.Z)

### Dart 實作

```dart
// lib/features/auth/models/login_request.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.freezed.dart';
part 'login_request.g.dart';

@freezed
class GoogleLoginRequest with _$GoogleLoginRequest {
  const factory GoogleLoginRequest({
    required String code,
    @JsonKey(name: 'code_verifier') required String codeVerifier,
    @JsonKey(name: 'device_info') DeviceInfo? deviceInfo,
  }) = _GoogleLoginRequest;
  
  factory GoogleLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleLoginRequestFromJson(json);
}

@freezed
class FacebookLoginRequest with _$FacebookLoginRequest {
  const factory FacebookLoginRequest({
    required String code,
    @JsonKey(name: 'code_verifier') required String codeVerifier,
    @JsonKey(name: 'device_info') DeviceInfo? deviceInfo,
  }) = _FacebookLoginRequest;
  
  factory FacebookLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$FacebookLoginRequestFromJson(json);
}

@freezed
class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    required String platform,
    @JsonKey(name: 'user_agent') required String userAgent,
    @JsonKey(name: 'device_id') String? deviceId,
    @JsonKey(name: 'app_version') String? appVersion,
  }) = _DeviceInfo;
  
  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);
}
```

---

## 4. LoginResponse (登入回應)

### 用途
封裝從後端 API 接收的登入回應資料，包含 JWT token 和使用者資訊。

### 欄位定義

| 欄位名稱 | 類型 | 必填 | 說明 | 範例 |
|---------|------|------|------|------|
| `accessToken` | String | ✅ | JWT access token (短期有效，1 小時) | `eyJhbGc...` |
| `refreshToken` | String | ✅ | Refresh token (長期有效，30 天) | `eyJhbGc...` |
| `tokenType` | String | ✅ | Token 類型 | `"Bearer"` |
| `expiresIn` | int | ✅ | Access token 有效期限 (秒) | `3600` |
| `user` | User | ✅ | 使用者資訊 | - |

### 驗證規則

- `accessToken`: 必須符合 JWT 格式 (三部分以 `.` 分隔)
- `refreshToken`: 必須符合 JWT 格式
- `tokenType`: 必須為 `"Bearer"`
- `expiresIn`: 必須 > 0

### Dart 實作

```dart
// lib/features/auth/models/login_response.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:money_manager/features/auth/models/user.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') required String tokenType,
    @JsonKey(name: 'expires_in') required int expiresIn,
    required User user,
  }) = _LoginResponse;
  
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
```

---

## 5. Session (會話資訊)

### 用途
代表使用者的登入會話，包含 token 和過期時間。

### 欄位定義

| 欄位名稱 | 類型 | 必填 | 說明 |
|---------|------|------|------|
| `accessToken` | String | ✅ | 當前有效的 access token |
| `refreshToken` | String | ✅ | 當前有效的 refresh token |
| `expiresAt` | DateTime | ✅ | Access token 過期時間 |
| `userId` | String | ✅ | 關聯的使用者 ID |

### 驗證規則

- `expiresAt`: 必須是未來的時間
- `userId`: 必須符合 UUID 格式

### Dart 實作

```dart
// lib/features/auth/models/session.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';
part 'session.g.dart';

@freezed
class Session with _$Session {
  const factory Session({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_at') required DateTime expiresAt,
    @JsonKey(name: 'user_id') required String userId,
  }) = _Session;
  
  const Session._();
  
  /// 檢查 session 是否已過期
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  
  /// 檢查是否需要更新 token (距離過期時間不到 5 分鐘)
  bool get needsRefresh {
    final now = DateTime.now();
    final fiveMinutesBeforeExpiry = expiresAt.subtract(const Duration(minutes: 5));
    return now.isAfter(fiveMinutesBeforeExpiry);
  }
  
  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);
}
```

---

## 6. HomepageData (主頁資料)

### 用途
封裝主頁所需的資料 (目前為施工中佔位資料)。

### 欄位定義

| 欄位名稱 | 類型 | 必填 | 說明 |
|---------|------|------|------|
| `user` | User | ✅ | 使用者基本資訊 |
| `content` | ConstructionContent | ✅ | 施工中內容 |

#### ConstructionContent (子模型)

| 欄位名稱 | 類型 | 必填 | 說明 |
|---------|------|------|------|
| `message` | String | ✅ | 施工訊息文字 |
| `icon` | String | ✅ | 施工圖示 emoji |

### Dart 實作

```dart
// lib/features/home/models/homepage_data.dart
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
```

---

## 7. API 錯誤模型

### 用途
封裝後端 API 回傳的錯誤資訊。

### 欄位定義

| 欄位名稱 | 類型 | 必填 | 說明 |
|---------|------|------|------|
| `error` | String | ✅ | 錯誤碼 (機器可讀) |
| `message` | String | ✅ | 錯誤訊息 (使用者可讀，繁體中文) |
| `details` | Map<String, dynamic>? | ❌ | 額外錯誤詳情 |
| `timestamp` | DateTime | ✅ | 錯誤發生時間 |

### 常見錯誤碼

| 錯誤碼 | 說明 | 處理方式 |
|-------|------|----------|
| `INVALID_OAUTH_TOKEN` | OAuth token 無效或過期 | 提示使用者重新登入 |
| `MISSING_PARAMETER` | 缺少必填參數 | 顯示欄位驗證錯誤 |
| `INVALID_FORMAT` | 參數格式錯誤 | 顯示格式要求 |
| `INVALID_TOKEN` | JWT token 無效 | 清除 session，導向登入 |
| `EXPIRED_TOKEN` | JWT token 已過期 | 嘗試使用 refresh token 更新 |
| `REVOKED_TOKEN` | Token 已被撤銷 | 清除 session，導向登入 |
| `INTERNAL_SERVER_ERROR` | 伺服器內部錯誤 | 顯示通用錯誤訊息 |

### Dart 實作

```dart
// lib/core/api/models/api_error.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';
part 'api_error.g.dart';

@freezed
class ApiError with _$ApiError {
  const factory ApiError({
    required String error,
    required String message,
    Map<String, dynamic>? details,
    required DateTime timestamp,
  }) = _ApiError;
  
  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}
```

---

## 總結

### 模型關係圖

```
LoginResponse
    ├─ accessToken: String
    ├─ refreshToken: String
    ├─ tokenType: String
    ├─ expiresIn: int
    └─ user: User
           ├─ id: String
           ├─ email: String
           ├─ name: String
           ├─ avatarUrl: String?
           ├─ provider: AuthProvider
           ├─ createdAt: DateTime
           └─ lastSignInAt: DateTime?

AuthState (Sealed Union)
    ├─ Unauthenticated
    ├─ Loading
    ├─ Authenticated(User)
    └─ Error(String)

Session
    ├─ accessToken: String
    ├─ refreshToken: String
    ├─ expiresAt: DateTime
    └─ userId: String

HomepageData
    ├─ user: User
    └─ content: ConstructionContent
                 ├─ message: String
                 └─ icon: String
```

### 必要套件

```yaml
# pubspec.yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.0

dev_dependencies:
  freezed: ^2.4.5
  json_serializable: ^6.7.0
  build_runner: ^2.4.0
```

### 程式碼產生指令

```bash
# 產生 Freezed 和 JSON 序列化程式碼
flutter pub run build_runner build --delete-conflicting-outputs
```

### 驗證策略

所有模型應在建構時驗證：
- 使用 `assert` 檢查必要欄位
- 使用 factory constructor 進行複雜驗證
- 整合 `fpdart` 或 `dartz` 函式庫進行 Either/Option 型別安全處理

### 測試策略

每個模型都應包含：
- JSON 序列化/反序列化測試
- 驗證規則測試
- 邊界條件測試 (null、空字串、極值)
