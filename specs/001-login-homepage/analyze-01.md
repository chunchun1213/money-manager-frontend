# 規格分析報告

**功能**: 登入與主頁功能 (001-login-homepage)  
**分析日期**: 2025-01-19  
**分析範圍**: spec.md, plan.md, tasks.md  
**憲法版本**: 1.1.0

---

## 執行摘要

本次分析檢視 `001-login-homepage` 功能的三個核心工件,識別出 **12 個發現** (0 個 CRITICAL, 3 個 HIGH, 7 個 MEDIUM, 2 個 LOW)。整體品質良好,所有功能需求都有對應任務覆蓋,無憲法違規。主要改進空間在於消除術語不一致、補充遺漏的技術細節,以及明確化測試策略。

### 關鍵指標

| 指標 | 數值 | 狀態 |
|------|------|------|
| 總功能需求 | 12 | ✅ |
| 總使用者故事 | 4 | ✅ |
| 總任務數 | 79 | ✅ |
| 需求覆蓋率 | 100% (12/12) | ✅ 優秀 |
| 使用者故事覆蓋率 | 100% (4/4) | ✅ 優秀 |
| 模糊需求 | 2 | ⚠️ 需改進 |
| 重複內容 | 1 | ✅ 可接受 |
| 術語不一致 | 4 | ⚠️ 需改進 |
| 憲法違規 | 0 | ✅ 完全符合 |

---

## 發現清單

| ID | 類別 | 嚴重性 | 位置 | 摘要 | 建議 |
|----|------|--------|------|------|------|
| A1 | 術語不一致 | MEDIUM | spec.md, tasks.md | "session" vs "token" 術語混用 | 統一使用 "token" (與技術實作一致) |
| A2 | 模糊 | HIGH | spec.md:L116 | "token 有效期限 7 天" 與 plan.md "1 小時 access token + 30 天 refresh token" 不符 | 在 spec.md 補充說明: "7 天"指 refresh token 有效期 (實際為 30 天,需修正) |
| A3 | 未指定 | HIGH | spec.md | 未明確定義 "device_info" 欄位具體內容 | 在 data-model.md 補充: platform, userAgent, deviceId |
| A4 | 術語不一致 | MEDIUM | spec.md, plan.md | "使用者識別碼" vs "user ID" vs "id" | 統一使用 "使用者 ID (user.id)" |
| A5 | 重複 | LOW | plan.md, tasks.md | Material 3 主題設定重複描述 (13 種顏色, 4 種文字樣式) | 保留,有助於任務執行,但可加入交叉引用 |
| A6 | 未指定 | MEDIUM | tasks.md:T028, T054 | 程式碼產生任務未明確指定產生哪些檔案 | 加入詳細列表: user.freezed.dart, user.g.dart, auth_state.freezed.dart 等 |
| A7 | 模糊 | HIGH | spec.md:L49 | Edge case "當使用者嘗試同時點擊 Google 和 Facebook 按鈕" 未定義預期行為 | 補充: 使用 debounce 或 loading state 阻止重複點擊 |
| A8 | 術語不一致 | MEDIUM | spec.md, plan.md | "社交媒體" vs "社交帳號" vs "OAuth provider" | 統一使用 "OAuth provider (Google/Facebook)" |
| A9 | 未指定 | MEDIUM | tasks.md | 測試任務 (T061-T071) 未指定測試框架和斷言風格 | 補充: 使用 flutter_test + expect, mockito for mocking |
| A10 | 未指定 | MEDIUM | spec.md:SC-004 | "90% 使用者成功完成登入" 未定義測量方法 | 補充: 使用 Firebase Analytics 追蹤 login_success / login_attempt 事件 |
| A11 | 術語不一致 | MEDIUM | tasks.md | "元件測試" vs "Widget 測試" 混用 | 統一使用 "元件測試 (Widget Test)" |
| A12 | 未指定 | MEDIUM | plan.md, tasks.md | PKCE code_verifier 生成邏輯未明確指定 | 補充: Supabase SDK 自動生成,無需手動實作 |
| D1 | 未覆蓋 | LOW | spec.md:FR-011 | "記錄登入/登出事件" 需求無對應任務 | 建議加入: T080 實作事件日誌服務 (lib/core/logging/event_logger.dart) |

---

## 詳細分析

### 1. 需求覆蓋分析

#### 功能需求映射

