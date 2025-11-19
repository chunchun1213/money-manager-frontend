# 實作計畫: 登入與主頁功能

**Branch**: `001-login-homepage` | **Date**: 2025-01-19 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `/specs/001-login-homepage/spec.md`

## Summary

本功能實作 Money Manager 前端應用程式的登入與主頁功能，支援 Google 和 Facebook 社交帳號登入、自動登入、登出功能，以及施工中主頁展示。技術方案採用 **Flutter 3.16+** 搭配 **Supabase Flutter SDK** 處理 OAuth2 認證流程，使用 **Riverpod 2.x** 進行狀態管理，**Go Router** 實現路由守衛，**Dio + Retrofit** 整合後端 RESTful API，**flutter_secure_storage** 加密儲存敏感資料，**Material 3** 設計系統確保 UI 一致性。

## Technical Context

**Language/Version**: Dart 3.2+ / Flutter 3.16+  
**Primary Dependencies**: 
- `supabase_flutter: ^2.3.0` (OAuth2 認證)
- `flutter_riverpod: ^2.4.0` (狀態管理)
- `go_router: ^13.0.0` (路由管理)
- `dio: ^5.4.0` (HTTP 客戶端)
- `retrofit: ^4.0.0` (API 封裝)
- `flutter_secure_storage: ^9.0.0` (安全儲存)
- `flutter_svg: ^2.0.0` (SVG 圖示)
- `freezed: ^2.4.5` (不可變資料類別)
- `json_serializable: ^6.7.0` (JSON 序列化)

**Storage**: 
- 本地: flutter_secure_storage (iOS Keychain / Android Keystore)
- 遠端: Supabase Auth (使用者認證資料由後端管理)

**Testing**: 
- flutter_test (單元測試、元件測試)
- integration_test (整合測試)
- mockito (模擬依賴)

**Target Platform**: 
- iOS 13.0+
- Android API 21+ (Android 5.0 Lollipop)
- Web (選用，未來擴充)

**Project Type**: Mobile (單一 Flutter 專案)

**Performance Goals**: 
- 應用程式啟動時間 < 3 秒 (冷啟動)
- 登入流程完成時間 < 10 秒 (含 OAuth 授權)
- 已登入使用者自動進入主頁 < 2 秒
- UI 互動回應 < 100ms (按鈕點擊回饋)
- 60 FPS 流暢動畫

**Constraints**: 
- OAuth 授權須透過外部瀏覽器或內嵌 WebView
- Token 有效期限 7 天 (後端限制)
- 深層連結必須正確設定以處理 OAuth 回呼
- 離線模式: 僅檢查本地 token 有效性，無法執行登入

**Scale/Scope**: 
- 目標使用者: 初期 1,000+ 使用者
- 功能範圍: 2 個主要頁面 (登入頁、主頁)
- API 端點: 7 個 RESTful endpoints
- 程式碼規模: 約 5,000 行 Dart 程式碼 (含測試)

## Constitution Check

*GATE: 必須在 Phase 0 研究前通過。Phase 1 設計後重新檢查。*

### I. 程式碼品質標準

- ✅ **型別安全**: 使用 Dart 嚴格模式，Freezed 確保不可變性
- ✅ **程式碼風格**: 使用 `flutter analyze` 和 `dart format` 零警告零錯誤
- ✅ **元件設計**: 遵循單一職責原則，Provider/Widget 分離
- ✅ **可讀性**: 函式長度 ≤ 50 行，複雜邏輯分解為小函式
- ✅ **文件**: 公開 API 使用 Dart Doc 註解

### II. 測試紀律 (不可妥協)

- ✅ **Test-First 工作流程**: 先寫測試 → 驗證失敗 → 實作 → 重構
- ✅ **測試覆蓋率**: 最低 80%，關鍵業務邏輯 100%
- ✅ **分層測試策略**:
  - 單元測試: 測試 Provider、Service、資料模型
  - 元件測試: 測試 Widget 渲染和互動
  - 整合測試: 測試完整登入/登出流程
- ✅ **測試品質**: 測試獨立執行、描述性命名、驗證行為而非實作

### III. 使用者體驗一致性

- ✅ **設計系統**: 使用 Material 3 和從 Figma 提取的設計 tokens
- ✅ **元件函式庫**: 優先使用可重用元件 (GoogleLogo, FacebookLogo 等)
- ✅ **響應式設計**: 支援多種螢幕尺寸 (375px+)
- ✅ **無障礙 (WCAG 2.1 AA)**:
  - 所有互動元素支援鍵盤導航 (對行動裝置不適用，僅 Web)
  - 色彩對比符合 4.5:1
  - 圖片和圖示有意義的語義標籤
  - 表單欄位有明確的標籤和錯誤訊息
