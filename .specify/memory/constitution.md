<!--
Sync Impact Report - Version 1.0.0
================================================================================
VERSION CHANGE: N/A → 1.0.0 (Initial Constitution)

BUMP RATIONALE: MAJOR - Initial ratification establishing core governance framework

PRINCIPLES DEFINED:
  ✓ I. Code Quality Standards (new)
  ✓ II. Testing Discipline (NON-NEGOTIABLE) (new)
  ✓ III. User Experience Consistency (new)
  ✓ IV. Performance Requirements (new)

SECTIONS ADDED:
  ✓ Quality Gates
  ✓ Governance

TEMPLATES STATUS:
  ✅ plan-template.md - Constitution Check section present, aligns with quality gates
  ✅ spec-template.md - Requirements sections align with UX and quality principles
  ✅ tasks-template.md - Test-first workflow aligns with Testing Discipline principle
  ✅ checklist-template.md - Compatible with quality verification workflows
  ✅ agent-file-template.md - Compatible with runtime guidance requirements
  ✅ Command files (.github/prompts/*.md) - Verified, no agent-specific references

FOLLOW-UP TODOS:
  - None

CREATED: 2025-11-19
================================================================================
-->

# Money Manager Frontend Constitution

## Core Principles

### I. Code Quality Standards

所有程式碼 MUST 遵守以下品質標準：

- **型別安全**: MUST 使用 TypeScript 嚴格模式 (`strict: true`)，禁止使用 `any` 型別除非有明確文件化的理由
- **程式碼風格**: MUST 通過 ESLint 和 Prettier 檢查，零警告零錯誤
- **元件設計**: 元件 MUST 遵循單一職責原則 (Single Responsibility Principle)，每個元件僅處理一個明確的關注點
- **可讀性**: 函式 MUST 保持簡潔（≤50 行），複雜邏輯 MUST 拆解為更小的可測試輔助函式
- **文件化**: 所有公開 API、複雜演算法、和非直觀決策 MUST 包含 JSDoc 註解說明意圖和使用方式

**理由**: 型別安全在編譯時期捕獲錯誤，減少執行時期失敗。一致的程式碼風格降低認知負荷並加速程式碼審查。清晰的結構和文件化促進知識共享，降低維護成本，並使新團隊成員能夠快速上手。

### II. Testing Discipline (NON-NEGOTIABLE)

測試 MUST 遵循嚴格的測試優先規範：

- **Test-First 工作流程**: 所有新功能和錯誤修復 MUST 遵循此流程：
  1. 撰寫測試描述預期行為
  2. 驗證測試失敗（Red）
  3. 實作最小程式碼使測試通過（Green）
  4. 重構以改善設計（Refactor）
- **測試覆蓋率**: MUST 維持最低 80% 的程式碼覆蓋率；關鍵業務邏輯（金融計算、資料驗證）MUST 達到 100%
- **測試分層策略**:
  - **單元測試**: MUST 測試純函式、工具函式、商業邏輯（隔離測試，快速執行 <1 秒）
  - **元件測試**: MUST 測試 UI 元件的渲染、使用者互動、狀態管理（使用 Testing Library 原則）
  - **整合測試**: MUST 測試 API 整合、資料流、跨元件通訊（模擬外部服務）
  - **端對端測試**: MUST 覆蓋關鍵使用者旅程和業務流程（登入、交易建立、報表產生）
- **測試品質**: 測試 MUST 獨立執行（無順序相依）、具描述性名稱、驗證行為而非實作細節

**理由**: Test-First 確保程式碼可測試性並強制釐清需求。高覆蓋率建立重構信心。分層測試策略平衡執行速度與全面性，在開發早期捕獲各層級的缺陷。

### III. User Experience Consistency

使用者介面 MUST 遵循一致性和無障礙性標準：

- **設計系統**: MUST 使用統一的設計 token 系統定義顏色、字體大小、間距、圓角、陰影等視覺屬性
- **元件庫**: MUST 優先使用共享元件庫中的可重用元件，避免重複建立類似功能的元件
- **回應式設計**: 所有介面 MUST 支援以下斷點並提供適當的佈局：
  - 行動裝置: ≥375px（主要目標）
  - 平板: ≥768px
  - 桌面: ≥1024px
- **無障礙性 (WCAG 2.1 AA)**: MUST 符合以下標準：
  - 所有互動元素 MUST 支援鍵盤導航（Tab、Enter、Escape）
  - 顏色對比度 MUST 符合 4.5:1（一般文字）和 3:1（大型文字及 UI 元件）
  - 圖片和圖示 MUST 有有意義的 alt 文字
  - 表單欄位 MUST 有關聯的標籤和清晰的錯誤訊息
  - 使用語義化 HTML（`<button>`、`<nav>`、`<main>`）
- **載入狀態**: 所有非同步操作 MUST 提供視覺回饋（載入指示器、骨架畫面、或進度條）
- **錯誤處理**: 錯誤訊息 MUST 清晰、可操作、使用者友善，避免技術術語（例如："無法儲存交易資料" 而非 "HTTP 500 錯誤"）

**理由**: 一致的設計降低使用者的學習曲線並建立信任感。無障礙性確保所有使用者（包含視覺障礙、行動不便者）都能使用應用程式，並符合法規要求。即時回饋改善感知效能並減少使用者焦慮。

### IV. Performance Requirements

效能 MUST 符合以下可測量標準（基於 Core Web Vitals）：

- **初始載入效能**:
  - First Contentful Paint (FCP) MUST ≤1.5 秒
  - Largest Contentful Paint (LCP) MUST ≤2.5 秒
  - Time to Interactive (TTI) MUST ≤3.5 秒
- **互動效能**:
  - First Input Delay (FID) MUST ≤100ms
  - Cumulative Layout Shift (CLS) MUST ≤0.1
  - 所有使用者操作（按鈕點擊、表單輸入）MUST 在 100ms 內提供視覺回饋
- **套件大小限制**:
  - 初始 JavaScript 套件 MUST ≤200KB（gzip 壓縮後）
  - 首次載入的總資產大小 MUST ≤1MB
  - 路由和大型第三方函式庫 MUST 使用程式碼分割 (code splitting) 延遲載入
- **資源最佳化**:
  - 圖片 MUST 使用現代格式（WebP、AVIF），並根據裝置提供適當尺寸
  - 關鍵 CSS MUST 內聯於 HTML，非關鍵 CSS 延遲載入
  - 第三方腳本 MUST 異步載入，並定期評估必要性
  - MUST 實作字體子集化 (font subsetting) 減少字體檔案大小
- **效能監控**: MUST 在生產環境實作 Real User Monitoring (RUM) 收集真實使用者資料，並設定效能降級警報

**理由**: 效能直接影響使用者滿意度、留存率、和轉換率。可測量的指標提供客觀的問責制，並支援資料驅動的最佳化決策。持續監控確保效能不會隨時間退化。

## Quality Gates

在程式碼合併前，以下品質關卡 MUST 全部通過：

### 自動化檢查 (CI Pipeline)

- ✅ **TypeScript 編譯**: `tsc --noEmit` 無錯誤
- ✅ **Linting**: `eslint` 檢查通過，零錯誤零警告
- ✅ **格式化**: `prettier --check` 通過
- ✅ **測試執行**: 所有測試（單元、元件、整合）通過
- ✅ **測試覆蓋率**: 整體覆蓋率 ≥80%，新程式碼覆蓋率 ≥90%
- ✅ **套件大小分析**: 套件增長 ≤10%（超過需文件化說明）
- ✅ **無障礙性測試**: `axe-core` 或等效工具無違規項目
- ✅ **安全性掃描**: 相依套件無已知高危漏洞

### 程式碼審查 (人工審查)

- ✅ 至少一位團隊成員批准
- ✅ 所有審查意見已解決或明確記錄為後續處理
- ✅ 新功能有對應的測試（先寫測試，測試失敗，然後實作）
- ✅ 破壞性變更有文件說明和遷移指南
- ✅ 效能影響已評估（必要時提供效能基準測試結果）
- ✅ 符合憲法原則（程式碼品質、測試、UX、效能）

### 部署前驗證

- ✅ 在 staging 環境完成驗證
- ✅ 關鍵使用者流程手動測試通過
- ✅ Lighthouse 效能評分 ≥90（行動和桌面）
- ✅ 跨瀏覽器測試完成（Chrome、Firefox、Safari 最新兩個版本）
- ✅ 視覺回歸測試通過（使用截圖比對或視覺測試工具）

## Governance

### 憲法權威

本憲法定義本專案的不可協商原則和標準：

- 本憲法 **SUPERSEDES** 所有其他開發實務、團隊慣例、和個人偏好
- 所有 Pull Request MUST 經過憲法合規檢查才能合併
- 程式碼審查者 MUST 驗證變更符合所有憲法原則
- 違反憲法的程式碼不得合併至主分支，除非遵循豁免流程（見下文）

### 豁免流程

在極少數情況下若必須違反憲法原則，MUST 遵循以下流程：

1. **文件化違規**: 在 Pull Request 描述中明確說明：
   - 違反了哪個原則？
   - 為什麼必須違反？
   - 評估過哪些替代方案？為何不採用？
2. **提案審查**: 提出至少一個更簡單的替代方案，並解釋為何不可行
3. **多重批准**: 需要至少兩位資深開發者的明確批准
4. **技術債務追蹤**: 建立 issue 追蹤此違規，並制定解決計畫和時間表

### 修訂流程

憲法修訂 MUST 遵循結構化流程確保深思熟慮：

1. **提案階段**: 在專案儲存庫建立 issue 詳細說明：
   - 提議的修訂內容
   - 修訂理由和背景
   - 對現有程式碼的影響範圍
2. **討論期**: 團隊成員討論至少 3 個工作日，收集意見和疑慮
3. **文件化**: 更新憲法文件，包含：
   - 變更的完整說明
   - 理由和影響分析
   - 範例展示如何應用新原則
4. **遷移計畫**: 若修訂影響現有程式碼，MUST 提供：
   - 明確的遷移步驟
   - 時間表和里程碑
   - 負責人和資源需求
5. **批准機制**: 需要團隊共識（至少 75% 成員投票同意）
6. **版本更新**: 根據語義化版本規則更新版本號：
   - **MAJOR (X.0.0)**: 移除或重新定義原則（破壞性變更）
   - **MINOR (0.X.0)**: 新增新原則或顯著擴展現有指南
   - **PATCH (0.0.X)**: 澄清措辭、修正錯誤、非語義性改進

### 合規審查

定期審查確保憲法持續有效：

- **季度審查**: 每季度檢視憲法合規狀況
- **識別模式**: 收集系統性違規或常見豁免請求
- **改善計畫**: 針對問題領域制定改善措施
- **工具更新**: 更新 linting 規則、自動化檢查、CI pipeline 以更好地強制執行原則
- **教育訓練**: 根據審查結果舉辦團隊工作坊或分享會

### 執行時期指導

日常開發 MUST 使用以下資源確保符合憲法：

- 使用 `.specify/templates/` 中的範本進行功能規格、計畫、任務分解
- 使用 `.github/prompts/` 中的 Speckit 命令自動化規範工作流程（`/speckit.specify`、`/speckit.plan`、`/speckit.tasks` 等）
- 新團隊成員 MUST 在入職第一週閱讀並理解本憲法
- 技術決策討論 MUST 參照憲法原則作為決策框架
- 爭議解決 MUST 以憲法原則為最終仲裁依據

**Version**: 1.0.0 | **Ratified**: 2025-11-19 | **Last Amended**: 2025-11-19