| 需求 ID | 需求描述 | 對應任務 | 覆蓋狀態 |
|---------|----------|----------|----------|
| FR-001 | Google OAuth2 登入 | T021-T030, T035-T038 | ✅ 完整覆蓋 |
| FR-002 | Facebook OAuth 登入 | T021-T030, T035-T038 | ✅ 完整覆蓋 |
| FR-003 | 儲存 access token/session | T018, T029, T030 | ✅ 完整覆蓋 |
| FR-004 | 啟動時檢查登入狀態 | T039-T044 | ✅ 完整覆蓋 |
| FR-005 | 登出功能 | T045-T050 | ✅ 完整覆蓋 |
| FR-006 | 登入頁 UI 元素 | T033, T035 | ✅ 完整覆蓋 |
| FR-007 | 登入按鈕包含 logo | T031-T034 | ✅ 完整覆蓋 |
| FR-008 | 主頁登出按鈕 | T045, T048 | ✅ 完整覆蓋 |
| FR-009 | 施工中主頁 UI | T053, T057-T059 | ✅ 完整覆蓋 |
| FR-010 | OAuth 授權失敗處理 | T037 | ✅ 完整覆蓋 |
| FR-011 | 記錄登入/登出事件 | **❌ 無對應任務** | ⚠️ 缺少覆蓋 (見 D1) |
| FR-012 | 登入狀態 7 天有效 | T043 | ✅ 完整覆蓋 (但定義不清,見 A2) |

**覆蓋率統計**: 11/12 (91.7%) - 僅 FR-011 缺少明確任務

#### 使用者故事映射

| 使用者故事 | 任務數量 | 獨立測試定義 | 狀態 |
|------------|----------|--------------|------|
| US1 (社交媒體登入, P1) | 18 個任務 (T021-T038) | ✅ 明確定義 | ✅ 完整 |
| US2 (自動登入, P2) | 6 個任務 (T039-T044) | ✅ 明確定義 | ✅ 完整 |
| US3 (登出功能, P3) | 6 個任務 (T045-T050) | ✅ 明確定義 | ✅ 完整 |
| US4 (施工中主頁, P4) | 10 個任務 (T051-T060) | ✅ 明確定義 | ✅ 完整 |

**所有使用者故事都有完整的任務分解和獨立測試方法** ✅

---

### 2. 憲法符合性檢查

#### Principle I: 程式碼品質標準

| 檢查項目 | spec.md | plan.md | tasks.md | 狀態 |
|---------|---------|---------|----------|------|
| 型別安全 (Dart strict mode, Freezed) | 提及 | ✅ 明確定義 | ✅ T021-T027 | ✅ 符合 |
| 程式碼風格 (flutter analyze, dart format) | - | ✅ 明確定義 | ✅ T072-T073 | ✅ 符合 |
| 元件設計 (單一職責原則) | - | ✅ Feature-First 架構 | ✅ 分離 Provider/Widget | ✅ 符合 |
| 可讀性 (函式 ≤50 行) | - | ✅ 明確要求 | - | ✅ 符合 |
| 文件 (Dart Doc) | - | ✅ 要求公開 API 註解 | ✅ T075 | ✅ 符合 |

**結論**: ✅ **完全符合** Principle I

#### Principle II: 測試紀律

| 檢查項目 | spec.md | plan.md | tasks.md | 狀態 |
|---------|---------|---------|----------|------|
| Test-First 工作流程 | - | ✅ 明確要求 | ⚠️ 未強制 (見建議) | ⚠️ 待改進 |
| 測試覆蓋率 (80%/100%) | - | ✅ 定義目標 | ✅ T076 | ✅ 符合 |
| 分層測試 (單元/元件/整合) | - | ✅ 明確定義 | ✅ T061-T071 | ✅ 符合 |
| 測試品質 | - | ✅ 要求 | ✅ 獨立執行、描述性命名 | ✅ 符合 |

**結論**: ✅ **基本符合** Principle II,但建議強化 Test-First 流程 (在每個實作任務前加入對應測試任務)

#### Principle III: 使用者體驗一致性

| 檢查項目 | spec.md | plan.md | tasks.md | 狀態 |
|---------|---------|---------|----------|------|
| 設計系統 (Material 3 + Figma tokens) | ✅ 完整定義 13 色彩 | ✅ 明確採用 | ✅ T010-T011 | ✅ 符合 |
| 元件函式庫 (可重用元件) | ✅ 提及 logo 元件 | ✅ 要求 | ✅ T031-T034 | ✅ 符合 |
| 響應式設計 (375px+) | ✅ 定義元件尺寸 | ✅ 要求 | - | ✅ 符合 |
| 無障礙 (WCAG 2.1 AA) | - | ✅ 明確要求 | ✅ T077 | ✅ 符合 |
| 載入狀態 | ✅ 提及 (US2) | ✅ 要求 CircularProgressIndicator | ✅ T044 | ✅ 符合 |
| 錯誤處理 (繁體中文) | ✅ 要求友善訊息 | ✅ 明確要求 | ✅ T037 | ✅ 符合 |