- ✅ **載入狀態**: 所有非同步操作提供視覺回饋 (CircularProgressIndicator)
- ✅ **錯誤處理**: 錯誤訊息清楚、可操作、使用者友善 (繁體中文)

### IV. 效能需求

- ✅ **初始載入效能**:
  - 首次內容繪製 (FCP) ≤ 1.5 秒
  - 最大內容繪製 (LCP) ≤ 2.5 秒
  - 可互動時間 (TTI) ≤ 3.5 秒
- ✅ **互動效能**:
  - 首次輸入延遲 (FID) ≤ 100ms
  - 所有使用者操作提供 100ms 內的視覺回饋
- ✅ **Bundle 大小限制**:
  - APK 大小 ≤ 50MB
  - iOS App 大小 ≤ 50MB
- ✅ **資源優化**:
  - 圖示使用 SVG 格式
  - 關鍵資產預載入
  - HTTP 請求使用連線池和逾時設定
- ✅ **效能監控**: (未來) 實作 Firebase Performance Monitoring

### V. 文件語言標準

- ✅ **使用者面向文件**: 必須使用繁體中文 (zh-TW)
  - spec.md ✅
  - plan.md ✅
  - tasks.md ✅
  - quickstart.md ✅
  - UI 文字、錯誤訊息 ✅
- ✅ **開發者文件**: 可使用英文
  - 程式碼註解 (英文/中文皆可)
  - Git commit messages (英文/中文皆可)
  - API contracts (英文，與後端一致)

**憲法檢查結果**: ✅ **通過** - 所有原則符合，無需豁免

## Project Structure

### Documentation (this feature)

```text
specs/001-login-homepage/
├── plan.md              # 本檔案 (實作計畫)
├── spec.md              # 功能規格
├── research.md          # Phase 0 技術研究
├── data-model.md        # Phase 1 資料模型
├── quickstart.md        # Phase 1 快速入門指南
├── contracts/           # Phase 1 API 契約
│   └── api-integration.md
└── tasks.md             # Phase 2 任務清單 (由 /speckit.tasks 產生)
```

### Source Code (repository root)

本專案採用 **Feature-First** 結構，以功能模組為組織單位。

```text
lib/
├── main.dart                        # 應用程式進入點
├── config/
│   └── env.dart                     # 環境變數 (Supabase keys)
├── core/                            # 共享核心功能
│   ├── api/
│   │   ├── api_client.dart          # Retrofit API 客戶端
│   │   ├── dio_config.dart          # Dio 設定
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart    # Bearer token 攔截器
│   │       └── refresh_interceptor.dart # 401 刷新 token 攔截器
│   ├── auth/
│   │   └── supabase_auth_service.dart   # Supabase OAuth 服務
│   ├── routing/
│   │   └── app_router.dart          # Go Router 路由定義
│   ├── theme/
│   │   ├── app_theme.dart           # Material 3 主題
│   │   └── design_tokens.dart       # Figma 設計 tokens
│   └── widgets/
│       ├── google_logo.dart         # Google 圖示元件
│       ├── facebook_logo.dart       # Facebook 圖示元件
│       └── loading_indicator.dart   # 通用載入指示器
├── features/                        # 功能模組
│   ├── auth/                        # 認證功能
│   │   ├── models/
│   │   │   ├── user.dart            # 使用者模型 (Freezed)
│   │   │   ├── auth_state.dart      # 認證狀態 (Sealed Union)
│   │   │   ├── login_request.dart   # 登入請求 DTO
│   │   │   └── login_response.dart  # 登入回應 DTO
│   │   ├── providers/
│   │   │   ├── auth_notifier.dart   # AuthState Notifier
│   │   │   └── auth_service_provider.dart # Service Provider
│   │   ├── screens/
│   │   │   └── login_page.dart      # 登入頁面
│   │   └── widgets/
│   │       └── social_login_button.dart # 社交登入按鈕
│   └── home/                        # 主頁功能
│       ├── models/
│       │   ├── homepage_data.dart   # 主頁資料模型
│       │   └── construction_content.dart # 施工中內容
│       ├── providers/
│       │   └── homepage_provider.dart # 主頁資料 Provider
│       ├── screens/
│       │   └── home_page.dart       # 主頁頁面
│       └── widgets/
│           └── construction_view.dart # 施工中元件

test/
├── core/
│   └── api/
│       ├── api_client_test.dart
│       └── interceptors/
│           └── refresh_interceptor_test.dart
└── features/
    ├── auth/
    │   ├── models/
    │   │   ├── user_test.dart
    │   │   └── auth_state_test.dart
    │   └── providers/
    │       └── auth_notifier_test.dart
    └── home/
        └── providers/
            └── homepage_provider_test.dart

integration_test/
└── app_test.dart                    # E2E 測試 (P1-P4)

assets/
├── icons/                           # SVG 圖示
│   ├── google-icon-circle.svg
│   ├── google-icon-g-letter.svg
│   ├── facebook-icon.svg
│   ├── logout-icon-part-1.svg
│   └── construction-icon-part-1.svg
└── logo/
    └── app-logo.svg

android/
└── app/
    └── src/
        └── main/
            └── AndroidManifest.xml  # 深層連結設定

ios/
└── Runner/
    └── Info.plist                   # 深層連結設定
```

