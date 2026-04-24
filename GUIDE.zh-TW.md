# ZeroSpec 實踐指南

> **🌐 [English](GUIDE.md)**

> **Zero-dependency Markdown baseline for AI-readable repositories.**
> 幫 AI Coding Agent 在開始改檔前，先把專案上下文交接清楚：知道檔案在哪裡、哪些規則不能踩、哪份文件才是真相來源。

**版本**：v0.4 — 2026-04-24
**適用對象**：想讓 GenAI Agent（GitHub Copilot / Codex / Claude / Gemini / Cursor）高效理解專案的工程團隊
**驗證背景**：已於含後端（.NET（C#）/ Python）、前端（React + TypeScript）與共用 Library 的多專案生態圈中實際驗證

---

## 誰適合先讀這份指南？

- 若你負責維護 `AGENTS.md`、整理團隊規範，或評估 ZeroSpec 如何融入既有流程，這份指南適合先讀。
- 如果你剛接觸 ZeroSpec，建議先讀 [README.zh-TW.md](README.zh-TW.md)，再回來看這份較完整的方法與治理說明。
- 若你主要想看日常怎麼用，建議先讀 [DAILY-USAGE.zh-TW.md](DAILY-USAGE.zh-TW.md)。

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

你可以把它想成 AI Agent 開工前的技術交接單：不是流程引擎，而是先把必要上下文交接清楚。

### Layer 0 vs Layer 1

| 層級        | 職責                                                           | 代表工具           |
| ----------- | -------------------------------------------------------------- | ------------------ |
| **Layer 0** | 讓專案「可被 AI 讀懂」— 架構約束、導航、Source of Truth        | **ZeroSpec**       |
| **Layer 1** | 讓 AI「照流程執行任務」— 工作流引擎、phase gate、change-folder | OpenSpec, Spec Kit |

ZeroSpec 不綁定任何 IDE、代理平台或程式語言。它只做一件事：**確保 AI 在開始任何任務前，已擁有精準的專案脈絡。**

如果用 SDD 的開發模式來看，ZeroSpec 是一個輕量的 Layer 0 基線：API 變更觸發 SPEC 更新，架構決策觸發 ADR，需要系統快照時觸發 SA。

### ZeroSpec 和 SDD 的關係

- **有 SDD 的做法（SDD-like）**：ZeroSpec 用事件觸發維持 SPEC / ADR / SA 的持續更新。
- **不是完整流程 SDD**：ZeroSpec 不負責 phase gate、簽核流程與執行狀態轉換。
- **一句話記法**：ZeroSpec 是 **SDD-ready 的 Layer 0 基線**；需要嚴格流程編排時，再銜接 Layer 1 工具。

#### 與 Layer 1 工具的長期整合路徑

ZeroSpec 可以獨立運作，也可以隨團隊成熟度逐步銜接 Layer 1 工具。以下是市場主流 SDD 實務（API-First、Contract-First、phase gate）推導出的自然演進路徑，供長期評估參考：

| 階段                      | 時程參考   | 做法                                                                                               | Layer 1 工具        |
| ------------------------- | ---------- | -------------------------------------------------------------------------------------------------- | ------------------- |
| **Stage 1：建立習慣**     | Month 1–3  | AGENTS.md + 事件觸發 SPEC 更新（PR 時人工確認）；目標是讓 Agent 產出品質穩定                       | 不需要              |
| **Stage 2：加入 CI 閘門** | Month 3–6  | PR template 加 SPEC Checklist；簡單 CI script 偵測 Controller 變更但 `docs/spec/` 無異動時發出警告 | 不需要              |
| **Stage 3：Layer 1 整合** | 6 個月以上 | ZeroSpec SPEC 作為 Layer 1 工具的輸入基礎；Layer 1 在其之上疊加執行階段與核准閘門                  | OpenSpec / Spec Kit |

**Stage 3 的觸發信號**：需要跨團隊 spec 核准流程、強制 phase gate、或 AI 生成管線需要自動化驗收條件。多數中小型團隊在 Stage 2 就已足夠。