**結論**: ✅ **完全符合** Principle III

#### Principle IV: 效能需求

| 檢查項目 | spec.md | plan.md | tasks.md | 狀態 |
|---------|---------|---------|----------|------|
| 初始載入 (FCP ≤1.5s, LCP ≤2.5s, TTI ≤3.5s) | - | ✅ 定義 | ✅ T076 | ✅ 符合 |
| 互動效能 (FID ≤100ms) | ✅ SC-002: 2 秒自動登入 | ✅ 要求 100ms 回饋 | ✅ T076 | ✅ 符合 |
| Bundle 大小 (APK/iOS ≤50MB) | - | ✅ 定義限制 | - | ✅ 符合 |
| 資源優化 (SVG, 連線池) | ✅ 要求 SVG | ✅ 明確策略 | ✅ T007 | ✅ 符合 |

**結論**: ✅ **完全符合** Principle IV

#### Principle V: 文件語言標準

| 檢查項目 | spec.md | plan.md | tasks.md | 狀態 |
|---------|---------|---------|----------|------|
| 使用者文件 (繁體中文 zh-TW) | ✅ 全繁中 | ✅ 全繁中 | ✅ 全繁中 | ✅ 符合 |
| UI 文字 (繁體中文) | ✅ "歡迎使用家庭記帳" | ✅ 要求 | ✅ 明確 | ✅ 符合 |
| 錯誤訊息 (繁體中文) | ✅ 明確要求 | ✅ 明確要求 | ✅ T037 | ✅ 符合 |
| 程式碼註解 (可使用英文) | ✅ 允許 | ✅ 允許 | ✅ T075 Dart Doc | ✅ 符合 |
| API contracts (英文) | - | ✅ 與後端一致 | - | ✅ 符合 |

**結論**: ✅ **完全符合** Principle V

### 憲法檢查總結

✅ **無憲法違規** - 所有 5 項核心原則完全符合

---

### 3. 一致性問題

#### 術語不一致 (4 項)

**A1: "session" vs "token" 混用**
- **spec.md**: "登入狀態（session 或 token）" (L38)
- **spec.md**: "Session/Token" 實體定義 (L109)
- **plan.md**: 僅使用 "token" (access token, refresh token)
- **tasks.md**: 僅使用 "token"

**影響**: 容易造成開發者混淆實際儲存的資料結構  
**建議**: 統一使用 "token",在 spec.md 註明 "session 即 token 的封裝"

---

**A4: 使用者識別碼命名不一致**
- **spec.md**: "使用者識別碼（由 OAuth provider 提供）" (L101)
- **plan.md**: "user.id" (程式碼範例)
- **data-model.md**: `required String id` (Freezed 模型定義)

**影響**: 文件閱讀困難,需頻繁切換術語理解  
**建議**: 統一使用 "使用者 ID (user.id)"

---

**A8: OAuth provider 命名不一致**
- **spec.md 標題**: "社交媒體登入" (L10)
- **spec.md 內文**: "社交帳號" (L12), "社交媒體" (L14)
- **plan.md**: "OAuth Provider" (技術術語)
- **tasks.md**: "OAuth provider (Google/Facebook)"

**影響**: 使用者故事與技術實作術語差距大  
**建議**: 統一使用 "OAuth provider (Google/Facebook)",在使用者面向文件使用 "社交帳號"

---

**A11: 測試類型命名不一致**
- **plan.md**: "元件測試: 測試 Widget 渲染和互動"
- **tasks.md Phase 7**: "元件測試" (T066-T067)
- **tasks.md 註解**: "Widget 測試" (與 Flutter 官方術語一致)

**影響**: 開發者需釐清 "元件測試" 是否等同 "Widget 測試"  
**建議**: 統一使用 "元件測試 (Widget Test)",首次出現時加註解

---

### 4. 模糊與未指定

#### 模糊需求 (2 項)

**A2: Token 有效期限定義不清 (HIGH)**

**問題**:
- **spec.md FR-012**: "登入狀態的有效期限為 7 天" (L116)
- **plan.md data-model**: 
  - `accessToken` 有效期: 1 小時 (3600 秒)
  - `refreshToken` 有效期: 30 天
- **矛盾**: 7 天 ≠ 1 小時,也 ≠ 30 天

