# Tasks: 登入與主頁功能

**Branch**: `001-login-homepage`  
**Input**: 設計文件來自 `/specs/001-login-homepage/`  
**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/, quickstart.md

## 格式說明: `- [ ] [ID] [P?] [Story?] 描述`

- **[P]**: 可並行執行 (不同檔案,無相依性)
- **[Story]**: 任務所屬的使用者故事 (US1, US2, US3, US4)
- 描述包含精確的檔案路徑

## 路徑慣例

本專案為 **Mobile (Flutter)** 專案:
- `lib/` - 原始碼目錄
- `test/` - 單元測試和元件測試
- `integration_test/` - 整合測試 (E2E)
- `assets/` - 資源檔案

---

## Phase 1: Setup (共享基礎設施)

**目的**: 專案初始化和基礎結構

- [ ] T001 建立 Flutter 專案結構 (lib/core/, lib/features/, test/, integration_test/)
- [ ] T002 初始化 pubspec.yaml 並加入核心相依套件 (riverpod, dio, retrofit, go_router, supabase_flutter, flutter_secure_storage, freezed, json_serializable, flutter_svg)
- [ ] T003 [P] 建立環境變數設定檔 lib/config/env.dart (SUPABASE_URL, SUPABASE_ANON_KEY, API_BASE_URL)
- [ ] T004 [P] 設定程式碼產生工具 build.yaml (freezed, retrofit, riverpod_annotation)
- [ ] T005 [P] 配置 analysis_options.yaml (啟用嚴格模式, lint rules)
- [ ] T006 [P] 建立 .env.example 範本檔案
- [ ] T007 複製 SVG 圖示資產到 assets/icons/ 目錄 (17 個 SVG 檔案從 design-assets/)
- [ ] T008 設定 Android deep link 在 android/app/src/main/AndroidManifest.xml (scheme: com.example.moneymanager)
- [ ] T009 設定 iOS deep link 在 ios/Runner/Info.plist (CFBundleURLSchemes)

---

## Phase 2: Foundational (必要前置條件)

**目的**: 核心基礎設施,**必須**在任何使用者故事開始前完成

**⚠️ 關鍵**: 在此階段完成前,無法開始任何使用者故事工作