**兩層文件的職責分工不重疊**：ZeroSpec SPEC（`docs/spec/SPEC-xxx.md`）= 介面契約與業務脈絡（給 Agent 讀）；Layer 1 spec = 執行流程規格（驅動 workflow engine）。導入 Stage 3 後，兩份文件並行存在，不需要合併。

### 內容產生三層分流模型

ZeroSpec 的核心創新是區分「誰來寫」，而非「要不要寫」：

| 類別                    | 誰負責               | 內容範例                                      | 人工投入     |
| ----------------------- | -------------------- | --------------------------------------------- | ------------ |
| **(A) AI 自動產生**     | AI 掃描 Repo 推導    | 技術棧、版本 SoT、目錄結構、Build 指令、Alias | 零           |
| **(B) AI 草擬、人審核** | AI 歸納模式 + 人確認 | 領域/模組對照表、架構層級、命名慣例、文件導航 | 審核 5 分鐘  |
| **(C) 人必須提供**      | 無法從程式碼推導     | 專案定位、架構硬規則、部署策略、權限格式      | 回答幾個問題 |

人真正要「手動寫」的只有 C 類（約 5–8 條團隊決策），其餘由 AI 產生或草擬後審核。

### 何時不該用 ZeroSpec

「不導入」也是一種決定。以下情境導入成本超過收益，請直接跳過：

| 不適合的情境                                         | 原因                                                                                    | 替代做法                                            |
| ---------------------------------------------------- | --------------------------------------------------------------------------------------- | --------------------------------------------------- |
| 一次性腳本 / POC / Demo Repo                         | 無長期維護，AGENTS.md 的維護成本超過 Agent 產出品質改善的收益                           | README 摘要 + inline comment 足夠                   |
| 純研究性 / 筆記型 Repo（Notebook 皮書）              | 無明確的「架構硬規則」可寫；C 類欄位會大部分折彎                                        | README + 各 notebook 開頭摘要                       |
| 架構本身正在大幅重構的探索階段                       | Agent 遵守了過時的規則反而有害；AGENTS.md 的長期價值建在「規則穩定」上                  | 先穩定架構再跑 INIT-SCAN；探索期靠 PR review 把關   |
| 已導入 Layer 1 SDD 且 Agent 讀取已有替代方案         | ZeroSpec 核心價值是「Agent 自動讀專案指引檔」；若已有其他機制解決，重複導入增加維護負擔 | 評估 Layer 1 工具是否已提供相容的 context injection |
| 單人短期專案且 Agent 對特定語言 / 框架模型已足夠精準 | 產出品質的邊際改善小於建立文件的時間成本                                                | 值得持續觀察；若 Agent 開始犯錯再考慮導入           |

**一句話判斷**：若你無法寫出至少 3 條穩定的「寫錯會導致 PR 退件」硬規則，此時導入產出的 AGENTS.md 會是空殼，請先等架構成熟。

---

## 1. 為什麼需要 ZeroSpec

在正確配置下，現代 AI Coding Agent 通常會在處理任務前讀取專案根目錄的指引檔案（如 `AGENTS.md`、`.cursor/rules`），作為生成程式碼的約束條件。如果這些檔案結構混亂、資訊過時或缺乏關鍵規範，Agent 常見會出現下列情況：

- **搜尋效率差**：花較多 token 與時間在檔案系統中找 base package 或路徑別名
- **違反架構分層**：在 Controller 層寫業務邏輯、用錯狀態管理方案
- **引用錯誤資訊**：帶入已過時的版號或不存在的 API
- **注意力被稀釋**：把大量 context 花在人類導向的安裝教學與未來規劃

這些情況不是每次都會發生，但在真實專案裡已經夠常見，值得用結構化方式提前處理。

ZeroSpec 的目標是：**用盡量少的 token 傳遞盡量清楚的專案約束，幫助 Agent 更穩定地遵守團隊規範，而不是取代工程判斷。**

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

### 補充說明：模型選用建議

模型選擇會影響使用體驗，但它不是 ZeroSpec 是否成立的前提。若你同時在評估不同模型做不同任務，可把下面這份表格當成一般性參考；較偏日常操作的建議，可放到 [DAILY-USAGE.md](DAILY-USAGE.md) 理解。

