# 快速開始指南: 登入與主頁功能

**建立日期**: 2025-01-19  
**功能分支**: `001-login-homepage`  
**目的**: 提供開發環境設定、專案執行和測試的完整步驟

---

## 前置需求

### 必要軟體

| 軟體 | 最低版本 | 檢查指令 | 安裝說明 |
|------|---------|----------|---------|
| Flutter SDK | 3.16+ | `flutter --version` | [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart SDK | 3.2+ | `dart --version` | Flutter SDK 已包含 |
| Git | 2.x | `git --version` | [git-scm.com](https://git-scm.com/) |
| Android Studio | 2023.x | - | [developer.android.com](https://developer.android.com/studio) (Android 開發) |
| Xcode | 15.x | `xcodebuild -version` | App Store (iOS 開發，僅 macOS) |

### 驗證 Flutter 環境

```bash
# 檢查 Flutter 環境
flutter doctor

# 預期輸出應包含:
# ✓ Flutter (Channel stable, 3.16.x)
# ✓ Android toolchain
# ✓ Xcode (僅 macOS)
# ✓ VS Code / Android Studio
```

---

## 1. 取得程式碼

### 複製儲存庫

```bash
# 複製 Git repository
git clone https://github.com/chunchun1213/money-manager-frontend.git

# 進入專案目錄
cd money-manager-frontend

# 切換到功能分支
git checkout 001-login-homepage
```

---

## 2. 環境設定

### 安裝相依套件

```bash
# 安裝 Flutter 相依套件
flutter pub get

# 產生程式碼 (Freezed, JSON Serializable, Riverpod Generator)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 設定環境變數

建立 `.env` 檔案 (複製範本):

```bash
# 複製環境變數範本
cp .env.example .env
```

編輯 `.env` 檔案，填入必要的設定：

```bash
# .env

# Supabase 設定
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here

# API 環境
API_ENV=development  # development 或 production

# 開發環境 API
API_BASE_URL_DEV=https://api-dev.money-manager.example.com/api/v1

# 正式環境 API
API_BASE_URL_PROD=https://api.money-manager.example.com/api/v1

# OAuth 設定
GOOGLE_CLIENT_ID_IOS=your_google_client_id_ios
GOOGLE_CLIENT_ID_ANDROID=your_google_client_id_android
FACEBOOK_APP_ID=your_facebook_app_id
```

### 取得 OAuth 憑證

#### Google OAuth 設定

1. 前往 [Google Cloud Console](https://console.cloud.google.com/)
2. 建立新專案或選擇現有專案
3. 啟用 "Google+ API"
4. 建立 OAuth 2.0 客戶端 ID:
   - **iOS**: Bundle ID = `com.example.moneymanager`
   - **Android**: Package name = `com.example.moneymanager`
   - **Deep Link**: `com.example.moneymanager://login-callback`

#### Facebook OAuth 設定

1. 前往 [Facebook Developers](https://developers.facebook.com/)
2. 建立新應用程式
3. 新增 "Facebook Login" 產品
4. 設定 OAuth 重新導向 URI:
   - `com.example.moneymanager://login-callback`

### 設定 Supabase

1. 前往 [Supabase Dashboard](https://app.supabase.com/)
2. 建立新專案或選擇現有專案
3. 在 Authentication → Providers 啟用:
   - ✅ Google
   - ✅ Facebook
4. 填入 OAuth Client ID 和 Secret
5. 複製 `SUPABASE_URL` 和 `SUPABASE_ANON_KEY`

---

## 3. 設定深層連結

### Android 設定

編輯 `android/app/src/main/AndroidManifest.xml`:

```xml
<activity
    android:name=".MainActivity"
    android:exported="true">
    
    <!-- 現有的 intent-filter -->
    <intent-filter>
        <action android:name="android.intent.action.MAIN"/>
        <category android:name="android.intent.category.LAUNCHER"/>
    </intent-filter>
    
    <!-- 新增: OAuth 回呼 intent-filter -->
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data
            android:scheme="com.example.moneymanager"
            android:host="login-callback" />
    </intent-filter>
</activity>
```

### iOS 設定

編輯 `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.example.moneymanager</string>
        </array>
    </dict>
</array>

<!-- Google Sign-In -->
<key>GIDClientID</key>
<string>YOUR_GOOGLE_CLIENT_ID</string>

<!-- Facebook Login -->
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>fbYOUR_FACEBOOK_APP_ID</string>
        </array>
    </dict>
</array>
<key>FacebookAppID</key>
<string>YOUR_FACEBOOK_APP_ID</string>
<key>FacebookDisplayName</key>
<string>MoneyManager</string>
```

---

## 4. 執行應用程式

### 開發模式執行

```bash
# 檢查可用裝置
flutter devices

# 在特定裝置執行 (開發模式)
flutter run -d <device_id>

# 在 iOS 模擬器執行
flutter run -d iPhone

# 在 Android 模擬器執行
flutter run -d emulator-5554

# 啟用 Hot Reload (自動重新載入)
# 執行後在終端機按 'r' 重新載入，按 'R' 完全重新啟動
```

### 正式版本建構

```bash
# Android APK
flutter build apk --release

# Android App Bundle (推薦上架 Google Play)
flutter build appbundle --release

# iOS (僅 macOS)
flutter build ios --release
```

---

## 5. 測試

### 執行所有測試

```bash
# 執行單元測試和元件測試
flutter test

# 執行測試並顯示覆蓋率
flutter test --coverage

# 查看覆蓋率報告 (需安裝 lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### 執行特定測試

```bash
# 執行特定測試檔案
flutter test test/features/auth/providers/auth_provider_test.dart

# 執行特定測試群組
flutter test --name "AuthNotifier"
```

### 執行整合測試

```bash
# 在連接的裝置上執行整合測試
flutter test integration_test/app_test.dart

# 在特定裝置執行
flutter test integration_test/app_test.dart -d <device_id>
```

---

## 6. 功能驗證清單

### P1: 社交媒體登入

- [ ] **登入頁顯示正確**
  - [ ] 顯示「歡迎使用家庭記帳」標題
  - [ ] 顯示應用程式 logo
  - [ ] 顯示 Google 登入按鈕 (含 Google logo)
  - [ ] 顯示 Facebook 登入按鈕 (含 Facebook logo)

- [ ] **Google 登入流程**
  - [ ] 點擊「Google 登入」按鈕開啟 OAuth 頁面
  - [ ] 選擇 Google 帳號後成功授權
  - [ ] 授權成功後返回應用程式
  - [ ] 自動導向主頁 (施工中頁面)
  - [ ] 使用者名稱和頭像正確顯示

- [ ] **Facebook 登入流程**
  - [ ] 點擊「Facebook 登入」按鈕開啟 OAuth 頁面
  - [ ] 授權成功後返回應用程式
  - [ ] 自動導向主頁

### P2: 自動登入

- [ ] **已登入使用者自動進入主頁**
  - [ ] 關閉應用程式後重新開啟
  - [ ] 自動進入主頁 (無需重新登入)
  - [ ] Token 在 7 天內有效

### P3: 登出功能

- [ ] **登出流程**
  - [ ] 主頁右上角顯示登出圖示按鈕
  - [ ] 點擊登出按鈕
  - [ ] 成功清除登入狀態
  - [ ] 自動導向登入頁面

### P4: 施工中主頁

- [ ] **主頁顯示正確**
  - [ ] 顯示綠色標題列 (#86EFCC)
  - [ ] 顯示施工圖示
  - [ ] 顯示「施工中」標題
  - [ ] 顯示「功能開發中，敬請期待」訊息
  - [ ] 右上角顯示登出按鈕

### 邊界情況測試

- [ ] **OAuth 授權取消**
  - [ ] 在 OAuth 頁面點擊取消
  - [ ] 返回登入頁面
  - [ ] 顯示適當的提示訊息

- [ ] **網路連線失敗**
  - [ ] 關閉網路連線
  - [ ] 嘗試登入
  - [ ] 顯示「網路連線失敗」錯誤訊息
  - [ ] 允許重試

- [ ] **Token 過期**
  - [ ] 手動設定過期的 token
  - [ ] 重新開啟應用程式
  - [ ] 自動導向登入頁面

---

## 7. 常見問題排除

### 建構錯誤

**問題**: `pub get` 失敗

```bash
# 解決方案: 清除快取並重新安裝
flutter clean
flutter pub get
```

**問題**: 程式碼產生失敗

```bash
# 解決方案: 刪除已產生的檔案並重新產生
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete
flutter pub run build_runner build --delete-conflicting-outputs
```

### OAuth 問題

**問題**: Google 登入失敗 "Client ID mismatch"

- 檢查 `GOOGLE_CLIENT_ID` 是否正確
- 確認 Bundle ID / Package Name 與 Google Console 設定一致
- iOS: 檢查 `Info.plist` 中的 `GIDClientID`

**問題**: Facebook 登入無反應

- 檢查 `FACEBOOK_APP_ID` 是否正確
- 確認 Facebook App 已啟用 "Facebook Login"
- 檢查 OAuth 重新導向 URI 設定

### 深層連結問題

**問題**: OAuth 回呼後應用程式無反應

```bash
# Android: 測試深層連結
adb shell am start -W -a android.intent.action.VIEW \
  -d "com.example.moneymanager://login-callback"

# iOS: 在 Xcode 中檢查 URL Scheme 設定
```

### Supabase 連線問題

**問題**: "Invalid API key" 錯誤

- 檢查 `.env` 中的 `SUPABASE_URL` 和 `SUPABASE_ANON_KEY`
- 確認 Supabase 專案已啟用 OAuth providers
- 檢查 Supabase Dashboard 的 API settings

---

## 8. 效能檢查

### 應用程式啟動時間

```bash
# 測量首次啟動時間
flutter run --profile --trace-startup

# 分析啟動追蹤
flutter analyze --profile
```

### Bundle 大小

```bash
# 分析 APK 大小
flutter build apk --analyze-size

# 分析 iOS App 大小
flutter build ios --analyze-size
```

---

## 9. 下一步

完成快速開始設定後，您可以：

1. **閱讀程式碼**: 瀏覽 `lib/features/` 目錄了解功能實作
2. **執行測試**: 確保所有測試通過 (`flutter test`)
3. **查看文件**: 閱讀 `research.md` 了解技術決策
4. **開始開發**: 參考 `tasks.md` 開始實作新功能

---

## 10. 聯絡資訊

遇到問題？請聯絡團隊：

- **Backend Team**: backend@money-manager.example.com
- **Frontend Team**: frontend@money-manager.example.com
- **Issue Tracker**: [GitHub Issues](https://github.com/chunchun1213/money-manager-frontend/issues)

---

## 附錄 A: 專案結構

```
money-manager-frontend/
├── lib/
│   ├── core/                    # 核心功能
│   │   ├── api/                 # API 客戶端
│   │   ├── auth/                # 認證服務
│   │   ├── routing/             # 路由設定
│   │   ├── theme/               # 主題設定
│   │   └── widgets/             # 共用元件
│   ├── features/                # 功能模組
│   │   ├── auth/                # 認證功能
│   │   │   ├── models/          # 資料模型
│   │   │   ├── providers/       # Riverpod providers
│   │   │   ├── screens/         # 頁面
│   │   │   └── widgets/         # 元件
│   │   └── home/                # 主頁功能
│   └── main.dart                # 應用程式入口
├── test/                        # 測試
├── integration_test/            # 整合測試
├── assets/                      # 資源檔案
│   └── icons/                   # SVG 圖示
├── .env                         # 環境變數 (不納入版控)
├── .env.example                 # 環境變數範本
├── pubspec.yaml                 # 相依套件設定
└── README.md                    # 專案說明
```

---

## 附錄 B: 有用的指令

```bash
# 格式化程式碼
flutter format .

# 靜態分析
flutter analyze

# 升級相依套件
flutter pub upgrade

# 查看過時的相依套件
flutter pub outdated

# 產生 App Icon
flutter pub run flutter_launcher_icons

# 產生 Splash Screen
flutter pub run flutter_native_splash:create

# 清理建構檔案
flutter clean

# 修復相依套件問題
flutter pub cache repair
```