**Structure Decision**: 採用 Feature-First 架構以提升程式碼可維護性和可擴展性。每個功能模組 (`features/auth/`, `features/home/`) 包含完整的 MVC 層級 (models, providers, screens, widgets)，核心共享功能放在 `core/` 目錄。這種結構方便功能獨立開發和測試，符合單一職責原則。

## Complexity Tracking

> **僅在憲法檢查有違規需要說明時填寫**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| -         | -          | 無違規                                |

---

## Phase 0: Research

**Deliverables**: `research.md`  
**Workflow**: 針對 Technical Context 中每個 NEEDS CLARIFICATION 項目,派遣代理進行目標研究任務。合併研究發現。

**Summary**:

本階段完成 **6 個關鍵技術領域**的調研,所有技術決策已明確定義:

### 1. OAuth2 整合策略

- **評估方案**: 
  - `google_sign_in` + `flutter_facebook_auth` (手動整合)
  - Supabase Flutter SDK (統一 OAuth 管理)
  - 自行實作 Authorization Code Flow with PKCE

- **選擇**: **Supabase Flutter SDK 2.3.0**

- **理由**:
  - ✅ 自動處理 PKCE (Proof Key for Code Exchange) 提升安全性
  - ✅ 統一管理多個 OAuth Provider (Google, Facebook, 未來可擴充 Apple)
  - ✅ 整合 token 自動刷新機制 (refresh token rotation)
  - ✅ 與後端 Supabase Auth 完全整合,減少自訂 API 開發
  - ✅ 內建深層連結處理 (deep link callback)

- **替代方案捨棄原因**:
  - 手動整合需要維護多個套件版本和不同 OAuth 流程
  - 自行實作需要處理複雜的安全細節 (PKCE, state parameter, nonce)

### 2. 狀態管理

- **評估方案**: Provider, Riverpod, Bloc, GetX, MobX

- **選擇**: **Riverpod 2.4.0** (with `riverpod_annotation`)

- **理由**:
  - ✅ 編譯期型別安全 (compile-time safety)
  - ✅ 程式碼產生減少樣板程式碼 (boilerplate)
  - ✅ 支援 Sealed Union (AuthState: unauthenticated/loading/authenticated/error)
  - ✅ 易於測試 (ProviderContainer 隔離狀態)
  - ✅ 自動依賴追蹤和重建優化

- **替代方案捨棄原因**:
  - Provider: 較舊,型別安全性較弱
  - Bloc: 過度工程 (over-engineering) 對簡單認證流程
  - GetX: 全域單例模式不利於測試

### 3. 路由管理

- **評估方案**: Navigator 1.0, Navigator 2.0 (手動), Go Router, AutoRoute

- **選擇**: **Go Router 13.0.0**

- **理由**:
  - ✅ 宣告式路由定義 (Declarative routing)
  - ✅ 內建認證守衛 (redirect based on AuthState)
  - ✅ 深層連結支援 (OAuth callback handling)
  - ✅ 型別安全的路由參數
  - ✅ 社群廣泛採用,文件完善

- **替代方案捨棄原因**:
  - Navigator 1.0: 不支援深層連結,路由邏輯分散
  - Navigator 2.0: 需要大量樣板程式碼
  - AutoRoute: 需額外程式碼產生步驟,學習曲線陡峭