不同任務情境適合不同模型系列。以下為一般性建議，只列系列名、不綁版號，依個人方案與額度自行選擇：

| 任務情境                             | 推薦模型系列                     | 選用理由                                     |
| ------------------------------------ | -------------------------------- | -------------------------------------------- |
| 日常編碼（CRUD、重構、bug fix）      | Claude Sonnet / GPT / Gemini Pro | 速度與品質平衡，token 成本可控               |
| 架構分析、系統掃描（INIT-SCAN / SA） | Claude Opus / o-series           | 長 context window 搭配深度推理，適合全局分析 |
| 大量程式碼生成（INIT-BUILD / SPEC）  | Claude Sonnet / GPT-Codex        | 程式碼產出導向，支援 Repo 讀寫與跨檔一致重構 |
| 快速查詢、輕量任務                   | Gemini Flash                     | 低延遲快速回應，適合簡單問答或格式轉換       |

**模型切換策略**：先用快速模型（如 Gemini Flash、Claude Sonnet）做初步探索或小範圍修改；當遇到以下情境時，切換到高推理或高生成模型：

- **需求歧義高**：問題跨多模組、缺乏明確邊界 → 切換 Claude Opus / o-series 做深度分析
- **跨多檔一致重構**：需要穩定 diff 導向產出 → 切換 GPT-Codex
- **補測試與修 CI**：需要大量程式碼生成且維持既有風格 → 切換 Claude Sonnet / GPT-Codex

> 模型能力持續演進，上述建議僅供參考方向。實務上以「context window 是否足夠」與「是否支援 Repo 讀寫」作為最低門檻即可。

---

## 3. AGENTS.md 設計原則

### 3.1 必備段落與產生分類

| 段落                              | 用途                            | 產生類別    | 設計要點                                 |
| --------------------------------- | ------------------------------- | ----------- | ---------------------------------------- |
| **專案定位**                      | 一句話說明專案                  | C — 人提供  | 包含技術棧、架構模式、部署方式           |
| **定錨資訊**                      | Base Package / Alias / 版本真相 | A — AI 自動 | 消除 AI 盲搜，強制溯源設定檔             |
| **關鍵約束（Quick Constraints）** | 最致命硬規則的置頂摘要          | C — 人提供  | 從規範中萃取，長對話稀釋時仍留在文件前段 |
| **領域/模組對照表**               | 業務 ↔ 程式碼映射               | B — AI 草擬 | 讓 AI 快速定位該改哪個模組               |
| **程式碼產生規範**                | 架構層級、命名、禁止事項        | C — 人提供  | 用明確的 Do / Don't 格式                 |
| **文件導航表**                    | 按「想做什麼」分類              | B — AI 草擬 | 用 Markdown 表格，AI 解析效率最高        |
| **常用指令**                      | build / test / serve            | A — AI 自動 | 簡潔的表格即可                           |
| **關聯專案**                      | 跨 repo 導航                    | B — AI 草擬 | 附上相對路徑與簡要關係說明               |
| **文件維護提醒**                  | PR 觸發條件                     | C — 人提供  | 使 AI 在修改程式碼後主動同步文件         |

> 段落排序依「違反時影響程度」降序排列，詳見 §3.5。

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

#### 語意搜尋時代的導航表定位調整

當 Agent 已具備全文索引 / 語意搜尋能力（GitHub Copilot `#codebase`、Cursor indexing、Claude Code 原生檔案搜尋），「找到檔案」本身不再是導航表的核心價值，價值重心應轉移到：

- **業務意圖 ↔ 程式碼的穩定映射**：幫 Agent 確認「Warehouse 是指 ERP 庫存還是實體倉庫」這類語意歧義，搜尋索引無法提供
- **跨模組衍生關係**：對照表能顯示「商品管理」同時涉及 `WarehouseProductController` + `StoreProductController` + `ImportTemplateController`，這是語意搜尋很難聯想的
- **模組「不存在的選項」**：語意搜尋只能代表已寫的程式碼；導航表可註記「此業務無對應 Controller」，對 Agent 相當有用