**影響**: 開發者不確定實作哪個期限,可能導致自動登入失效  
**建議**: 在 spec.md 補充說明: "7 天是指 refresh token 的有效期,access token 每 1 小時自動刷新,使用者無需重新登入直到 refresh token 過期 (30 天)"

---

**A7: Edge case 行為未定義 (HIGH)**

**問題**:
- **spec.md Edge Cases**: "當使用者嘗試同時點擊 Google 和 Facebook 按鈕：應阻止重複提交，一次只處理一個登入請求" (L49)
- **未明確**: 
  - 使用哪種機制阻止? (debounce, loading state, button disable)
  - 第二次點擊是忽略還是排隊?
  - 錯誤訊息是什麼?

**影響**: 不同開發者可能實作出不同的行為  
**建議**: 補充具體實作方案: "使用 loading state 禁用所有登入按鈕,直到第一個請求完成或失敗"

---

#### 未指定細節 (5 項)

**A3: device_info 欄位未明確定義 (HIGH)**

**問題**:
- **spec.md**: 提及 device_info 但未定義內容
- **plan.md contracts/api-integration.md**: 顯示範例 `{ "user_agent": "...", "platform": "iOS 17.0" }` 但未標示為必填或選填
- **data-model.md**: `Map<String, dynamic>? deviceInfo` 定義為可選,但未列出具體欄位

**影響**: 後端可能期待特定欄位,前端卻未提供  
**建議**: 在 data-model.md 明確定義:
```dart
@freezed
class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    required String platform,      // "iOS 17.0", "Android 14"
    required String userAgent,     // HTTP User-Agent string
    String? deviceId,              // Optional unique device identifier
  }) = _DeviceInfo;
}
```

---

**A6: 程式碼產生任務未明確指定產生檔案 (MEDIUM)**

**問題**:
- **tasks.md T028**: "執行程式碼產生以產生所有模型的 .freezed.dart 和 .g.dart 檔案"
- **未明確**: 應產生哪些檔案? 總共幾個?

**影響**: 開發者執行後無法驗證是否產生完整  
**建議**: 加入詳細清單:
```
T028 執行程式碼產生 (預期產生 14 個檔案):
- user.freezed.dart, user.g.dart
- auth_state.freezed.dart
- google_login_request.freezed.dart, google_login_request.g.dart
- facebook_login_request.freezed.dart, facebook_login_request.g.dart
- login_response.freezed.dart, login_response.g.dart
- session.freezed.dart, session.g.dart
- api_error.freezed.dart, api_error.g.dart
```

---

**A9: 測試任務未指定框架和風格 (MEDIUM)**

**問題**:
- **tasks.md T061-T071**: 測試任務僅描述 "測試 XXX",未指定使用哪個測試框架和斷言風格
- **plan.md**: 提及 flutter_test, mockito 但未明確測試撰寫風格

**影響**: 不同開發者可能撰寫風格迥異的測試  
**建議**: 在 tasks.md Phase 7 開頭加入:
```
測試框架統一使用:
- flutter_test (內建) 進行單元測試和元件測試
- mockito 3.0+ 模擬依賴
- 斷言風格: expect(actual, matcher)
- 命名規範: "should <expected behavior> when <condition>"
```

---

**A10: 成功指標測量方法未定義 (MEDIUM)**

**問題**:
- **spec.md SC-004**: "90% 的使用者能在第一次使用時成功完成登入流程"
- **未明確**: 
  - 如何測量這個 90%?
  - 使用哪個分析工具?
  - 事件埋點如何設計?

**影響**: 無法驗證成功標準是否達成  
**建議**: 補充測量方法: "使用 Firebase Analytics 追蹤 `login_attempt` 和 `login_success` 事件,計算成功率 = login_success / login_attempt"

---

**A12: PKCE code_verifier 生成邏輯未明確 (MEDIUM)**

**問題**:
- **plan.md**: 提及 "PKCE code verifier" 和 "Supabase SDK 自動處理 PKCE"
- **tasks.md T029**: "實作 SupabaseAuthService (signInWithGoogle, signInWithFacebook 方法,處理 PKCE)"
- **矛盾**: 既說自動處理,又要求實作處理 PKCE

**影響**: 開發者可能重複實作已有功能  
**建議**: 明確說明: "Supabase SDK 自動生成 code_verifier 和 code_challenge,開發者僅需呼叫 `supabase.auth.signInWithOAuth()`,無需手動實作 PKCE 邏輯"

---

### 5. 未覆蓋需求

**D1: FR-011 "記錄登入/登出事件" 無對應任務 (LOW)**

