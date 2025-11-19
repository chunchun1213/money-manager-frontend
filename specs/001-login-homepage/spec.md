# Feature Specification: 登入與主頁功能

**Feature Branch**: `001-login-homepage`  
**Created**: 2025-01-15  
**Status**: Draft  
**Input**: 我希望建構登入記帳主頁功能的前端功能

## User Scenarios & Testing *(mandatory)*

### User Story 1 - 社交媒體登入 (Priority: P1)

使用者第一次開啟應用程式時，會看到登入頁面，顯示「歡迎使用家庭記帳」標題和應用程式 logo。使用者可以選擇使用 Google 或 Facebook 帳號進行登入。點擊對應的登入按鈕後，系統會導向該社交媒體的授權頁面，授權成功後返回應用程式並進入主頁。

**Why this priority**: 這是最關鍵的功能，使用者必須先登入才能使用任何其他功能。社交媒體登入降低了註冊門檻，提高使用者轉換率。

**Independent Test**: 可以透過開啟應用程式、點擊 Google 或 Facebook 登入按鈕、完成授權流程來獨立測試，並驗證是否成功進入主頁。

**Acceptance Scenarios**:

1. **Given** 使用者第一次開啟應用程式，**When** 看到登入頁面，**Then** 應顯示「歡迎使用家庭記帳」標題、應用程式 logo、Google 登入按鈕和 Facebook 登入按鈕
2. **Given** 使用者在登入頁面，**When** 點擊「Google 登入」按鈕，**Then** 應開啟 Google OAuth2 授權頁面
3. **Given** 使用者在登入頁面，**When** 點擊「Facebook 登入」按鈕，**Then** 應開啟 Facebook OAuth 授權頁面
4. **Given** 使用者完成 Google 授權，**When** 授權成功，**Then** 應返回應用程式並導向主頁，同時儲存登入狀態
5. **Given** 使用者完成 Facebook 授權，**When** 授權成功，**Then** 應返回應用程式並導向主頁，同時儲存登入狀態

---

### User Story 2 - 已登入使用者自動進入主頁 (Priority: P2)

已經完成登入的使用者再次開啟應用程式時，系統會檢查登入狀態（session 或 token），如果仍然有效，直接導向主頁而不需要重新登入。

**Why this priority**: 提升使用者體驗，避免每次開啟應用程式都需要重新登入。這是第二優先的功能，因為依賴於 P1 的登入機制。

**Independent Test**: 可以透過先完成登入、關閉應用程式、重新開啟應用程式來測試，驗證是否自動進入主頁而無需再次登入。

**Acceptance Scenarios**:

1. **Given** 使用者已在 7 天內完成過登入，**When** 重新開啟應用程式，**Then** 應直接顯示主頁（施工中頁面），而不顯示登入頁面
2. **Given** 使用者的登入狀態已過期（超過 7 天），**When** 重新開啟應用程式，**Then** 應顯示登入頁面要求重新登入

---

### User Story 3 - 登出功能 (Priority: P3)

已登入的使用者在主頁右上角可以看到登出按鈕（logout icon）。點擊登出按鈕後，系統清除登入狀態並導向登入頁面。

**Why this priority**: 登出功能讓使用者可以切換帳號或保護隱私，但不是最核心的功能。

**Independent Test**: 可以透過完成登入、進入主頁、點擊登出按鈕來獨立測試，驗證是否成功清除登入狀態並返回登入頁面。

**Acceptance Scenarios**:

1. **Given** 使用者已登入並在主頁，**When** 點擊右上角的登出圖示，**Then** 應清除所有登入資訊（session/token）並導向登入頁面
2. **Given** 使用者已登出，**When** 重新開啟應用程式，**Then** 應顯示登入頁面而非主頁

---

### User Story 4 - 顯示施工中主頁 (Priority: P4)

使用者成功登入後會進入主頁，目前主頁顯示「施工中」（Construction）狀態，包含施工圖示和「功能開發中，敬請期待」的訊息，告知使用者主要功能尚在開發中。

**Why this priority**: 這是過渡期的 UI 展示，不涉及核心功能邏輯，優先級最低。

**Independent Test**: 完成登入後進入主頁，驗證是否顯示施工圖示和提示訊息，以及右上角是否有登出按鈕。

**Acceptance Scenarios**:

1. **Given** 使用者成功登入，**When** 進入主頁，**Then** 應顯示綠色標題列、施工圖示、「施工中」標題和「功能開發中，敬請期待」訊息
2. **Given** 使用者在施工中主頁，**When** 檢視頁面元素，**Then** 應看到右上角有登出圖示按鈕

