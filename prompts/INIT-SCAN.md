# ZeroSpec — INIT-SCAN Prompt Pack

> **第一步：分析現況＋建立共識。** 將以下 Prompt 貼入 AI Agent，AI 會掃描專案後產出結構化現況盤點，**不寫入任何檔案**。

---

## 使用方式

1. 在你的專案根目錄開啟 AI 對話（優先 Agent 模式；若平台的 Plan 模式可讀取 codebase，也可用於本掃描步驟）
2. 複製下方 `---BEGIN PROMPT---` 到 `---END PROMPT---` 之間的全部內容
3. 貼入 Agent 並送出
4. Agent 掃描 Repo 後產出現況分析報告
5. 你確認分析結果、回答待確認問題（約 5–10 分鐘）
6. 確認完成後，接續使用 [`INIT-BUILD.md`](INIT-BUILD.md) 產生 `AGENTS.md` + `docs/README.md`

---

````
---BEGIN PROMPT---

## 角色

你是一位專案系統分析師。
本次任務只做分析與建議，不做實作、不產生程式碼、不直接寫入任何檔案。

## 目標

為這個專案產出一份結構化的現況盤點，並判斷如果要用最小成本導入 SDD（Specification-Driven Development），最先應該補哪些文件。

## 名詞定義

以下是 SDD 精簡模式中的四種文件類型，請依此定義進行分析：
- **SA**（System Analysis）：里程碑式分析快照，記錄規格與現狀的落差
- **ADR**（Architecture Decision Record）：單一架構決策的背景、選項與結論；不可回改，只能被新 ADR 取代
- **SPEC**（Interface Specification）：對外介面的行為契約，是開發的主要依據（Source of Truth），含 Changelog
- **INFRA**（Infrastructure）：基礎設施選型與拓撲；Library 專案可用 INTEGRATION 替代

## 分析框架

### 核心分析（必做）

1. **技術棧與執行型態**：
   - 讀取 build.gradle / package.json / .csproj / pyproject.toml / go.mod / requirements.txt / Cargo.toml 等設定檔
   - 萃取語言版本、框架版本（只寫 Major.Minor，不寫 Patch）、建置工具
   - 判斷專案型態：library / API service / frontend SPA / monorepo / CLI tool 等

2. **對外介面與整合點**：
   - API 端點、SDK、事件、排程、MQ、外部系統串接
   - 哪些介面最值得先被規格化（複雜度高、變更頻繁、或多消費方依賴）

3. **現有文件狀況**：
   - 是否有 README、設計文件、API 文件、架構文件、規格文件
   - 哪些可作為 Source of Truth
   - 哪些可能過時或不足

### 補充分析（有明確發現再寫）

4. **目錄與模組結構**：主要目錄的職責、是否有明確分層
5. **架構決策與風險線索**：從程式碼推測的重要架構選擇、可能需要補 ADR 的地方

### 分析起點

請依「根目錄設定檔（package.json / build.gradle / .csproj 等）→ 原始碼入口（src/）→ docs/ → CI/CD」的優先序掃描。

## 輸出格式

請依以下結構輸出，每個區塊控制在 5～15 行。分析過程中同步草擬 B 類內容，每段標註 `[待審核]`。

### 1. 專案現況摘要
用 5～10 點條列說明目前理解到的專案樣貌。

### 2. 技術棧萃取（A 類）
列出從設定檔自動偵測到的所有技術資訊。

### 3. 核心模組與邊界
列出主要模組、責任、上下游關係。

### 4. B 類草擬初稿
依序呈現以下 5 項，每段標註 `[待審核]`：
1. **文件導航表**：掃描 docs/，用「意圖驅動」格式（左欄「你想做什麼」，右欄路徑）
2. **領域/模組 ↔ 程式碼對照表**：掃描核心類別，依命名關聯分群
3. **架構層級描述**：從既有程式碼推斷分層模式或資料流向
4. **命名慣例**：統計既有命名模式
5. **關聯專案**：偵測 build 設定或相對路徑中的跨專案相依

### 5. 最優先應規格化的主題（1～3 個）
列出最該先建立 Source of Truth 的主題，並說明原因。

### 6. 建議的最小 SDD 文件集合
直接給建議，格式如下：
- `SA-001`：應分析什麼
- `ADR-001`：應記錄什麼決策（若無明確需求可省略）
- `SPEC-001`：應描述什麼介面或行為
- `INTEGRATION.md`：應記錄哪些整合流程（如不需要可省略）

### 7. 待確認問題（最多 5 題）
如果有無法從現況判斷的地方，列出最關鍵的問題。這些問題將在你確認後帶入下一步（INIT-BUILD）。

## 規則

- **本 Prompt 不寫入任何檔案**，僅在對話中輸出分析結果
- 以理解現況、建立最小共識為優先，不導入過重流程
- 版本只寫 Major.Minor，不寫 Patch
- 不列舉精確檔案數量，用結構模式描述（如「多支 Controller」而非「19 支 Controller」）
- 任何欄位若缺乏程式碼或設定檔證據，標註 `[待確認]`，不得猜測

---END PROMPT---
````

---

## 下一步

確認分析結果後 → 使用 [`INIT-BUILD.md`](INIT-BUILD.md) 產生 `AGENTS.md` + `docs/README.md`。