**實務建議**：若 Agent 平台有語意搜尋，可適度精簡對照表的筆數（最重要 8–12 條業務領域即可），把節下來的篇幅投資在 Quick Constraints 和「Don't」反例上——這些是搜尋索引永遠無法替代的限制性知識。若 Agent 無語意搜尋，則維持傳統「完整對照表 + 對每個 Controller 異動對齊」的寬度。

### 3.4 指令過載防護（Guardrails）

`AGENTS.md` 不是 onboarding 手冊。過長或過細的內容會讓 AI 失焦，反而降低準確度。

**為什麼長度會反噬準確度**：AGENTS.md 越長，核心規則越容易被噪音埋沒，AI 會忽略部分內容；若你發現 AI 反覆違反某條明明已寫在 AGENTS.md 的規則，第一個懷疑對象應是「這份檔案太長或太雜」，而不是再加一條規則進去。

建議控制原則：

- **建議長度**：以精簡為主；150–300 行約等於 2,000–4,000 tokens，在主流 LLM system prompt 配額（通常為 4K–16K tokens）中留有充足空間。超出此範圍會擠壓任務 context，降低回應品質。主線明顕偏長時應拆分至 docs/ 子文件，並透過導航表格參照
- **必備欄位**：專案定位、定錨資訊、導航表、產生規範、驗證指令、文件同步條件
- **可移除欄位**：長篇背景故事、新手安裝教學、尚未採用的未來藍圖細節

#### 該寫 vs 不該寫（對照表）

| 該寫（AI 無法自行推導）             | 不該寫（AI 已知或能推導）            |
| ----------------------------------- | ------------------------------------ |
| 與預設不同的程式碼風格規則          | 語言通用慣例（AI 已知）              |
| 建置 / 測試 / lint 指令             | 詳細 API 文件（改用連結）            |
| 架構硬規則與分層邊界                | 檔案逐一說明的清單                   |
| 團隊專屬路徑、環境變數、特殊 gotcha | 「寫乾淨程式碼」這類正確但無效的原則 |
| PR / branch 命名慣例                | 經常變動的資訊（版本號、人名）       |
| 開發者環境需求（env、secrets）      | 長篇教學或背景故事                   |

#### 每行自檢法則

逐行審視 AGENTS.md，問一個問題：

> **「移除這一行會讓 AI 在下一個任務犯錯嗎？」** 若不會，這行就應刪除，或移到 `docs/` 子文件讓 AI 按需讀取。

這個法則來自 Anthropic 對 CLAUDE.md 的官方建議。把 AGENTS.md 當成程式碼來維護：定期檢查、精簡，並用 Agent 的實際回應驗證改動是否有效。

#### 強調語法的節制使用

當某條規則反覆被 AI 忽略時，可在該條規則前加入 `IMPORTANT:` 或 `YOU MUST` 等強調語以提升遵從性。但這是**最後手段**，不應預設全部加上；一旦每條規則都有強調語，等於沒有強調語。

#### HTML 註解作為人類備忘

若某段內容只給維護者看，又不想吃掉 AI context token，建議用 block-level HTML 註解包起來：

```markdown
<!--
維護者備忘：此段商品命名慣例是 2024-Q3 跨團隊會議決議，改動前請先問 @tech-lead。
-->
```

部分 AI 平台（例如 Claude Code）會在讀入 context 前自動剝除 HTML 註解；其他平台雖未保證剝除，但此寫法可明確告訴讀者「這是人類維護線索，非 AI 指令」。

### 3.5 段落排序與注意力權重

AI 模型對文件開頭的注意力權重最高，隨位置遞減。在長對話中，對話歷史與工具輸出會逐步稀釋指引檔案的影響力，此時文件前段的內容存活率最高。

因此 AGENTS.md 的段落應按「違反時影響程度」降序排列：

| 優先級 | 段落                          | 排序理由                                       |
| ------ | ----------------------------- | ---------------------------------------------- |
| 1      | 專案定位 + 定錨資訊           | 決定 AI 理解專案的基礎框架                     |
| 2      | 關鍵約束（Quick Constraints） | 違反時直接導致 PR 退件的硬規則，集中最關鍵幾條 |
| 3      | 領域/模組對照表               | 決定 AI 改對檔案的核心導航                     |
| 4      | 程式碼產生規範（詳細版）      | 細部規範，Quick Constraints 已涵蓋最關鍵項     |
| 5      | 文件導航表                    | 按需參考，非每次任務必要                       |
| 6      | 常用指令                      | AI 通常能自行推導                              |
| 7      | 關聯專案                      | 僅跨專案任務需要                               |
| 8      | 文件維護提醒                  | PR 階段才需要                                  |