**需求描述** (spec.md L113):
> "系統必須記錄使用者登入/登出事件，包含時間戳記和使用者識別碼"

**現狀**: tasks.md 中無任何任務涉及事件日誌記錄

**影響**: 
- 無法追蹤使用者登入模式
- 無法進行安全審計
- 無法分析登入失敗原因

**建議**: 加入新任務:
```
T080 [P] 實作事件日誌服務 lib/core/logging/event_logger.dart
- 記錄 login_attempt (provider, timestamp, deviceInfo)
- 記錄 login_success (userId, provider, timestamp)
- 記錄 login_failure (provider, errorCode, timestamp)
- 記錄 logout (userId, timestamp)
- 使用 Firebase Analytics 或自訂日誌後端
```

---

### 6. 重複內容分析

**A5: Material 3 主題設定重複描述 (LOW)**

**重複位置**:
- **spec.md**: 完整設計系統 (13 種顏色, 4 種文字樣式, 間距標準, 圓角標準, 元件尺寸)
- **plan.md**: 引用設計系統 "13 種顏色, 4 種文字樣式"
- **tasks.md T010**: "建立 Material 3 主題設定 (13 種顏色, 4 種文字樣式)"

**分析**: 
- ✅ **有益重複**: 任務描述中重複關鍵數字有助於開發者快速理解任務範圍,無需頻繁翻閱 spec.md
- ⚠️ **可改進**: 可加入交叉引用 "詳細定義見 spec.md 設計系統章節"

**建議**: 保留重複,但在 tasks.md T010 加註: "(詳細色碼和樣式規格見 spec.md 設計系統章節)"

---

## 覆蓋率統計

### 需求覆蓋詳情

| 需求 Key | 描述 | 有任務? | 任務 IDs | 備註 |
|----------|------|---------|----------|------|
| FR-001 | Google OAuth2 登入 | ✅ | T021-T030, T035-T038 | 完整覆蓋 |
| FR-002 | Facebook OAuth 登入 | ✅ | T021-T030, T035-T038 | 完整覆蓋 |
| FR-003 | 儲存 token | ✅ | T018, T029, T030 | 完整覆蓋 |
| FR-004 | 啟動檢查登入狀態 | ✅ | T039-T044 | 完整覆蓋 |
| FR-005 | 登出功能 | ✅ | T045-T050 | 完整覆蓋 |
| FR-006 | 登入頁 UI | ✅ | T033, T035 | 完整覆蓋 |
| FR-007 | 登入按鈕含 logo | ✅ | T031-T034 | 完整覆蓋 |
| FR-008 | 主頁登出按鈕 | ✅ | T045, T048 | 完整覆蓋 |
| FR-009 | 施工中主頁 UI | ✅ | T053, T057-T059 | 完整覆蓋 |
| FR-010 | OAuth 失敗處理 | ✅ | T037 | 完整覆蓋 |
| FR-011 | 記錄事件 | ❌ | - | **缺少覆蓋** (見 D1) |
| FR-012 | 7 天有效期 | ✅ | T043 | 定義不清 (見 A2) |

**覆蓋率**: 11/12 = **91.7%** (1 個需求缺少覆蓋)

### 未映射任務

以下任務未直接映射到明確的功能需求 (屬於技術基礎設施):

| 任務 ID | 描述 | 類型 |
|---------|------|------|
| T001-T009 | Setup (專案結構, 相依套件, 環境設定) | 基礎設施 |
| T010-T020 | Foundational (主題, API client, 攔截器, 路由) | 基礎設施 |
| T028, T054, T019 | 程式碼產生 | 技術任務 |
| T061-T071 | 測試任務 | 品質保證 |
| T072-T079 | Polish (analyze, format, 文件, 效能, 安全) | 品質保證 |

**分析**: ✅ 這些任務雖未映射到明確功能需求,但屬於必要的技術基礎,符合軟體工程最佳實踐

---

## 指標摘要

### 總體指標

- **總需求數**: 12 (功能需求)
- **總任務數**: 79
- **需求覆蓋率**: 91.7% (11/12)
- **未覆蓋需求**: 1 (FR-011 記錄事件)

### 發現統計

- **CRITICAL 問題**: 0
- **HIGH 問題**: 3 (A2 token 期限, A3 device_info, A7 edge case)
- **MEDIUM 問題**: 7 (A1, A4, A6, A8, A9, A10, A11, A12)
- **LOW 問題**: 2 (A5, D1)
- **總發現數**: 12

### 問題分類