- [ ] T010 建立 Material 3 主題設定 lib/core/theme/app_theme.dart (13 種顏色, 4 種文字樣式)
- [ ] T011 [P] 建立設計 tokens lib/core/theme/design_tokens.dart (顏色常數, 間距標準, 圓角標準)
- [ ] T012 [P] 實作 Supabase 初始化服務 lib/core/auth/supabase_service.dart (初始化 Supabase client)
- [ ] T013 實作 Dio 設定 lib/core/api/dio_config.dart (base URL, timeout, 連線池)
- [ ] T014 實作 API 客戶端介面 lib/core/api/api_client.dart (Retrofit 抽象類別,定義 7 個端點)
- [ ] T015 [P] 實作 AuthInterceptor lib/core/api/interceptors/auth_interceptor.dart (自動附加 Bearer token)
- [ ] T016 [P] 實作 RefreshTokenInterceptor lib/core/api/interceptors/refresh_interceptor.dart (401 自動刷新 token)
- [ ] T017 [P] 實作 ErrorInterceptor lib/core/api/interceptors/error_interceptor.dart (統一錯誤處理)
- [ ] T018 實作 SecureStorageService lib/core/storage/secure_storage_service.dart (封裝 flutter_secure_storage, 提供 saveTokens/getTokens/clearAuth)
- [ ] T019 執行程式碼產生 `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] T020 建立 Go Router 路由設定 lib/core/routing/app_router.dart (路由定義: /, /home; 認證守衛)

**Checkpoint**: 基礎設施就緒 - 使用者故事實作現在可以並行開始

---

## Phase 3: User Story 1 - 社交媒體登入 (Priority: P1) 🎯 MVP

**目標**: 使用者可透過 Google 或 Facebook 帳號完成登入流程

**獨立測試**: 開啟應用程式 → 點擊 Google/Facebook 登入按鈕 → 完成 OAuth 授權 → 驗證進入主頁

### User Story 1 實作

- [ ] T021 [P] [US1] 建立 User 資料模型 lib/features/auth/models/user.dart (Freezed, 7 個欄位: id, email, name, avatarUrl, provider, createdAt, lastSignInAt)
- [ ] T022 [P] [US1] 建立 AuthState 密封類別 lib/features/auth/models/auth_state.dart (4 個狀態: unauthenticated, loading, authenticated, error)
- [ ] T023 [P] [US1] 建立 GoogleLoginRequest DTO lib/features/auth/models/google_login_request.dart (Freezed: code, codeVerifier, deviceInfo)
- [ ] T024 [P] [US1] 建立 FacebookLoginRequest DTO lib/features/auth/models/facebook_login_request.dart (Freezed: code, codeVerifier, deviceInfo)
- [ ] T025 [P] [US1] 建立 LoginResponse DTO lib/features/auth/models/login_response.dart (Freezed: accessToken, refreshToken, tokenType, expiresIn, user)
- [ ] T026 [P] [US1] 建立 Session 模型 lib/features/auth/models/session.dart (Freezed: accessToken, refreshToken, expiresAt; computed: isExpired, needsRefresh)
- [ ] T027 [P] [US1] 建立 ApiError 模型 lib/core/api/models/api_error.dart (Freezed: error, message, details, timestamp)
- [ ] T028 執行程式碼產生以產生所有模型的 .freezed.dart 和 .g.dart 檔案
- [ ] T029 [US1] 實作 SupabaseAuthService lib/core/auth/supabase_auth_service.dart (signInWithGoogle, signInWithFacebook 方法,處理 PKCE)
- [ ] T030 [US1] 實作 AuthNotifier Provider lib/features/auth/providers/auth_notifier.dart (StateNotifier<AuthState>, 方法: signInWithGoogle, signInWithFacebook, signOut, checkAuthStatus)
- [ ] T031 [P] [US1] 建立 GoogleLogo 元件 lib/core/widgets/google_logo.dart (組合 4 個顏色的 SVG 部分)
- [ ] T032 [P] [US1] 建立 FacebookLogo 元件 lib/core/widgets/facebook_logo.dart (載入 facebook-icon.svg)
- [ ] T033 [P] [US1] 建立 AppLogo 元件 lib/core/widgets/app_logo.dart (載入 app-logo.svg)
- [ ] T034 [P] [US1] 建立 SocialLoginButton 元件 lib/features/auth/widgets/social_login_button.dart (可重用按鈕: 圖示 + 文字, 313x56px, 8px 圓角)
- [ ] T035 [US1] 實作 LoginPage lib/features/auth/screens/login_page.dart (顯示 AppLogo, 標題, Google 按鈕, Facebook 按鈕; 處理點擊事件)
- [ ] T036 [US1] 整合 AuthNotifier 與 LoginPage (使用 ConsumerWidget, 監聽 AuthState, 處理 loading/error 狀態)
- [ ] T037 [US1] 實作錯誤訊息顯示邏輯 (SnackBar 或 AlertDialog 顯示友善的繁體中文錯誤訊息)
- [ ] T038 [US1] 在 app_router.dart 加入登入成功後自動導向主頁的邏輯

**Checkpoint**: 此時 User Story 1 應該完全可運作並可獨立測試

---

## Phase 4: User Story 2 - 已登入使用者自動進入主頁 (Priority: P2)

**目標**: 已登入使用者重新開啟 App 時自動進入主頁,無需重新登入

**獨立測試**: 完成登入 → 關閉 App → 重新開啟 App → 驗證自動進入主頁 (不顯示登入頁)

### User Story 2 實作

- [ ] T039 [US2] 在 AuthNotifier 加入 checkAuthStatus 方法 (檢查 SecureStorage 中的 token 有效性)
- [ ] T040 [US2] 實作 API 客戶端的 verifyToken 方法 (呼叫 GET /auth/verify)
- [ ] T041 [US2] 在 main.dart 加入應用程式啟動時的認證檢查邏輯 (呼叫 authNotifier.checkAuthStatus())
- [ ] T042 [US2] 在 app_router.dart 加入認證守衛 redirect 邏輯 (根據 AuthState 決定顯示登入頁或主頁)
- [ ] T043 [US2] 處理 token 過期情況 (超過 7 天自動清除並導向登入頁)
- [ ] T044 [US2] 加入載入指示器 lib/core/widgets/loading_indicator.dart (應用程式啟動時顯示 CircularProgressIndicator)

**Checkpoint**: 此時 User Stories 1 和 2 應該都能獨立運作

---

## Phase 5: User Story 3 - 登出功能 (Priority: P3)

**目標**: 使用者可從主頁登出,清除登入狀態並返回登入頁

**獨立測試**: 完成登入 → 進入主頁 → 點擊登出按鈕 → 驗證返回登入頁且登入狀態已清除

### User Story 3 實作

- [ ] T045 [P] [US3] 建立 LogoutIcon 元件 lib/core/widgets/logout_icon.dart (組合 logout-icon-part-*.svg, 36x36px 圓形按鈕)
- [ ] T046 [US3] 在 AuthNotifier 加入 signOut 方法 (呼叫 POST /auth/logout, 清除 SecureStorage, 更新 AuthState 為 unauthenticated)
- [ ] T047 [US3] 實作 API 客戶端的 logout 方法 (呼叫 POST /auth/logout)
- [ ] T048 [US3] 在主頁右上角加入登出按鈕 (使用 LogoutIcon 元件)
- [ ] T049 [US3] 實作登出按鈕點擊事件處理 (呼叫 authNotifier.signOut(), 導向登入頁)
- [ ] T050 [US3] 加入登出確認對話框 (可選,提升 UX: "確定要登出嗎?")

**Checkpoint**: 此時 User Stories 1, 2 和 3 應該都能獨立運作

---

## Phase 6: User Story 4 - 顯示施工中主頁 (Priority: P4)

**目標**: 登入成功後顯示施工中主頁,告知使用者功能開發中

**獨立測試**: 完成登入 → 驗證主頁顯示施工圖示、標題、訊息和使用者資訊

### User Story 4 實作

- [ ] T051 [P] [US4] 建立 HomepageData 資料模型 lib/features/home/models/homepage_data.dart (Freezed: user, constructionContent)
- [ ] T052 [P] [US4] 建立 ConstructionContent 資料模型 lib/features/home/models/construction_content.dart (Freezed: title, message, iconPath)
- [ ] T053 [P] [US4] 建立 ConstructionIcon 元件 lib/core/widgets/construction_icon.dart (組合 construction-icon-part-*.svg, 8 個部分)
- [ ] T054 [US4] 執行程式碼產生以產生 homepage 模型的 .freezed.dart 和 .g.dart 檔案
- [ ] T055 [US4] 實作 API 客戶端的 getHomepage 方法 (呼叫 GET /homepage)
- [ ] T056 [US4] 建立 HomepageProvider lib/features/home/providers/homepage_provider.dart (FutureProvider<HomepageData>)
- [ ] T057 [P] [US4] 建立 ConstructionView 元件 lib/features/home/widgets/construction_view.dart (顯示施工圖示 + 標題 + 訊息)
- [ ] T058 [US4] 實作 HomePage lib/features/home/screens/home_page.dart (綠色標題列 #86EFCC, ConstructionView 元件, 右上角登出按鈕)
- [ ] T059 [US4] 在 HomePage 整合 HomepageProvider (使用 ConsumerWidget, 處理 loading/error 狀態)
- [ ] T060 [US4] 在 app_router.dart 註冊 /home 路由並設定為認證後的預設路由

**Checkpoint**: 所有使用者故事現在應該都能獨立運作

---

## Phase 7: Polish & Cross-Cutting Concerns

**目的**: 影響多個使用者故事的改進

- [ ] T061 [P] 加入單元測試: User 模型驗證 test/features/auth/models/user_test.dart (測試 UUID 格式, email 格式驗證)
- [ ] T062 [P] 加入單元測試: AuthState 狀態轉換 test/features/auth/models/auth_state_test.dart (測試所有狀態變化)
- [ ] T063 [P] 加入單元測試: Session isExpired/needsRefresh 邏輯 test/features/auth/models/session_test.dart
- [ ] T064 [P] 加入單元測試: AuthNotifier 業務邏輯 test/features/auth/providers/auth_notifier_test.dart (使用 mockito mock API client)
- [ ] T065 [P] 加入單元測試: RefreshTokenInterceptor test/core/api/interceptors/refresh_interceptor_test.dart (測試 401 自動刷新流程)
- [ ] T066 [P] 加入元件測試: LoginPage 渲染 test/features/auth/screens/login_page_test.dart (驗證按鈕顯示, 點擊事件)
- [ ] T067 [P] 加入元件測試: HomePage 渲染 test/features/home/screens/home_page_test.dart (驗證施工中內容顯示)
- [ ] T068 加入整合測試: P1 完整登入流程 integration_test/login_flow_test.dart (Google/Facebook 登入 → 進入主頁)
- [ ] T069 加入整合測試: P2 自動登入流程 integration_test/auto_login_test.dart (重新開啟 App → 自動進入主頁)
- [ ] T070 加入整合測試: P3 登出流程 integration_test/logout_flow_test.dart (登出 → 返回登入頁 → token 已清除)
- [ ] T071 加入整合測試: P4 主頁顯示 integration_test/homepage_test.dart (驗證施工中內容正確顯示)
- [ ] T072 [P] 執行 `flutter analyze` 確保零警告零錯誤
- [ ] T073 [P] 執行 `dart format lib/ test/ integration_test/` 格式化所有程式碼
- [ ] T074 [P] 更新 quickstart.md 加入實際執行步驟驗證
- [ ] T075 [P] 加入 Dart Doc 註解到所有公開 API (模型, Provider, Service)
- [ ] T076 效能優化: 測試冷啟動時間 < 3 秒, 登入流程 < 10 秒, 自動登入 < 2 秒
- [ ] T077 無障礙檢查: 驗證色彩對比 4.5:1, 圖示有語義標籤 (Semantics widget)
- [ ] T078 安全性檢查: 驗證 token 加密儲存, HTTPS 連線, 敏感資料不記錄到 log
- [ ] T079 執行完整 quickstart.md 驗證流程 (環境設定 → OAuth 配置 → 執行 → 測試)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: 無相依 - 可立即開始
- **Foundational (Phase 2)**: 依賴 Setup 完成 - **阻擋所有使用者故事**
- **User Stories (Phase 3-6)**: 全部依賴 Foundational phase 完成
  - 使用者故事之後可並行執行 (如果人力充足)
  - 或依優先順序循序執行 (P1 → P2 → P3 → P4)
- **Polish (Phase 7)**: 依賴所有期望的使用者故事完成

### User Story Dependencies

- **User Story 1 (P1)**: 可在 Foundational (Phase 2) 後開始 - 無其他故事相依
- **User Story 2 (P2)**: 可在 Foundational (Phase 2) 後開始 - 需整合 US1 但應可獨立測試
- **User Story 3 (P3)**: 可在 Foundational (Phase 2) 後開始 - 需整合 US1/US4 但應可獨立測試
- **User Story 4 (P4)**: 可在 Foundational (Phase 2) 後開始 - 需整合 US1 但應可獨立測試

### Within Each User Story

- 模型在服務之前
- 服務在端點之前
- 核心實作在整合之前
- 故事完成後再移至下一優先順序

### Parallel Opportunities

- 所有標記 [P] 的 Setup 任務可並行執行
- 所有標記 [P] 的 Foundational 任務可並行執行 (在 Phase 2 內)
- Foundational phase 完成後,所有使用者故事可並行開始 (如果團隊人力允許)
- 每個故事內標記 [P] 的模型可並行執行
- 每個故事內標記 [P] 的元件可並行執行
- 不同使用者故事可由不同團隊成員並行工作

---

## Parallel Example: User Story 1

```bash
# 同時啟動 User Story 1 的所有模型:
Task T021: "建立 User 資料模型 lib/features/auth/models/user.dart"
Task T022: "建立 AuthState 密封類別 lib/features/auth/models/auth_state.dart"
Task T023: "建立 GoogleLoginRequest DTO lib/features/auth/models/google_login_request.dart"
Task T024: "建立 FacebookLoginRequest DTO lib/features/auth/models/facebook_login_request.dart"
Task T025: "建立 LoginResponse DTO lib/features/auth/models/login_response.dart"
Task T026: "建立 Session 模型 lib/features/auth/models/session.dart"
Task T027: "建立 ApiError 模型 lib/core/api/models/api_error.dart"