**Quick Constraints 設計要點**：從「程式碼產生規範」中提取最致命的幾條硬規則（違反時會導致 PR 退件或系統錯誤），集中放在「專案定位」之後。即使後段被對話歷史稀釋，核心約束仍留在文件前段。

**責任定義**：Quick Constraints 的決策來源屬於 C3（人決策），其文字表達是由「程式碼產生規範」萃取的置頂投影；僅可在使用者確認後同步重建。

**範例**：

```markdown
## 關鍵約束（Quick Constraints）

以下規則在任何情況下都必須遵守：

1. Controller 只處理 HTTP 請求/回應，不含業務邏輯
2. `@Transactional` 只加在 Service 層
3. 新 Schema 變更用 Flyway，絕對不修改已存在的 migration
4. 使用 MapStruct 轉換，不手寫 Mapper 實作
5. Web API 路徑：`/api/v1/{resource}`
```

> 這些規則在「程式碼產生規範」段落會有更詳細的說明，Quick Constraints 只是置頂摘要。

**強調語法使用注意**：Quick Constraints 本身已由專案定位段落置頂，語意上就是「最重要的 5–8 條規則」。**不建議**在每條前都加 `IMPORTANT:` 或 `YOU MUST`；一旦每條都有強調語，等於沒有強調。僅在某條規則已經經過 Context Hygiene、每行自檢、解歧義等手段後仍被 AI 反覆違反，才在該單條規則前加強調語（詳見 [DAILY-USAGE §5.6](DAILY-USAGE.zh-TW.md#56-ai-反覆違反同一條-agentsmd-規則) 診斷流程）。

### 3.6 Nested AGENTS.md（Monorepo / 大型專案）

大型 monorepo 或多 package 專案可在子目錄內額外放置 AGENTS.md，形成層級導航。

#### Compaction 生存策略

長對話中，Context 將超載時各 Agent 平台會觸發摘要 / 壓縮（Claude Code 的 `/compact`、Copilot 的 summary insertion）。根據 Claude Code 官方文件：

- **Root 層 CLAUDE.md 在 compaction 後會被自動 re-inject**；其他 Agent 雖無明確保證但行為類似
- **子目錄 nested AGENTS.md 不會自動 re-inject**，只在 Agent 再次讀取該目錄檔案時重新載入

對應的結構建議：

| 存放位置 | 適合的內容                                                                         | Compaction 存活率          |
| -------- | ---------------------------------------------------------------------------------- | -------------------------- |
| Root     | Quick Constraints、專案定位、定錨資訊、SPEC 觸發條件等「什麼任務都需要」的核心規則 | 高（核心硬規則留在骨幹）   |
| Sub      | 該子 package 的專屬細節：DTO 命名、routing 慣例、特殊 build 指令                   | 低（但已寫回磁碟，可重讀） |

實務原則：**「死了也要記得的規則」放 Root，「深入該模組再想起來也行的細節」放 Sub**。不要把業務硬規則埋在某個子目錄的 AGENTS.md，否則長對話中一旦 Agent 離開該目錄就會漏掉。

- **行為**：AGENTS.md 官方標準規定——代理會讀取**目前編輯檔最接近的 AGENTS.md**，層次最深者優先，其他層級為取代背景
- **何時需要**：Nx / Turborepo / Lerna monorepo；多對外端點的 Web + Mobile 雙通道；子 package 有獨立架構規範
- **設計原則**：
  - Root AGENTS.md 只放全專案通用規範（技術棧、版本真相來源、CI 入口）
  - 子 AGENTS.md 放該模組特有規範（routing 慣例、DTO 命名、特殊建置指令）
  - 子 AGENTS.md 不重複 Root 內容，但可鏈點導回 `../AGENTS.md`
- **參考**：[AGENTS.md 官方標準](https://agents.md/) 與 OpenAI 主 repo（88 個 AGENTS.md）、Apache Airflow、Temporal Java SDK 等大型專案

> ZeroSpec 的 Prompt Pack 目前以單一 AGENTS.md 為基準偵測；若採用 nested 配置，請在貼 Prompt 前找好目標 package，並察看 Agent 是否正確讀到最接近的 AGENTS.md。

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

> SPEC 通常作為開發與 GenAI 的主要參照檔案。當介面或行為有明確變更時，建議同步更新 SPEC，並在 Changelog 追蹤變更歷程。

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
2. Agent 詢問 C 類問題（專案定位、架構硬規則、部署策略），你回答幾個問題
3. Agent 產出 `AGENTS.md` + `docs/README.md`
4. 審核 B 類草稿（領域/模組對照表、命名慣例），調整後存檔
5. AI 提供現況評估：掃描摘要、建議第一份 SPEC、建議最小文件集、下一步行動

### Step 3：驗證

1. 用產出的 `AGENTS.md` 跑一個真實小任務（例如新增一支 API）
2. 確認 Agent 遵守架構分層、使用正確的 Base Package、執行 build/test
3. 若有偏差，調整 `AGENTS.md` 中對應的硬規則描述

### Step 3.5：依專案類型選擇下一步

ZeroSpec 的 Day-1 體驗因專案類型不同而分叉：

#### 🌱 Greenfield（全新專案，API 數量少量或尚未建立）

Step 2 的 INIT-BUILD 完成後，**直接進入 Step 4 的事件驅動模式**。每新增或變更一支 API，就觸發一次 SPEC。你不需要補歷史文件，因為沒有歷史。

> 建議第一份 SPEC 跟第一個真正的 API endpoint 一起建立，而不是等到累積幾支後再補。

#### 🏗️ Brownfield（既有專案，已有中量/大量 API）

INIT-BUILD 完成後，你有兩條任務軌道並行：

| 軌道               | 工作內容                      | 優先原則                |
| ------------------ | ----------------------------- | ----------------------- |
| **開發軌**（每日） | 新增/變更的 API 正常觸發 SPEC | 所有新變更都要有 SPEC   |
| **補登軌**（漸進） | 既有 API 逐步補 SPEC          | 依優先序補，不強求 100% |

**補登優先序**（由高至低）：

1. 近期有程式碼異動的 API（最高頻率 = 最高風險 = 最需要 SPEC）
2. 跨系統 / 跨團隊依賴的 API（Consumer 已存在的介面）
3. 業務邏輯複雜的 API（驗證邏輯、計算規則、多步驟流程）
4. 長期未異動的 API — **可暫緩或跳過**（Dead Zone，補登投資報酬率低）

**As-Is 原則**：補 SPEC 的目標是讓 AI 理解**現在的程式碼行為**，不是記錄理想架構。若發現問題，先記在 TODO 欄，不要把 To-Be 混進 As-Is SPEC。

**SDD 最低門檻**（第一個月目標）：

- `AGENTS.md` + `docs/README.md` ✅（Day-1 已完成）
- 至少一份高優先 API 的 SPEC ✅
- 所有新變更都有對應 SPEC ✅（開發軌正常運作）

> 正規化不完整：並非所有 API 最終都需要 SPEC。Dead Zone 的 API 若無人消費且不再異動，可接受永遠沒有 SPEC。文件存在的前提是有消費者。

**Brownfield 建議的第一步順序**：

1. 先跑一次 **SA Prompt** → 產出系統架構快照（讓 AI 有完整全局理解）
2. 再根據優先序補第一份 **SPEC**（以最近變動最頻繁的 API 開始）
3. 之後進入開發軌，新變更正常觸發 SPEC

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

以下指標比較適合拿來當方向性目標，前提是專案架構已相對穩定，且團隊對規範有基本共識。它們不是保證值，而是回顧與調整時的參考。

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

跨專案建議保持語意一致的項目：

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
- [Spec Kit](https://github.com/github/spec-kit) — Spec-Driven Development CLI
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

*本指南隨 ZeroSpec 發布，歡迎依據自身專案需求調整使用。*