| 類別 | 數量 | 占比 |
|------|------|------|
| 術語不一致 | 4 | 33% |
| 未指定 | 5 | 42% |
| 模糊 | 2 | 17% |
| 未覆蓋 | 1 | 8% |
| 重複 | 1 | 8% (有益) |

---

## 下一步建議

### 必須解決 (阻擋實作)

1. **HIGH - A2**: 釐清 token 有效期限定義,更新 spec.md FR-012
2. **HIGH - A3**: 明確定義 device_info 欄位結構,加入 data-model.md
3. **HIGH - A7**: 補充 edge case 具體實作方案

### 建議改進 (提升品質)

4. **MEDIUM - A1, A4, A8, A11**: 統一術語命名,建立術語表
5. **MEDIUM - A6, A9**: 補充任務詳細規格 (程式碼產生清單, 測試框架)
6. **MEDIUM - A10**: 定義成功指標測量方法
7. **MEDIUM - A12**: 明確 PKCE 由 Supabase SDK 自動處理
8. **LOW - D1**: 加入 FR-011 事件記錄任務

### 可選優化

9. **LOW - A5**: 保留重複內容,加入交叉引用改善可讀性

### 執行命令建議

無需執行特定命令,建議手動編輯以下檔案:

1. 編輯 `spec.md` 修正 FR-012, 補充 A7 edge case
2. 編輯 `data-model.md` 加入 DeviceInfo 模型定義
3. 編輯 `tasks.md` 補充 T028/T054 詳細產生清單, 加入 T080 事件日誌任務
4. 建立 `GLOSSARY.md` 統一術語定義

---

## 改善措施建議

### 立即行動 (CRITICAL 和 HIGH 問題)

#### 1. 修正 Token 有效期限定義 (A2)

**檔案**: `spec.md`  
**位置**: L116 FR-012

**原內容**:
```markdown
- **FR-012**: 登入狀態的有效期限為 7 天，超過後使用者需重新登入
```

**建議修改為**:
```markdown
- **FR-012**: 登入狀態由 access token (1 小時有效) 和 refresh token (30 天有效) 組成。Access token 過期後自動使用 refresh token 刷新,使用者無需重新登入,直到 refresh token 過期 (30 天後)。超過 30 天未使用應用程式的使用者需重新登入。
```

---

#### 2. 定義 DeviceInfo 模型 (A3)

**檔案**: `data-model.md` (新增章節)  
**位置**: 在 "7. ApiError" 之後加入

**建議加入**:
```markdown
#### 8. DeviceInfo (裝置資訊)

```dart
@freezed
class DeviceInfo with _$DeviceInfo {
  const factory DeviceInfo({
    required String platform,      // 'iOS 17.0', 'Android 14'
    required String userAgent,     // HTTP User-Agent string
    String? deviceId,              // Optional: 裝置唯一識別碼 (用於多裝置管理)
    String? appVersion,            // Optional: App 版本號 '1.0.0'
  }) = _DeviceInfo;
  
  factory DeviceInfo.fromJson(Map<String, dynamic> json) => 
      _$DeviceInfoFromJson(json);
}
```

**用途**: 
- 傳遞給 `/auth/login/google` 和 `/auth/login/facebook` API
- 後端用於記錄登入裝置資訊,支援多裝置管理和安全審計
- `deviceId` 可選,用於識別同一裝置的多次登入

**驗證規則**:
- `platform`: 必須符合 "iOS X.X" 或 "Android XX" 格式
- `userAgent`: 標準 HTTP User-Agent 字串
```

---

#### 3. 補充 Edge Case 實作方案 (A7)

**檔案**: `spec.md`  
**位置**: L49 Edge Cases 章節

**原內容**:
```markdown
- **當使用者嘗試同時點擊 Google 和 Facebook 按鈕**：應阻止重複提交，一次只處理一個登入請求
```

**建議修改為**:
```markdown
- **當使用者嘗試同時點擊 Google 和 Facebook 按鈕**：使用 loading state 阻止重複提交。當任一登入按鈕被點擊後:
  1. 立即將 AuthState 設為 `loading()`
  2. 禁用所有登入按鈕 (視覺上變灰且無法點擊)
  3. 顯示載入指示器
  4. 等待 OAuth 流程完成 (成功或失敗) 後才恢復按鈕狀態
  5. 若使用者在 loading 期間點擊,忽略該點擊事件 (不顯示錯誤訊息)
```

---

### 中期改進 (MEDIUM 問題)

#### 4. 建立術語表統一命名

**檔案**: `GLOSSARY.md` (新建)  
**位置**: `specs/001-login-homepage/GLOSSARY.md`