---

### Edge Cases

- **當使用者在 OAuth 授權過程中取消授權**：應返回登入頁面並顯示適當的提示訊息（如「授權已取消」），不應進入主頁
- **當使用者的網路連線中斷**：登入請求失敗時應顯示錯誤訊息（如「網路連線失敗，請檢查網路設定」），並允許使用者重試
- **當 OAuth provider 回傳錯誤**：應捕捉錯誤並顯示友善的錯誤訊息，記錄錯誤日誌供除錯
- **當登入 token 過期但應用程式仍在前景**：應提示使用者 session 已過期並導向登入頁面
- **當使用者嘗試同時點擊 Google 和 Facebook 按鈕**：應阻止重複提交，一次只處理一個登入請求

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: 系統必須提供 Google OAuth2 登入功能，點擊按鈕後開啟 Google 授權頁面
- **FR-002**: 系統必須提供 Facebook OAuth 登入功能，點擊按鈕後開啟 Facebook 授權頁面
- **FR-003**: 系統必須在 OAuth 授權成功後儲存使用者的 access token 或 session
- **FR-004**: 系統必須在使用者開啟應用程式時檢查登入狀態，有效則直接進入主頁，無效則顯示登入頁面
- **FR-005**: 系統必須提供登出功能，清除所有登入資訊並導向登入頁面
- **FR-006**: 登入頁面必須顯示應用程式 logo、「歡迎使用家庭記帳」標題、Google 登入按鈕和 Facebook 登入按鈕
- **FR-007**: 登入按鈕必須包含對應的社交媒體 logo（Google 四色 logo 和 Facebook logo）和文字（「Google 登入」、「Facebook 登入」）
- **FR-008**: 主頁必須在右上角顯示登出圖示按鈕
- **FR-009**: 施工中主頁必須顯示施工圖示、「施工中」標題和「功能開發中，敬請期待」訊息
- **FR-010**: 系統必須處理 OAuth 授權失敗的情況，顯示適當的錯誤訊息
- **FR-011**: 系統必須記錄使用者登入/登出事件，包含時間戳記和使用者識別碼
- **FR-012**: 登入狀態的有效期限為 7 天，超過後使用者需重新登入

### Key Entities

- **User**: 代表使用應用程式的使用者，關鍵屬性包含：
  - 使用者識別碼（由 OAuth provider 提供）
  - 登入方式（Google 或 Facebook）
  - 使用者名稱和電子郵件（由 OAuth provider 提供）
  - Access token 或 session 資訊
  - 登入時間和過期時間

- **Session/Token**: 代表使用者的登入狀態，關鍵屬性包含：
  - Token 值
  - 建立時間
  - 過期時間（預設 7 天）
  - 關聯的使用者識別碼

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 使用者可以在 10 秒內完成 Google 或 Facebook 登入流程（從點擊登入按鈕到進入主頁）
- **SC-002**: 已登入的使用者重新開啟應用程式時，應在 2 秒內自動進入主頁（無需重新授權）
- **SC-003**: 登出功能應在 1 秒內完成並導向登入頁面
- **SC-004**: 90% 的使用者能在第一次使用時成功完成登入流程
- **SC-005**: OAuth 授權失敗時，100% 的情況下應顯示友善的錯誤訊息並允許重試
- **SC-006**: 所有登入/登出事件都應被正確記錄，用於除錯和安全審計

## Design System *(non-mandatory)*

本節記錄從 Figma 設計檔案提取的設計系統參數，確保實作與設計完全一致。

### 色彩系統

| 色碼 | 用途 | 使用範例 |
|------|------|----------|
| `#86EFCC` | 主要品牌色 | 主頁標題列背景、「施工中」標題文字 |
| `#F9FAFB` | 背景色 | 應用程式主背景、Dashboard 背景 |
| `#FFFFFF` | 白色 | 按鈕背景、容器背景 |
| `#0A0A0A` | 深灰色/黑色 | 主標題文字「歡迎使用家庭記帳」 |
| `#354152` | 深灰色 | 按鈕文字「Google 登入」 |
| `#495565` | 中灰色 | 次要文字「功能開發中，敬請期待」 |
| `#D0D5DB` | 淺灰色 | 邊框、分隔線 |
| `#1877F2` | Facebook 品牌色 | Facebook 登入按鈕背景 |
| `#4285F4` | Google 藍色 | Google logo 藍色部分 |
| `#34A853` | Google 綠色 | Google logo 綠色部分 |
| `#FBBC05` | Google 黃色 | Google logo 黃色部分 |
| `#EA4335` | Google 紅色 | Google logo 紅色部分 |

