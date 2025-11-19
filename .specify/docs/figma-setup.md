# Figma Personal Access Token 設定指南

**專案**: Money Manager Frontend  
**建立日期**: 2025-11-19  
**用途**: 設定 Figma 與開發環境的整合，使用 MCP (Model Context Protocol) 工具存取 Figma 設計檔案

---

## 目錄

1. [取得 Personal Access Token](#1-取得-personal-access-token)
2. [在專案中設定 Token](#2-在專案中設定-token)
3. [驗證設定](#3-驗證設定)
4. [取得 Figma 檔案資訊](#4-取得-figma-檔案資訊)
5. [常見問題排解](#5-常見問題排解)
6. [安全性最佳實務](#6-安全性最佳實務)

---

## 1. 取得 Personal Access Token

### 步驟 1.1：登入 Figma

1. 開啟瀏覽器前往 [https://www.figma.com](https://www.figma.com)
2. 使用您的 Figma 帳號登入

### 步驟 1.2：進入設定頁面

1. 點擊右上角的**個人頭像**（圓形圖示）
2. 在下拉選單中選擇 **"Settings"**（設定）

### 步驟 1.3：產生新 Token

1. 在設定頁面的左側選單找到 **"Account"** 區段
2. 滾動頁面至 **"Personal access tokens"** 區塊
3. 點擊 **"Generate new token"** 按鈕
4. 在彈出視窗中：
   - **Token name**（Token 名稱）：輸入描述性名稱，例如：`money-manager-frontend-dev`
   - **Expiration**（到期時間）：建議選擇適當的到期時間（例如：30 天、90 天）
5. 點擊 **"Generate token"** 確認產生

### 步驟 1.4：複製並保存 Token

⚠️ **重要提醒**：Token 只會顯示一次！

1. Token 產生後會立即顯示，格式類似：
   ```
   figd_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
   ```
2. 點擊 **"Copy"** 按鈕複製 token
3. 立即將 token 保存到安全的地方（例如：密碼管理器）
4. 如果不慎遺失，需要重新產生新的 token

---

## 2. 在專案中設定 Token

### 使用環境變數檔案設定

這是最安全且最常用的方式。本專案已預先建立好所需檔案。

#### 步驟 2.1：確認專案檔案結構

專案已包含以下檔案：

- **`.env`** - 您的實際 token 儲存位置（已在 .gitignore 中，不會被提交）
- **`.env.example`** - 範本檔案，供團隊成員參考
- **`.gitignore`** - 已設定排除 `.env` 檔案

#### 步驟 2.2：編輯 `.env` 檔案設定 Token

1. 在專案根目錄開啟 `.env` 檔案
2. 找到以下這行：
   ```bash
   FIGMA_ACCESS_TOKEN=your_token_here
   ```
3. 將 `your_token_here` 替換為您在步驟 1.4 複製的實際 token：
   ```bash
   FIGMA_ACCESS_TOKEN=figd_您的實際token
   ```

**範例**（請使用您自己的 token）：
```bash
# Figma Personal Access Token for MCP integration
# 從 Figma Settings > Account > Personal access tokens 取得
# 格式: figd_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
FIGMA_ACCESS_TOKEN=figd_abc123def456ghi789jkl012mno345pqr678
```

#### 步驟 2.3：儲存檔案

- 按 `Cmd + S`（Mac）或 `Ctrl + S`（Windows/Linux）儲存 `.env` 檔案
- **不要修改 `.env.example` 檔案**（它只是範本）

#### 步驟 2.4：驗證 `.gitignore` 設定

✅ 專案的 `.gitignore` 已包含以下規則，確保 token 安全：

```gitignore
# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
.env.*.local
```

這表示您的 `.env` 檔案和實際 token **不會被提交到 Git**，保持安全。

---

## 3. 驗證設定

完成 token 設定後，請依照以下步驟驗證設定是否正確。

### 步驟 3.1：重新啟動開發環境

⚠️ **重要**：修改 `.env` 檔案後必須重新啟動，環境變數才會生效。

1. **完全關閉 VS Code**：
   - Mac: 按 `Cmd + Q` 完全退出
   - Windows/Linux: 點選 File → Exit
2. **重新開啟 VS Code**
3. **重新載入專案**：開啟 `money-manager-frontend` 資料夾

### 步驟 3.2：檢查環境變數是否載入

開啟 VS Code 內建終端機（`` Ctrl + ` `` 或 View → Terminal），執行：

```bash
# macOS/Linux
echo $FIGMA_ACCESS_TOKEN

# Windows PowerShell
echo $env:FIGMA_ACCESS_TOKEN

# Windows CMD
echo %FIGMA_ACCESS_TOKEN%
```

**預期結果**：應該會顯示您的 token（開頭為 `figd_`）

**如果顯示空白**：
- 確認 `.env` 檔案在專案根目錄
- 確認檔案格式正確，變數名稱為 `FIGMA_ACCESS_TOKEN`
- 重新啟動 VS Code
- 參考「常見問題排解」章節

### 步驟 3.3：使用 Figma MCP 工具測試連線

在 VS Code 的 GitHub Copilot Chat 中，嘗試執行 Figma MCP 命令：

**測試命令範例**：
```
請使用 mcp_talktofigma_get_selection 查看目前選取的 Figma 項目
```

或直接詢問：
```
請連線到 Figma 並取得文件資訊
```

**成功的指標**：
- ✅ 命令能正常執行，沒有 `401 Unauthorized` 錯誤
- ✅ 能夠取得 Figma 檔案或選取項目的資訊
- ✅ MCP 工具回應正常

**如果出現錯誤**：
- `401 Unauthorized` → Token 無效或未載入，檢查步驟 3.2
- `404 Not Found` → File Key 不正確或無權限存取該檔案
- 無回應 → MCP 工具未正確安裝或設定

### 步驟 3.4：測試讀取 Figma 檔案（選用）

如果您已有 Figma 檔案，可以測試讀取功能：

1. 取得您的 Figma 檔案 URL（參考第 4 節）
2. 在 Copilot Chat 中詢問：
   ```
   請讀取 Figma 檔案：https://www.figma.com/file/YOUR_FILE_KEY/File-Name
   ```
3. 如果成功，應該能看到檔案的基本資訊或結構

✅ **設定完成**！您現在可以在開發過程中使用 Figma MCP 工具了。

---

## 4. 取得 Figma 檔案資訊

要與特定 Figma 檔案互動，您需要取得該檔案的 **File Key**。

### 步驟 4.1：開啟 Figma 設計檔案

1. 在瀏覽器中開啟您的 Figma 設計檔案
2. 查看瀏覽器網址列

### 步驟 4.2：從 URL 中提取 File Key

Figma 檔案 URL 格式：
```
https://www.figma.com/file/FILE_KEY/File-Name
```

**範例**：
```
https://www.figma.com/file/abc123def456ghi789/Money-Manager-Design
```

在這個範例中：
- **File Key** = `abc123def456ghi789`
- **File Name** = `Money-Manager-Design`

### 步驟 4.3：記錄檔案資訊

建議建立一個文件記錄專案使用的 Figma 檔案：

```markdown
## Money Manager Figma 檔案

- **設計檔案**: Money Manager Design
- **File Key**: `abc123def456ghi789`
- **URL**: https://www.figma.com/file/abc123def456ghi789/Money-Manager-Design
- **用途**: 主要 UI 設計和元件庫
```

---

## 5. 常見問題排解

### Q1: Token 無效或過期

**症狀**：執行 Figma MCP 命令時出現 `401 Unauthorized` 錯誤

**解決方案**：
1. 確認 token 是否正確複製（沒有多餘空格）
2. 檢查 token 是否已過期，若是請重新產生
3. 確認環境變數名稱正確：`FIGMA_ACCESS_TOKEN`

### Q2: 環境變數未載入

**症狀**：`echo $FIGMA_ACCESS_TOKEN` 顯示空白或 `your_token_here`

**解決方案**：
1. **確認 `.env` 檔案位置**：必須在專案根目錄 `money-manager-frontend/.env`
2. **檢查檔案內容**：
   - 開啟 `.env` 檔案
   - 確認變數名稱正確：`FIGMA_ACCESS_TOKEN`（全大寫）
   - 確認已將 `your_token_here` 替換為實際 token
   - 確認 token 開頭為 `figd_`
3. **檢查檔案編碼**：確保使用 UTF-8 編碼，無 BOM
4. **完全重新啟動 VS Code**：
   - Mac: `Cmd + Q` 完全退出後重新開啟
   - Windows/Linux: File → Exit 後重新開啟
5. **檢查環境變數格式**：
   ```bash
   # 正確格式（等號兩側不要有空格）
   FIGMA_ACCESS_TOKEN=figd_your_token
   
   # 錯誤格式
   FIGMA_ACCESS_TOKEN = figd_your_token  # ❌ 有空格
   FIGMA ACCESS TOKEN=figd_your_token    # ❌ 變數名稱有空格
   ```

### Q3: 無法存取 Figma 檔案

**症狀**：Token 有效但無法讀取特定檔案

**解決方案**：
1. 確認您的 Figma 帳號有該檔案的存取權限
2. 檢查 File Key 是否正確
3. 確認檔案沒有被刪除或移動
4. 嘗試在瀏覽器中直接開啟該 Figma 檔案確認權限

### Q4: MCP 工具無法連線

**症狀**：Figma MCP 命令完全無回應或找不到

**解決方案**：
1. 確認 MCP 擴充功能已正確安裝
2. 檢查 VS Code 設定中的 MCP 設定是否正確
3. 查看 VS Code 輸出面板的錯誤訊息
4. 嘗試重新安裝 MCP 相關套件

---

## 6. 安全性最佳實務

### ✅ 應該做的事

1. **使用環境變數**：永遠將 token 儲存在環境變數或 `.env` 檔案中，不要硬編碼在程式碼裡
2. **加入 `.gitignore`**：確保 `.env` 檔案不會被提交到版本控制
3. **定期更換 Token**：建議每 30-90 天更換一次 token
4. **限制 Token 權限**：只產生必要的 token，不要重複使用
5. **使用密碼管理器**：將 token 備份儲存在安全的密碼管理器中
6. **團隊成員各自產生**：每位開發者應使用自己的 token，不要共用

### ❌ 不應該做的事

1. **不要提交到 Git**：永遠不要將 token 提交到 Git 儲存庫
2. **不要公開分享**：不要在 Slack、Email、文件中公開 token
3. **不要硬編碼**：不要將 token 直接寫在程式碼、設定檔中
4. **不要截圖分享**：分享螢幕截圖時要確保 token 不可見
5. **不要使用預設名稱**：避免使用容易被猜到的 token 名稱

### 🔒 如果 Token 外洩怎麼辦

如果懷疑 token 已經外洩：

1. **立即撤銷**：
   - 回到 Figma Settings → Personal access tokens
   - 找到該 token 並點擊 **"Revoke"**（撤銷）
2. **產生新 Token**：按照步驟 1 重新產生新的 token
3. **更新設定**：在所有使用該 token 的地方更新為新 token
4. **檢查存取記錄**：檢查 Figma 的活動記錄是否有異常存取
5. **通知團隊**：如果是團隊專案，通知相關成員

---

## 附錄：設定檢查清單

完成設定後，請逐項確認：

### 📋 Token 取得（步驟 1）
- [ ] 已登入 Figma 帳號
- [ ] 已進入 Settings → Account → Personal access tokens
- [ ] 已成功產生新 token（命名如：`money-manager-frontend`）
- [ ] 已複製 token（開頭為 `figd_`）
- [ ] 已將 token 備份到密碼管理器

### 💾 專案設定（步驟 2）
- [ ] 已在專案根目錄找到 `.env` 檔案
- [ ] 已開啟 `.env` 檔案進行編輯
- [ ] 已將 `your_token_here` 替換為實際 token
- [ ] 已確認格式正確（`FIGMA_ACCESS_TOKEN=figd_你的token`，無空格）
- [ ] 已儲存 `.env` 檔案
- [ ] 已確認 `.gitignore` 包含 `.env` 規則
- [ ] 已確認 `.env.example` 保持範本狀態（未放入實際 token）

### ✅ 驗證測試（步驟 3）
- [ ] 已完全關閉並重新開啟 VS Code
- [ ] 在終端機執行 `echo $FIGMA_ACCESS_TOKEN` 有顯示 token
- [ ] 使用 MCP 工具測試連線成功（無 401 錯誤）
- [ ] 能夠取得 Figma 檔案資訊（如有檔案）

### 🔒 安全性確認
- [ ] `.env` 檔案不會被提交到 Git（在 .gitignore 中）
- [ ] 沒有在程式碼中硬編碼 token
- [ ] 沒有在任何公開文件中貼上實際 token
- [ ] 已閱讀並理解安全性最佳實務

### 📝 可選項目
- [ ] 已取得並記錄 Figma 檔案的 File Key（如需要）
- [ ] 已建立 Figma 檔案資訊文件（參考步驟 4.3）
- [ ] 已通知團隊成員參考 `.env.example` 建立自己的 `.env`

✅ **全部完成**！您的 Figma token 已成功設定並可以使用。

---

## 相關資源

- [Figma API 官方文件](https://www.figma.com/developers/api)
- [Model Context Protocol (MCP) 文件](https://modelcontextprotocol.io/)
- [專案憲法](./../memory/constitution.md) - 安全性和文件化標準

---

**文件維護者**: 開發團隊  
**最後更新**: 2025-11-19  
**版本**: 1.0.0