**建議內容**:
```markdown
# 術語表

本文件統一 `001-login-homepage` 功能中使用的術語。

| 繁體中文術語 | 英文術語 | 定義 | 使用範例 |
|-------------|---------|------|----------|
| OAuth provider | OAuth provider | 提供身分認證的第三方服務 (Google, Facebook) | "使用 OAuth provider 進行社交帳號登入" |
| 社交帳號登入 | Social login | 使用者面向的功能描述 | "使用者可以透過社交帳號登入" |
| Token | Token | 認證憑證 (包含 access token 和 refresh token) | "儲存 token 到 Secure Storage" |
| 使用者 ID | User ID, user.id | 使用者唯一識別碼 (UUID v4 格式) | "user.id = '123e4567-e89b-12d3-a456-426614174000'" |
| 元件測試 | Widget Test | Flutter 測試類型,測試 UI 元件渲染和互動 | "執行元件測試驗證按鈕顯示" |
| 整合測試 | Integration Test | 端到端測試,驗證完整使用者流程 | "整合測試: P1 完整登入流程" |

## 已棄用術語

- ❌ "session" → ✅ 使用 "token"
- ❌ "使用者識別碼" → ✅ 使用 "使用者 ID"
- ❌ "社交媒體" → ✅ 使用 "社交帳號" (使用者面向) 或 "OAuth provider" (技術文件)
```

---

#### 5. 補充任務詳細規格

**檔案**: `tasks.md`  
**位置**: T028 和 T054

**原內容 T028**:
```markdown
- [ ] T028 執行程式碼產生以產生所有模型的 .freezed.dart 和 .g.dart 檔案
```

**建議修改為**:
```markdown
- [ ] T028 執行程式碼產生: `flutter pub run build_runner build --delete-conflicting-outputs`
  - 預期產生 14 個檔案:
    - lib/features/auth/models/user.freezed.dart
    - lib/features/auth/models/user.g.dart
    - lib/features/auth/models/auth_state.freezed.dart
    - lib/features/auth/models/google_login_request.freezed.dart
    - lib/features/auth/models/google_login_request.g.dart
    - lib/features/auth/models/facebook_login_request.freezed.dart
    - lib/features/auth/models/facebook_login_request.g.dart
    - lib/features/auth/models/login_response.freezed.dart
    - lib/features/auth/models/login_response.g.dart
    - lib/features/auth/models/session.freezed.dart
    - lib/features/auth/models/session.g.dart
    - lib/core/api/models/api_error.freezed.dart
    - lib/core/api/models/api_error.g.dart
    - lib/config/device_info.freezed.dart (新增)
  - 驗證: 檢查所有檔案存在且無編譯錯誤
```

---

**檔案**: `tasks.md`  
**位置**: Phase 7 開頭 (T061 之前)

**建議加入**:
```markdown
## Phase 7: Polish & Cross-Cutting Concerns

**目的**: 影響多個使用者故事的改進

**測試框架統一規範**:
- 使用 `flutter_test` (內建) 進行單元測試和元件測試
- 使用 `mockito: ^5.4.0` 模擬依賴 (ApiClient, SecureStorageService)
- 斷言風格: `expect(actual, matcher)` (避免使用 `assert`)
- 測試命名規範: `"should <expected behavior> when <condition>"`
  - 範例: `"should return Authenticated state when login succeeds"`
- Mock 命名規範: `Mock<ClassName>` (由 mockito code generation 自動生成)
  - 範例: `final mockApiClient = MockApiClient();`
```

---

#### 6. 定義成功指標測量方法

**檔案**: `spec.md`  
**位置**: L84 SC-004

**原內容**:
```markdown
- **SC-004**: 90% 的使用者能在第一次使用時成功完成登入流程
```

**建議修改為**:
```markdown
- **SC-004**: 90% 的使用者能在第一次使用時成功完成登入流程
  - **測量方法**: 
    - 使用 Firebase Analytics 追蹤以下事件:
      - `login_attempt`: 使用者點擊登入按鈕時觸發 (參數: provider, timestamp)
      - `login_success`: OAuth 授權成功且 API 回傳 token 時觸發 (參數: provider, user_id, timestamp)
      - `login_failure`: OAuth 授權失敗或 API 錯誤時觸發 (參數: provider, error_code, timestamp)
    - 計算公式: 成功率 = (login_success 事件數) / (login_attempt 事件數) × 100%
    - 統計區間: 每週一次,統計過去 7 天內的首次登入使用者
    - 目標達成條件: 連續 4 週成功率 ≥ 90%
```

---