### 文字樣式

| 樣式名稱 | 字體 | 字重 | 大小 | 行高 | 字距 | 使用範例 |
|---------|------|------|------|------|------|----------|
| 主標題 | Inter | 400 | 24px | 32px | 0.07px | 「歡迎使用家庭記帳」 |
| 強調標題 | Inter | 500 | 30px | 36px | 0.40px | 「施工中」 |
| 按鈕文字 | Inter | 500 | 14px | 20px | -0.15px | 「Google 登入」、「Facebook 登入」 |
| 次要文字 | Inter | 400 | 16px | 24px | -0.31px | 「功能開發中，敬請期待」 |

### 間距標準

- **按鈕內距 (Padding)**: 上下 `8px`、左右 `16px`
- **容器內距**: `8px`、`16px`、`24px`、`32px`（依層級遞增）
- **元素間距 (Item Spacing)**: `8px`、`12px`、`16px`、`24px`

### 圓角標準

- **按鈕圓角**: `8px`
- **容器圓角**: `10px`

### 元件尺寸

| 元件類型 | 寬度 | 高度 | 說明 |
|---------|------|------|------|
| Google/Facebook 登入按鈕 | 313px | 56px | 主要社交登入按鈕 |
| 登出圖示按鈕 | 36px | 36px | 圓形按鈕 |
| 應用程式 Logo | 自適應 | 自適應 | 依設計比例縮放 |
| 施工圖示 | 自適應 | 自適應 | 依設計比例縮放 |

### 圖示資源

所有圖示已匯出為 SVG 格式並儲存於 `specs/001-login-homepage/design-assets/` 目錄：

**社交登入圖示：**
- `google-icon-blue.svg`（Google logo 藍色部分）
- `google-icon-green.svg`（Google logo 綠色部分）
- `google-icon-yellow.svg`（Google logo 黃色部分）
- `google-icon-red.svg`（Google logo 紅色部分）
- `facebook-icon.svg`（Facebook f 字母）

**功能圖示：**
- `app-logo.svg`（應用程式 logo）
- `logout-icon-part-72.svg`、`logout-icon-part-73.svg`、`logout-icon-part-74.svg`（登出圖示組成部分）
- `construction-icon-part-86.svg` 至 `construction-icon-part-93.svg`（施工圖示組成部分，共 8 個）

> **實作提示**: 
> - Google logo 由四個顏色部分組成，需組合使用
> - 登出圖示和施工圖示各由多個 SVG 部分組成，需正確定位和組合
> - 所有顏色值必須與設計系統完全一致
> - 間距和圓角值必須使用上述標準值

## Assumptions *(non-mandatory)*

- 使用者已安裝 Google 或 Facebook 應用程式，或可透過瀏覽器完成授權
- OAuth2 授權流程由第三方函式庫處理（如 Firebase Auth 或 OAuth2 客戶端函式庫）
- 登入狀態儲存於 Local Storage 或 Secure Storage（行動裝置）
- Access token 由後端 API 驗證，前端只負責儲存和傳遞
- 應用程式為單頁應用（SPA）或行動應用程式，使用路由進行頁面導向
- 錯誤訊息顯示為 Toast 通知或 Alert 對話框
- 應用程式 logo 和社交媒體 logo 使用 SVG 格式以確保清晰度
- 預設語系為繁體中文（zh-TW）

## Dependencies *(non-mandatory)*

- **OAuth2 Provider APIs**: 依賴 Google OAuth2 和 Facebook OAuth API 的可用性
- **後端 API**: 需要後端提供使用者認證、token 驗證和使用者資訊查詢的 API 端點（具體 API 規格待後端團隊定義）
- **OAuth2 客戶端函式庫**: 依賴前端 OAuth2 客戶端函式庫（如 `@react-oauth/google` 或 Firebase Auth）
- **路由函式庫**: 依賴前端路由函式庫進行頁面導向（如 React Router 或 Next.js Router）
- **狀態管理**: 依賴前端狀態管理方案儲存和管理使用者登入狀態（如 Context API、Redux 或 Zustand）

## Out of Scope *(non-mandatory)*

本功能**不包含**以下項目，將在後續功能中實作：

- 電子郵件/密碼登入
- 手機號碼驗證登入
- 忘記密碼功能
- 使用者個人資料編輯
- 帳號刪除功能
- 多因素認證（MFA）
- 記帳功能（收支記錄、分類、報表等）
- 使用者頭像上傳
- 深色模式/淺色模式切換
- 多語系支援（目前僅支援繁體中文）