# 同時啟動 User Story 1 的所有 UI 元件:
Task T031: "建立 GoogleLogo 元件 lib/core/widgets/google_logo.dart"
Task T032: "建立 FacebookLogo 元件 lib/core/widgets/facebook_logo.dart"
Task T033: "建立 AppLogo 元件 lib/core/widgets/app_logo.dart"
Task T034: "建立 SocialLoginButton 元件 lib/features/auth/widgets/social_login_button.dart"
```

---

## Implementation Strategy

### MVP First (僅 User Story 1)

1. 完成 Phase 1: Setup
2. 完成 Phase 2: Foundational (**關鍵** - 阻擋所有故事)
3. 完成 Phase 3: User Story 1
4. **停止並驗證**: 獨立測試 User Story 1
5. 如果就緒可部署/展示

### Incremental Delivery

1. 完成 Setup + Foundational → 基礎就緒
2. 加入 User Story 1 → 獨立測試 → 部署/展示 (MVP!)
3. 加入 User Story 2 → 獨立測試 → 部署/展示
4. 加入 User Story 3 → 獨立測試 → 部署/展示
5. 加入 User Story 4 → 獨立測試 → 部署/展示
6. 每個故事都增加價值而不破壞先前的故事

### Parallel Team Strategy

多位開發者時:

1. 團隊一起完成 Setup + Foundational
2. Foundational 完成後:
   - 開發者 A: User Story 1
   - 開發者 B: User Story 2
   - 開發者 C: User Story 3
   - 開發者 D: User Story 4
3. 故事獨立完成並整合

---

## Notes

- [P] 任務 = 不同檔案,無相依性
- [Story] 標籤將任務映射到特定使用者故事以便追蹤
- 每個使用者故事應該可以獨立完成和測試
- 在每個 checkpoint 停止以獨立驗證故事
- 避免: 模糊任務、同檔案衝突、破壞獨立性的跨故事相依

---

## Task Summary

- **總任務數**: 79 個原子任務
- **Setup**: 9 個任務
- **Foundational**: 11 個任務 (阻擋所有故事)
- **User Story 1 (P1)**: 18 個任務 🎯 MVP
- **User Story 2 (P2)**: 6 個任務
- **User Story 3 (P3)**: 6 個任務
- **User Story 4 (P4)**: 10 個任務
- **Polish & Testing**: 19 個任務

**預估時間** (1 位全職開發者):
- Setup + Foundational: 3-4 天
- User Story 1 (MVP): 4-5 天
- User Story 2-4: 各 2-3 天
- Polish & Testing: 3-4 天
- **總計**: 約 20-25 個工作天

**並行執行** (4 位開發者):
- Setup + Foundational: 3-4 天 (團隊協作)
- User Stories (並行): 4-5 天
- Polish & Testing: 3-4 天
- **總計**: 約 10-13 個工作天