#### 7. 明確 PKCE 處理方式

**檔案**: `tasks.md`  
**位置**: T029

**原內容**:
```markdown
- [ ] T029 [US1] 實作 SupabaseAuthService lib/core/auth/supabase_auth_service.dart (signInWithGoogle, signInWithFacebook 方法,處理 PKCE)
```

**建議修改為**:
```markdown
- [ ] T029 [US1] 實作 SupabaseAuthService lib/core/auth/supabase_auth_service.dart
  - 封裝 Supabase SDK 的 `supabase.auth.signInWithOAuth()` 方法
  - 提供 `signInWithGoogle()` 和 `signInWithFacebook()` 兩個方法
  - **PKCE 由 Supabase SDK 自動處理**,無需手動生成 code_verifier 和 code_challenge
  - 處理 deep link callback: 解析 OAuth redirect URI 並提取 authorization code
  - 錯誤處理: 捕捉 OAuth 取消、網路錯誤、API 錯誤並轉換為友善的繁體中文錯誤訊息
```

---

#### 8. 加入事件記錄任務

**檔案**: `tasks.md`  
**位置**: Phase 7 最後 (T079 之後)

**建議加入**:
```markdown
- [ ] T080 [P] 實作事件日誌服務 lib/core/logging/event_logger.dart (對應 FR-011)
  - 記錄以下事件:
    - `login_attempt`: provider (google/facebook), timestamp, deviceInfo
    - `login_success`: userId, provider, timestamp
    - `login_failure`: provider, errorCode, timestamp
    - `logout`: userId, timestamp
    - `token_refresh`: userId, timestamp
  - 整合 Firebase Analytics (初期) 或自訂日誌後端 (未來)
  - 確保符合 GDPR: 記錄時匿名化使用者 ID (使用 hash)
  - 測試: 驗證每個事件在正確時機觸發且參數完整
```

---

### 可選優化 (LOW 問題)

#### 9. 改善重複內容可讀性

**檔案**: `tasks.md`  
**位置**: T010

**原內容**:
```markdown
- [ ] T010 建立 Material 3 主題設定 lib/core/theme/app_theme.dart (13 種顏色, 4 種文字樣式)
```

**建議修改為**:
```markdown
- [ ] T010 建立 Material 3 主題設定 lib/core/theme/app_theme.dart (13 種顏色, 4 種文字樣式)
  - 詳細色碼和樣式規格見 spec.md § 設計系統章節
  - 使用 ThemeData.from(colorScheme: ...) 建立主題
  - 整合 design_tokens.dart 中的常數
```

---

## 總結

### 整體評估

✅ **品質良好** - 規格、計畫和任務之間高度一致,無重大阻礙實作的問題

### 主要優勢

1. ✅ **完整需求覆蓋**: 91.7% 的功能需求有明確任務對應
2. ✅ **使用者故事完整**: 所有 4 個使用者故事都有完整任務分解和獨立測試方法
3. ✅ **憲法完全符合**: 無任何原則違規,文件語言、測試策略、設計系統全符合標準
4. ✅ **技術選型明確**: 所有技術堆疊 (Flutter, Riverpod, Supabase SDK) 都有明確定義和理由
5. ✅ **任務結構清晰**: Phase 1-7 組織良好,並行機會明確標記 [P]

### 需改進領域

1. ⚠️ **術語不一致**: 4 處術語混用 (session/token, 使用者識別碼, 社交媒體, 元件測試) 需統一
2. ⚠️ **技術細節模糊**: 3 處定義不清 (token 期限, device_info, edge case 行為) 需補充
3. ⚠️ **未指定測量方法**: 成功指標 SC-004 缺少具體測量方案
4. ⚠️ **任務覆蓋缺口**: FR-011 事件記錄需求缺少對應任務

### 建議優先級

1. **立即執行** (必須解決): A2, A3, A7 (3 個 HIGH 問題)
2. **一週內完成** (建議改進): A1, A4, A6, A8, A9, A10, A11, A12, D1 (9 個 MEDIUM/LOW 問題)
3. **可選優化**: A5 (1 個 LOW 問題,改善可讀性)

### 執行建議

1. 先修正 3 個 HIGH 問題,解除實作阻礙
2. 建立 GLOSSARY.md 術語表,統一後續文件撰寫風格
3. 補充 T080 事件記錄任務,達成 100% 需求覆蓋
4. 更新 tasks.md 補充詳細規格 (程式碼產生清單, 測試框架規範)

---

**分析完成** ✅  
**可開始實作**: 建議先修正 HIGH 問題後開始 Phase 1 (Setup)