### 4. API 客戶端

- **評估方案**: `http` package, Dio, Chopper

- **選擇**: **Dio 5.4.0 + Retrofit 4.0.0**

- **理由**:
  - ✅ 型別安全的 API 定義 (Retrofit annotations)
  - ✅ 攔截器支援 (Interceptors) 自動處理 token 刷新
  - ✅ 程式碼產生減少手動 JSON 解析
  - ✅ 連線池 (connection pooling) 和逾時管理
  - ✅ 請求/回應日誌記錄方便除錯

- **替代方案捨棄原因**:
  - `http` package: 缺乏攔截器,需手動處理 token 刷新
  - Chopper: 社群支援較少,文件不完整

### 5. 安全儲存

- **評估方案**: `shared_preferences`, `flutter_secure_storage`, Hive

- **選擇**: **flutter_secure_storage 9.0.0**

- **理由**:
  - ✅ iOS: Keychain Services 加密
  - ✅ Android: EncryptedSharedPreferences (Android Keystore)
  - ✅ 統一 API 跨平台
  - ✅ 符合 OWASP 行動安全標準
  - ✅ 自動處理 iOS/Android 平台差異

- **替代方案捨棄原因**:
  - `shared_preferences`: 明文儲存,不安全
  - Hive: 需手動加密金鑰管理

### 6. UI 元件與設計系統

- **評估方案**: Material 2, Material 3, 完全自訂 UI, Flutter Cupertino

- **選擇**: **Material 3** + `flutter_svg` 2.0.0

- **理由**:
  - ✅ Material 3 提供現代化 UI 元件 (Dynamic Color, 新動畫)
  - ✅ 符合 Flutter 生態系統最佳實踐
  - ✅ `flutter_svg` 渲染 Figma 匯出的 SVG 圖示
  - ✅ 自訂 ThemeData 整合 Figma 設計 tokens
  - ✅ 內建無障礙支援 (Semantics widgets)

- **替代方案捨棄原因**:
  - Material 2: 較舊,Google 官方建議遷移至 Material 3
  - 完全自訂: 開發成本高,維護困難
  - Cupertino: 限 iOS 風格,不符專案需求

### 最佳實踐總結

- **安全性**: OAuth PKCE, 加密儲存, HTTPS 強制連線
- **測試性**: Riverpod ProviderContainer 隔離測試, Mock HTTP 客戶端
- **效能**: Dio 連線池, 圖示使用 SVG, 延遲載入非關鍵資源
- **可維護性**: Feature-First 架構, Freezed 不可變模型, 程式碼產生減少樣板

---

## Phase 1: Design & Contracts

**Deliverables**: `data-model.md`, `/contracts/*`, `quickstart.md`  
**Workflow**: 提取實體 → 產生 API 契約 → 輸出 OpenAPI/GraphQL schema → 建立快速入門指南。

**Summary**:

### 資料模型 (data-model.md)

定義 **7 個核心資料模型**,全部使用 Freezed 確保不可變性和 JSON 序列化:

#### 1. User (使用者模型)

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,              // UUID v4
    required String email,           // Email 格式
    String? name,                    // 顯示名稱
    String? avatarUrl,               // 大頭貼 URL
    required String provider,        // 'google' | 'facebook'
    required DateTime createdAt,
    required DateTime lastSignInAt,
  }) = _User;
}
```

- **驗證規則**: UUID 格式、email 格式、provider 列舉
- **關係**: 一對一 Session

#### 2. AuthState (認證狀態 Sealed Union)

```dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.loading() = Loading;
  const factory AuthState.authenticated({
    required User user,
    required Session session,
  }) = Authenticated;
  const factory AuthState.error(String message) = AuthError;
}
```

- **用途**: Riverpod StateNotifier 的狀態模型
- **狀態轉換**: unauthenticated → loading → authenticated/error

#### 3. LoginRequest (登入請求 DTO)

```dart
// Google 登入請求
@freezed
class GoogleLoginRequest with _$GoogleLoginRequest {
  const factory GoogleLoginRequest({
    required String code,            // OAuth authorization code
    required String codeVerifier,    // PKCE code verifier
    Map<String, dynamic>? deviceInfo,
  }) = _GoogleLoginRequest;
}

