# ZeroSpec 實踐指南

> **Zero-dependency specification framework for AI-readable repositories.**
> 讓 AI Coding Agent 在 30 秒內理解你的專案，並遵循你的架構規範產生程式碼。

**版本**：v0.1 — 2026-04-10
**適用對象**：想讓 GenAI Agent（GitHub Copilot / Codex / Claude / Gemini / Cursor）高效理解專案的工程團隊
**驗證背景**：已於含後端（.NET（C#）/ Python）、前端（React + TypeScript）與共用 Library 的多專案生態圈中實際驗證

---

## 目錄

0. [什麼是 ZeroSpec](#0-什麼是-zerospec)
1. [為什麼需要 ZeroSpec](#1-為什麼需要-zerospec)
2. [核心架構：雙檔入口模型](#2-核心架構雙檔入口模型)
3. [AGENTS.md 設計原則](#3-agentsmd-設計原則)
4. [文件分層與事件觸發](#4-文件分層與事件觸發)
5. [防漂移機制](#5-防漂移機制)
6. [反模式清單](#6-反模式清單)
7. [導入與持續運作流程](#7-導入與持續運作流程)
8. [跨專案一致性策略](#8-跨專案一致性策略)
9. [業界佐證與參考資料](#9-業界佐證與參考資料)

---

## 0. 什麼是 ZeroSpec

ZeroSpec 是一套零依賴、純 Markdown 的專案 AI 可讀性框架，定位為 **Layer 0（Context Readiness）**。

### Layer 0 vs Layer 1

| 層級        | 職責                                                           | 代表工具          |
| ----------- | -------------------------------------------------------------- | ----------------- |
| **Layer 0** | 讓專案「可被 AI 讀懂」— 架構約束、導航、Source of Truth        | **ZeroSpec**      |
| **Layer 1** | 讓 AI「照流程執行任務」— 工作流引擎、phase gate、change-folder | OpenSpec, SpecKit |

ZeroSpec 不綁定任何 IDE、代理平台或程式語言。它只做一件事：**確保 AI 在開始任何任務前，已擁有精準的專案脈絡。**

#### 與 Layer 1 工具的長期整合路徑

ZeroSpec 可以獨立運作，也可以隨團隊成熟度逐步銜接 Layer 1 工具。以下是市場主流 SDD 實務（API-First、Contract-First、phase gate）推導出的自然演進路徑，供長期評估參考：

| 階段                      | 時程參考   | 做法                                                                                               | Layer 1 工具       |
| ------------------------- | ---------- | -------------------------------------------------------------------------------------------------- | ------------------ |
| **Stage 1：建立習慣**     | Month 1–3  | AGENTS.md + 事件觸發 SPEC 更新（PR 時人工確認）；目標是讓 Agent 產出品質穩定                       | 不需要             |
| **Stage 2：加入 CI 閘門** | Month 3–6  | PR template 加 SPEC Checklist；簡單 CI script 偵測 Controller 變更但 `docs/spec/` 無異動時發出警告 | 不需要             |
| **Stage 3：Layer 1 整合** | 6 個月以上 | ZeroSpec SPEC 作為 Layer 1 工具的輸入基礎；Layer 1 在其之上疊加執行階段與核准閘門                  | OpenSpec / SpecKit |

**Stage 3 的觸發信號**：需要跨團隊 spec 核准流程、強制 phase gate、或 AI 生成管線需要自動化驗收條件。多數中小型團隊在 Stage 2 就已足夠。

**兩層文件的職責分工不重疊**：ZeroSpec SPEC（`docs/spec/SPEC-xxx.md`）= 介面契約與業務脈絡（給 Agent 讀）；Layer 1 spec = 執行流程規格（驅動 workflow engine）。導入 Stage 3 後，兩份文件並行存在，不需要合併。

### 內容產生三層分流模型

ZeroSpec 的核心創新是區分「誰來寫」，而非「要不要寫」：

| 類別                    | 誰負責               | 內容範例                                      | 人工投入    |
| ----------------------- | -------------------- | --------------------------------------------- | ----------- |
| **(A) AI 自動產生**     | AI 掃描 Repo 推導    | 技術棧、版本 SoT、目錄結構、Build 指令、Alias | 零          |
| **(B) AI 草擬、人審核** | AI 歸納模式 + 人確認 | 領域/模組對照表、架構層級、命名慣例、文件導航 | 審核 5 分鐘 |
| **(C) 人必須提供**      | 無法從程式碼推導     | 專案定位、架構硬規則、部署策略、權限格式      | 回答 5–8 題 |

人真正要「手動寫」的只有 C 類（約 5–8 條團隊決策），其餘由 AI 產生或草擬後審核。

---

## 1. 為什麼需要 ZeroSpec

現代 AI Coding Agent 在處理任務前會自動讀取專案根目錄的指引檔案（如 `AGENTS.md`、`.cursor/rules`），作為生成程式碼的約束條件。如果這些檔案結構混亂、資訊過時或缺乏關鍵規範，AI 會：

- **盲目搜尋**：浪費 token 與時間在檔案系統中找 base package 或路徑別名
- **違反架構**：在 Controller 層寫業務邏輯、用錯狀態管理方案
- **產生幻覺**：引用文件中已過時的版號或不存在的 API
- **注意力分散**：閱讀大量給人類看的安裝教學與未來規劃

ZeroSpec 的目標是：**用最少的 token 傳遞最精準的約束，讓 AI 像資深團隊成員一樣理解你的專案。**

---

## 2. 核心架構：雙檔入口模型

```
project-root/
├── AGENTS.md          ← AI 的「第一份文件」：專案定位 + 導航 + 程式碼產生規範
├── docs/
│   └── README.md      ← 文件治理中心（出現第 2 份文件時才建立）
├── *.csproj / package.json / build.gradle / pyproject.toml  ← 版本唯一真相來源
└── src/               ← 實際程式碼
```

**設計原理**：兩層分離，各司其職。

| 檔案             | 讀取時機               | 內容定位                                                        |
| ---------------- | ---------------------- | --------------------------------------------------------------- |
| `AGENTS.md`      | **每次任務前必讀**     | 「該怎麼寫程式碼」— 技術棧、架構約束、命名慣例、領域/模組對照表 |
| `docs/README.md` | **處理文件任務時讀取** | 「該怎麼管文件」— 分層規則、SoT 定義、ADR 觸發條件、命名正規式  |

這種分離確保 AI 在日常寫程式碼時不需要加載文件治理規則，減少不必要的 context 消耗。

> **ZeroSpec 原則**：Day-1 同時建立 `AGENTS.md` 與 `docs/README.md`，確保文件治理規則從第一天就位。

### 2.1 適用範圍與環境差異

同一套文件策略在不同代理執行環境（如 IDE 內建 Agent、Cloud Agent、CLI Agent）通常**方向一致但細節不完全相同**，常見差異包含：

- 指引檔案的讀取優先序（`AGENTS.md`、`.github/copilot-instructions.md`、其他平台等價檔）
- 代理是否可自動讀取跨資料夾或跨 repo 文件
- 可用工具集合（是否可跑終端機、測試、網路查詢）

建議在每個專案保留「最小可執行規範」：
- 架構約束
- build/test 指令
- 文件同步觸發條件

如此即使代理平台不同，也能保持一致的交付品質。

---

## 3. AGENTS.md 設計原則

### 3.1 必備段落與產生分類

| 段落                | 用途                            | 產生類別    | 設計要點                          |
| ------------------- | ------------------------------- | ----------- | --------------------------------- |
| **專案定位**        | 一句話說明專案                  | C — 人提供  | 包含技術棧、架構模式、部署方式    |
| **定錨資訊**        | Base Package / Alias / 版本真相 | A — AI 自動 | 消除 AI 盲搜，強制溯源設定檔      |
| **文件導航表**      | 按「想做什麼」分類              | B — AI 草擬 | 用 Markdown 表格，AI 解析效率最高 |
| **領域/模組對照表** | 業務 ↔ 程式碼映射               | B — AI 草擬 | 讓 AI 快速定位該改哪個模組        |
| **程式碼產生規範**  | 架構層級、命名、禁止事項        | C — 人提供  | 用明確的 Do / Don't 格式          |
| **常用指令**        | build / test / serve            | A — AI 自動 | 簡潔的表格即可                    |
| **關聯專案**        | 跨 repo 導航                    | B — AI 草擬 | 附上相對路徑與簡要關係說明        |
| **文件維護提醒**    | PR 觸發條件                     | C — 人提供  | 使 AI 在修改程式碼後主動同步文件  |

### 3.2 定錨資訊範例

```markdown
## 專案定位

- **技術棧**：.NET 10（C#）+ ASP.NET Core + EF Core + PostgreSQL 16
- **Base Namespace**：`MyApp.Api`、`MyApp.Service`（以 Solution 結構為準）
- **版本真相來源**：
  - .NET SDK 以 `global.json` 為準
  - 套件版本以各專案 `.csproj` 為準
```

```markdown
## 專案定位

- **技術棧**：React 19 + TypeScript 5.8 + Nx 19 Monorepo
- **Alias Mapping**：`@frontend/*` 對應 `libs/frontend/*/src/`（以 `tsconfig.base.json` 為準）
- **版本真相來源**：套件版本以 `package.json` 為唯一準據
```

### 3.3 導航表格模式

使用「意圖驅動」而非「檔案驅動」的表格：

```markdown
| 你想做什麼              | 先讀這裡                          |
| ----------------------- | --------------------------------- |
| 了解系統全貌與模組關係  | docs/analysis/SA-001              |
| 查詢某一項架構決策記錄  | docs/adr/                         |
| 了解開發流程與 Git 規範 | CONTRIBUTING.md（僅處理 PR 時讀） |
```

**關鍵**：導航表左欄使用「自然語言意圖」，讓 AI 的 intent matching 更準確。對於不常用的文件，加註閱讀前提條件以節省 token。

### 3.4 指令過載防護（Guardrails）

`AGENTS.md` 不是 onboarding 手冊。過長或過細的內容會讓 AI 失焦，反而降低準確度。

建議控制原則：

- **建議長度**：300 行 Markdown 以內（可依專案複雜度微調）
- **必備欄位**：專案定位、定錨資訊、導航表、產生規範、驗證指令、文件同步條件
- **可移除欄位**：長篇背景故事、新手安裝教學、尚未採用的未來藍圖細節

可用一句話自檢：

> 這段內容是否會讓 AI 在「下一個任務」更快做對？若答案是否定，應刪除或移到人類文件。

---

## 4. 文件分層與事件觸發

### 4.1 標準文件四層分類

| 層級                                   | 前綴        | 職責                                            | 觸發條件                        |
| -------------------------------------- | ----------- | ----------------------------------------------- | ------------------------------- |
| **SA** (System Analysis)               | `SA-xxx`    | 里程碑式系統快照                                | 架構或核心依賴變更時            |
| **ADR** (Architecture Decision Record) | `ADR-xxx`   | 單一決策永久記錄（只 Append）                   | 跨 Phase 的 either/or 選擇時    |
| **SPEC** (Interface Specification)     | `SPEC-xxx`  | 介面行為契約 + Changelog（**Source of Truth**） | **強制**：PR 修改公用介面即觸發 |
| **INFRA** (Infrastructure)             | `INFRA-xxx` | 基礎設施選型與拓撲                              | 部署/CI 配置變更時              |

**彈性擴充**：
- Library 專案可用 **INTEGRATION** 取代 INFRA（記錄跨專案整合步驟）
- 前端專案可加 **Components**（元件索引，不記錄 Props 細節）

> **ZeroSpec 原則**：未觸發事件 → 不建立文件。所有文件由 Prompt Pack 讓 AI 產生草稿，人只審核。

### 4.2 SPEC 是 Source of Truth

這是整套方法中最重要的約定：

> SPEC 是開發與 GenAI 的主要參照檔案。每次介面新增或修改都直接更新 SPEC，並在 Changelog 追蹤變更歷程。

**最低維護規則**：凡 PR 涉及介面或行為異動，使用 [SPEC Prompt Pack](prompts/SPEC.md) 讓 AI 產生/更新 SPEC 草稿，人審核後合併。

### 4.3 ADR 觸發條件的 ✅/❌ 範例

用明確的正反例降低 AI 誤判率：

```markdown
- ✅ 需要 ADR：Clean Architecture 分層策略、JWT 雙 Token 設計、Kafka vs Event Hubs
- ❌ 不需要 ADR：新增一支 CRUD API、修改 Redis TTL 預設值
```

### 4.4 需求驅動擴充（Lazy Evaluation）

不預先建立空殼文件，而是在 `AGENTS.md` 中標明觸發條件：

```markdown
| 候選文件                      | 觸發時機             |
| ----------------------------- | -------------------- |
| ADR-001_clean-architecture.md | 架構分層重構討論時   |
| SPEC-001_auth-and-rbac.md     | 認證介面需正式契約時 |
```

AI 看到觸發條件後，會在適當時機主動建議建立文件，而不是面對一堆空檔案困惑。

### 4.5 命名正規式

統一的命名規則讓 AI 能用 glob pattern 精準搜尋：

```
^(SA|ADR|SPEC|INFRA)-\d{3}_[a-z0-9-]+\.md$
```

---

## 5. 防漂移機制

文件最大的敵人是變化——程式碼改了但文件沒跟上。以下是驗證有效的防漂機制：

### 5.1 避免精確數量

**錯誤**：「本專案包含 19 支 Controller、43 個共用元件」
**正確**：「本專案提供 Web 與 Mobile 雙 Channel API，共用 Service 層」

數量描述是最容易過時的資訊。AI 不需要知道精確數量，它需要知道**結構模式**。

### 5.2 單一真相宣告

在 AGENTS.md 宣告「版本真相來源」後，文件中的版本號只是**提示**，AI 在需要精確版本時會自動去讀設定檔：

```markdown
- **版本真相來源**：套件版本以各專案 `.csproj` 為準，.NET SDK 以 `global.json` 為準
```

### 5.3 去重複規則

同一資訊只在一處出現。如果必須在兩處提到，第二處使用「見 X 宣告」的引用句型：

```markdown
- 使用 TypeScript 嚴格模式（版本見技術棧宣告）
- 使用 AutoMapper（版本以 `.csproj` 為準）
```

### 5.4 閱讀範圍限縮

對於內容龐大但日常任務不需要的文件，用前提條件限制 AI 的讀取行為：

```markdown
| 了解 Git 協作規範 | CONTRIBUTING.md（僅在處理 Git/PR 任務時，優先讀 PR 流程與快速檢查清單）|
```

### 5.5 版本精度規範

| 項目       | 準確度      | 範例                                         | 理由                           |
| ---------- | ----------- | -------------------------------------------- | ------------------------------ |
| 語言版本   | Major       | C#（見 `.csproj` `LangVersion` 或 SDK 對應） | 語言版本決定語法可用性         |
| SDK 版本   | Major       | .NET SDK 10                                  | SDK 影響編譯器與工具鏈         |
| 框架版本   | Major.Minor | ASP.NET Core 10.0                            | Minor 版決定 API 可用性        |
| 工具版本   | Major.Minor | TypeScript 5.8                               | Minor 版影響建置行為           |
| Patch 版本 | **不寫**    | —                                            | 最容易漂移，強制 AI 讀取設定檔 |

---

## 6. 反模式清單

完整清單請見 [anti-patterns.md](anti-patterns.md)。以下為最常見的項目：

| 反模式               | 問題                                 | 修正方法                           |
| -------------------- | ------------------------------------ | ---------------------------------- |
| 寫死 Patch 級版本號  | `ASP.NET Core 10.0.5` 下次升版就過時 | 只寫 Major.Minor + 指向設定檔      |
| 列舉精確檔案數量     | 「43 個元件」新增一個就脫鉤          | 描述結構模式而非計數               |
| 同一版本號出現在兩處 | 一處改了另一處忘記                   | 第二處用「見 X」引用               |
| 大段人類入職教學     | brew install/git 入門佔用 AI context | 移至人類專用 README 或限縮讀取範圍 |
| 導航表用檔名而非意圖 | AI 無法 intent-match                 | 左欄用「你想做什麼」自然語言       |

---

## 7. 導入與持續運作流程

ZeroSpec 的導入分為「分析 → 建置 → 驗證 → 事件觸發 → 定期回顧」五個階段，前三個階段在 Day-1 完成。

### Step 1：分析現況（INIT-SCAN）

1. 複製 [`prompts/INIT-SCAN.md`](prompts/INIT-SCAN.md) 的 Prompt 貼入任一 AI Agent
2. Agent 自動掃描 Repo，產出結構化現況盤點（不寫入任何檔案）
3. 你確認分析結果、回答 2–3 個待確認問題（約 5–10 分鐘）

這個步驟確保人與 AI 先對齊對專案的理解，再進入文件產生。

### Step 2：建置文件（INIT-BUILD）

1. 複製 [`prompts/INIT-BUILD.md`](prompts/INIT-BUILD.md) 的 Prompt 貼入同一對話
2. Agent 詢問 C 類問題（專案定位、架構硬規則、部署策略），你回答 5–8 題
3. Agent 產出 `AGENTS.md` + `docs/README.md`
4. 審核 B 類草稿（領域/模組對照表、命名慣例），調整後存檔
5. AI 提供現況評估：掃描摘要、建議第一份 SPEC、建議最小文件集、下一步行動

### Step 3：驗證

1. 用產出的 `AGENTS.md` 跑一個真實小任務（例如新增一支 API）
2. 確認 Agent 遵守架構分層、使用正確的 Base Package、執行 build/test
3. 若有偏差，調整 `AGENTS.md` 中對應的硬規則描述

### Step 4：事件觸發擴張

| 觸發事件             | 使用 Prompt Pack                                 | 產生/更新文件                       |
| -------------------- | ------------------------------------------------ | ----------------------------------- |
| Day-1 初始化（分析） | [`prompts/INIT-SCAN.md`](prompts/INIT-SCAN.md)   | 現況盤點報告（不寫檔）              |
| Day-1 初始化（建置） | [`prompts/INIT-BUILD.md`](prompts/INIT-BUILD.md) | `AGENTS.md` + `docs/README.md`      |
| 新增/變更對外 API    | [`prompts/SPEC.md`](prompts/SPEC.md)             | `docs/spec/SPEC-xxx.md`             |
| 跨模組技術二選一決策 | [`prompts/ADR.md`](prompts/ADR.md)               | `docs/adr/ADR-xxx.md`               |
| 需要系統全貌快照     | [`prompts/SA.md`](prompts/SA.md)                 | `docs/analysis/SA-xxx.md`           |
| 專案演進需同步文件   | [`prompts/UPDATE.md`](prompts/UPDATE.md)         | 更新 `AGENTS.md` + `docs/README.md` |
| **未觸發以上事件**   | —                                                | **不建立任何文件**                  |

### Step 5：定期回顧

SDD 機制的持續運作不只依賴事件觸發，還需要定期回顧以確保文件不漂移。

#### 快速回顧（建議每月一次，約 15 分鐘）

- [ ] AGENTS.md 的領域/模組對照表是否與程式碼現況一致？
- [ ] 版本真相來源所指的設定檔是否仍正確？
- [ ] SPEC Changelog 是否跟上近期的程式碼變更？
- [ ] 有無新模組未被對照表覆蓋？
- [ ] 有無低價值規則可以刪除？

> 使用 [`prompts/UPDATE.md`](prompts/UPDATE.md) 執行回顧後的更新。

#### 完整回顧（建議每季一次）

除快速回顧全部項目外，加上：

- [ ] 架構硬規則是否仍反映團隊共識？（與團隊成員確認）
- [ ] AI Agent 是否仍頻繁違反某條規則？（若是，優先調整該規則的描述清晰度）
- [ ] 事件觸發表的各 Prompt Pack 是否仍符合團隊工作流？
- [ ] 參考資料中的連結是否仍有效？

### 驗收指標

| 指標                       | 目標      |
| -------------------------- | --------- |
| Day-1 人工投入時間         | ≤ 30 分鐘 |
| 人工新寫內容比例（C 類）   | ≤ 20%     |
| 首次回合可合併率           | ≥ 70%     |
| 架構硬規則違反率           | ≤ 10%     |
| API 變更後 SPEC 草稿覆蓋率 | ≥ 90%     |

> **Day-2 以後怎麼用？** 日常操作模式、IDE 配置、Plan vs Agent 選用時機、典型情境劇本等實務指引，見 [DAILY-USAGE.md](DAILY-USAGE.md)。

---

## 8. 跨專案一致性策略

> 此章節適用於多專案生態圈或需要跨 Repo 對齊規範的情境。初期單一專案導入可跳過。

當生態圈有多個關聯專案時，AI 切換專案的認知成本是最大的效能瓶頸。

### 8.1 共識段落

每個專案的 `docs/README.md` 都包含一個「跨子系統共識」段落：

```markdown
## 跨子系統共識

| 專案        | 文件庫路徑                       |
| ----------- | -------------------------------- |
| my-backend  | ../../my-backend/docs/README.md  |
| my-frontend | ../../my-frontend/docs/README.md |
```

### 8.2 一致化檢查清單

跨專案必須語意統一的項目：

- [ ] 導航表的 ADR 列描述用詞完全相同
- [ ] SPEC 的 Source of Truth 定義完全相同
- [ ] ADR 觸發條件描述完全相同
- [ ] 命名正規式完全相同

### 8.3 代理平台一致性檢查

跨平台落地時，建議至少用兩種代理執行同一個小任務（例如「新增一支 API 並補 SPEC」），對照下列項目：

- 是否讀到相同的核心規範（架構約束、SoT、ADR 觸發條件）
- 是否執行相同的驗證流程（build/test/lint）
- 是否在 PR 階段主動提示文件同步

若其中一個平台反覆漏掉同一規則，優先調整該規則在 `AGENTS.md` 的可見度與描述清晰度。

---

## 9. 業界佐證與參考資料

本指南的方法論並非獨創，而是綜合了以下業界實踐與研究：

### 9.0 證據等級說明

為避免過度推論，本文引用依證據強度分三級：

| 等級                   | 定義                   | 用途                     |
| ---------------------- | ---------------------- | ------------------------ |
| **A：官方文件**        | 產品/平台官方技術文件  | 建立「可直接操作」的規則 |
| **B：方法論/實踐社群** | ADR 組織、工程實踐網站 | 補足設計脈絡與模板選型   |
| **C：經驗觀察**        | 團隊導入案例與實務觀察 | 提供落地策略與反模式     |

### 9.1 AGENTS.md — AI Agent 的專案入口慣例

OpenAI 在 Codex 說明中明確提到代理可透過 `AGENTS.md` 取得專案慣例與執行方式。此作法目前已被多種工具與團隊工作流採用，屬於高可實作性的工程慣例。

> *"Codex reads the AGENTS.md file at the root of each repository to understand project conventions, build commands, and code style preferences."*
> — [OpenAI Codex Documentation](https://openai.com/index/introducing-codex/) (2025)

**相關實踐（A 級）**：
- **GitHub Copilot Instructions / AGENTS.md** — [GitHub Docs: Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot)
- **Cursor Docs** — [Cursor Docs](https://cursor.com/docs)
- **OpenAI Prompt & Agent Docs** — [OpenAI Prompt Engineering](https://developers.openai.com/api/docs/guides/prompt-engineering)

### 9.2 ADR — 架構決策記錄

Architecture Decision Records 由 Michael Nygard 在 2011 年提出，已成為軟體架構治理的業界標準。

> *"An architecture decision record is a short text file describing a single architecture decision."*
> — Michael Nygard, [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (2011)

**延伸資源（B 級）**：
- [ADR GitHub Organization](https://adr.github.io/)
- [Thoughtworks Tech Radar](https://www.thoughtworks.com/radar/techniques/lightweight-architecture-decision-records) — 列為 **Adopt** 等級

### 9.3 結構化 Markdown 是 LLM 最高效的輸入格式

**相關實踐（A 級）**：
- **OpenAI Prompt Engineering** — [OpenAI Docs](https://developers.openai.com/api/docs/guides/prompt-engineering)
- **Google Gemini Prompting Strategies** — [Google AI Docs](https://ai.google.dev/gemini-api/docs/prompting-strategies)
- **Anthropic Prompt Engineering** — 建議以官方最新頁為準

### 9.4 Source of Truth 與文件防漂移

- [OpenSpec](https://github.com/Fission-AI/OpenSpec) — AI-native 的規格管理工具
- [API-First Development](https://swagger.io/resources/articles/adopting-an-api-first-approach/) — Swagger/OpenAPI 方法論

### 9.5 Context Window 最佳化

> *"The key insight is treating context as a scarce resource — every token spent on irrelevant information is a token not available for the actual task."*
> — Simon Willison, [Prompt Engineering Lessons](https://simonwillison.net/tags/prompt-engineering/)

### 9.6 使用建議

- 本指南屬於「工程實務框架」，不是形式化學術證明。
- 任何規則都應透過你的專案 KPI 與回顧機制持續調整。
- 當工具平台更新（模型、IDE、代理能力）時，建議季度檢視一次引用連結與建議內容。

---

## 附錄：導入時常見的典型問題

| #   | 問題                 | 症狀                                | 解法                                   |
| --- | -------------------- | ----------------------------------- | -------------------------------------- |
| 1   | **版本精度不一致**   | A 專案寫 `10.0.5`、B 專案寫 `10.x`  | 統一為 Major.Minor，Patch 級交由設定檔 |
| 2   | **文件數量漂移**     | 文件寫「43 個元件」，實際只有 42 個 | 移除所有精確計數，改用結構性描述       |
| 3   | **導航表語意重疊**   | 兩列描述相似但指向不同文件          | 為每列使用明確區隔的自然語言意圖       |
| 4   | **重複版本宣告**     | 版本號在技術棧和規範段各寫一次      | 第二處改為「見技術棧宣告」引用         |
| 5   | **書寫體系混用**     | 正文繁體，某段落混入簡體            | 全文統一為單一書寫體系                 |
| 6   | **未來規劃佔比過高** | 尚未啟用的規劃佔 30% 篇幅           | 壓縮為觸發條件 + 治理骨架（約 10 行）  |

---

*本指南隨 ZeroSpec v0.1 發布。歡迎依據自身專案需求調整使用。*