// Facebook 登入請求 (結構相同)
@freezed
class FacebookLoginRequest with _$FacebookLoginRequest {
  // ... 結構同 GoogleLoginRequest
}
```

#### 4. LoginResponse (登入回應 DTO)

```dart
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String accessToken,     // JWT access token (1 小時)
    required String refreshToken,    // Refresh token (30 天)
    required String tokenType,       // 'Bearer'
    required int expiresIn,          // 秒數 (3600)
    required User user,              // 使用者資料
  }) = _LoginResponse;
}
```

#### 5. Session (使用者工作階段)

```dart
@freezed
class Session with _$Session {
  const factory Session({
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _Session;
  
  // 計算屬性
  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get needsRefresh => expiresAt.difference(DateTime.now()).inMinutes < 5;
}
```

- **自動刷新邏輯**: 剩餘 5 分鐘自動觸發 token 刷新

#### 6. HomepageData (主頁資料)

```dart
@freezed
class HomepageData with _$HomepageData {
  const factory HomepageData({
    required User user,
    required ConstructionContent constructionContent,
  }) = _HomepageData;
}

@freezed
class ConstructionContent with _$ConstructionContent {
  const factory ConstructionContent({
    required String title,           // "施工中"
    required String message,         // "敬請期待"
    String? iconPath,                // 'assets/icons/construction-icon-part-1.svg'
  }) = _ConstructionContent;
}
```

#### 7. ApiError (API 錯誤模型)

```dart
@freezed
class ApiError with _$ApiError {
  const factory ApiError({
    required String error,           // 錯誤代碼 (e.g., 'INVALID_OAUTH_TOKEN')
    required String message,         // 使用者友善訊息 (繁體中文)
    Map<String, dynamic>? details,   // 額外錯誤細節
    DateTime? timestamp,
  }) = _ApiError;
}
```

- **用途**: 統一錯誤處理,映射 HTTP 狀態碼到使用者訊息

### API 契約 (contracts/api-integration.md)

記錄 **7 個 RESTful API 端點**與 Flutter 整合模式:

| 端點 | 方法 | 功能 | 請求 | 回應 | 狀態碼 |
|------|------|------|------|------|--------|
| `/auth/login/google` | POST | Google 登入 | GoogleLoginRequest | LoginResponse | 200, 400, 401, 500 |
| `/auth/login/facebook` | POST | Facebook 登入 | FacebookLoginRequest | LoginResponse | 200, 400, 401, 500 |
| `/auth/logout` | POST | 登出 (撤銷 token) | - | - | 204, 401, 500 |
| `/auth/verify` | GET | 驗證 token 有效性 | - | UserProfile | 200, 401, 500 |
| `/auth/refresh` | POST | 刷新 access token | RefreshTokenRequest | LoginResponse | 200, 401, 403, 500 |
| `/homepage` | GET | 取得主頁資料 | - | HomepageResponse | 200, 401, 500 |
| `/user/delete` | DELETE | 刪除使用者帳號 | - | - | 204, 401, 500 |

#### Retrofit API 客戶端介面

```dart
@RestApi(baseUrl: 'https://api-dev.money-manager.example.com/api/v1')
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;
  
  @POST('/auth/login/google')
  Future<LoginResponse> loginWithGoogle(@Body() GoogleLoginRequest request);
  
  @POST('/auth/login/facebook')
  Future<LoginResponse> loginWithFacebook(@Body() FacebookLoginRequest request);
  
  @POST('/auth/logout')
  Future<void> logout();
  
  @GET('/auth/verify')
  Future<User> verifyToken();
  
  @POST('/auth/refresh')
  Future<LoginResponse> refreshToken(@Body() RefreshTokenRequest request);
  
  @GET('/homepage')
  Future<HomepageData> getHomepageData();
  
  @DELETE('/user/delete')
  Future<void> deleteAccount();
}
```

#### 關鍵整合模式

1. **Dio Interceptor 自動處理 401**:
   - 偵測 401 回應 → 自動呼叫 `/auth/refresh`
   - 刷新成功 → 重試原始請求
   - 刷新失敗 → 導向登入頁

2. **錯誤映射策略**:
   - `INVALID_OAUTH_TOKEN` → "無效的登入憑證,請重新登入"
   - `EXPIRED_TOKEN` → "工作階段已過期,請重新登入"
   - `NETWORK_ERROR` → "網路連線失敗,請檢查網路設定"

3. **Mock 測試**:
   - 使用 `mockito` 模擬 ApiClient
   - 使用 `http_mock_adapter` 模擬 HTTP 回應

### 快速入門指南 (quickstart.md)

提供完整的 **開發者上手路徑** (10 大章節):

#### 1. 前置需求

- Flutter 3.16+
- Dart 3.2+
- Android Studio / Xcode
- Git

#### 2. 環境設定

建立 `.env` 檔案:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
API_BASE_URL=https://api-dev.money-manager.example.com/api/v1
```

#### 3. OAuth 憑證配置

**Google Cloud Console**:
1. 建立 OAuth 客戶端 ID (Android, iOS, Web)
2. 設定授權重新導向 URI: `com.example.moneymanager://login-callback`
3. 複製 Client ID 和 Client Secret 到 Supabase Dashboard

**Facebook Developers**:
1. 建立應用程式
2. 啟用 Facebook Login
3. 設定有效 OAuth 重新導向 URI
4. 複製 App ID 和 App Secret 到 Supabase Dashboard

**Supabase Dashboard**:
1. 進入 Authentication → Providers
2. 啟用 Google 和 Facebook
3. 貼上 OAuth 憑證

#### 4. 深層連結設定

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="com.example.moneymanager" android:host="login-callback" />
</intent-filter>
```

**iOS** (`ios/Runner/Info.plist`):

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.example.moneymanager</string>
    </array>
  </dict>
</array>
```

#### 5. 執行指令

```bash
# 安裝相依套件
flutter pub get

# 執行程式碼產生
flutter pub run build_runner build --delete-conflicting-outputs

# 執行應用程式
flutter run -d <device>
```

#### 6. 測試程序 (P1-P4 驗證清單)

**P1: 社交帳號登入** (10 測試案例):
- ✅ 登入頁顯示 Google 和 Facebook 按鈕
- ✅ 點擊 Google 按鈕開啟 OAuth 流程
- ✅ 授權成功後導向主頁
- ✅ 使用者資料正確顯示
- ✅ Token 儲存於 Secure Storage
- ... (共 10 項)

**P2: 自動登入** (5 測試案例):
- ✅ 重新開啟 App 自動進入主頁
- ✅ Token 有效期間內不需重新登入
- ✅ Token 過期自動刷新
- ... (共 5 項)

**P3: 登出功能** (4 測試案例):
- ✅ 主頁顯示登出按鈕
- ✅ 點擊登出清除本地 Token
- ✅ 導向登入頁
- ... (共 4 項)

**P4: 施工中主頁** (3 測試案例):
- ✅ 顯示施工圖示和文字
- ✅ 顯示使用者名稱和大頭貼
- ... (共 3 項)

#### 7. 疑難排解

- **OAuth 錯誤**: 檢查 Client ID, Redirect URI 設定
- **深層連結無效**: 檢查 AndroidManifest.xml / Info.plist 設定
- **Supabase 連線失敗**: 檢查 .env 檔案 URL 和 API Key

#### 8-10. 效能檢查、實用指令、參考文件

---

## Phase 2: Task Generation (Not Yet Executed)

**Deliverables**: `tasks.md`  
**Workflow**: 將實作分解為原子任務,確保每個任務遵循 Test-First 紀律。

**Note**: 此階段將在計畫核准後由 `/speckit.task` 指令執行。

**預期任務結構** (示意):

1. **環境設定任務** (3-5 個任務)
   - 建立 Flutter 專案結構
   - 設定 Supabase SDK
   - 配置 Dio + Retrofit

2. **認證模組任務** (10-15 個任務)
   - 實作 User 模型 (TDD)
   - 實作 AuthState 模型 (TDD)
   - 實作 SupabaseAuthService (TDD)
   - 實作 AuthNotifier Provider (TDD)
   - 實作登入頁 UI
   - ... 

3. **主頁模組任務** (5-8 個任務)
   - 實作 HomepageData 模型 (TDD)
   - 實作 HomepageProvider (TDD)
   - 實作主頁 UI
   - ...

4. **整合測試任務** (3-5 個任務)
   - E2E 測試: P1 登入流程
   - E2E 測試: P2 自動登入
   - E2E 測試: P3 登出流程
   - E2E 測試: P4 主頁顯示

**預計總任務數**: 25-35 個原子任務

---

**實作計畫完成** ✅

- Branch: `001-login-homepage`
- Phase 0: 研究完成 (research.md)
- Phase 1: 設計完成 (data-model.md, api-integration.md, quickstart.md)
- Phase 2: 待執行 (`/speckit.task` 指令)

**下一步**: 執行 `/speckit.task` 產生詳細任務清單 (tasks.md)
