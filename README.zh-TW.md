# ZeroSpec

> **🌐 [English](README.md)**

> **在 AI Coding Agent 動手前，先把它需要的專案上下文整理好：架構規則、模組導航、版本真相來源。零依賴，純 Markdown。**

**版本**：v0.5.2
**狀態**：Active

---

## ZeroSpec 在解決什麼問題？

用 Copilot、Cursor、Claude Code 或類似工具在真實 Repo 上交付功能，這些情況你應該不陌生：

- 導覽文件漂移，Agent 改錯模組
- 改到正確的檔案，但悄悄違反了分散在多份文件裡的架構規則
- 回覆引用了已棄用的 API、舊版本，或不再是真相來源的介面
- 每個工具各自需要一套指引，時間久了開始分歧

這些多數不是單一模型能力問題，而是上下文缺口——Agent 需要的專案知識，沒有被放在它能穩定找到的位置。

ZeroSpec 在 Agent 開始動手前，把這些上下文放到一組可預測的檔案位置。純 Markdown，無新執行環境，不綁定平台。

## 為什麼這件事值得處理？

這些問題不是少數情況。

- [Stack Overflow Developer Survey 2025](https://survey.stackoverflow.co/2025/ai/) 顯示，66% 的受訪者認為常見困擾是答案「幾乎對，但不完全對」，45.2% 認為除錯 AI 產生的程式碼更花時間。
- METR 在 2025 年的[隨機對照研究](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)中，觀察到資深開源開發者在特定情境下使用 AI 工具時，完成任務反而慢了 19%。
- [AGENTS.md](https://agents.md/) 已成為 AI 輔助開發流程中常見的開放式指引檔慣例，代表整個生態正在往可預測的上下文檔案收斂，而不是依賴各工具各自的隱性魔法。

這些資料不代表每個團隊都一定需要 ZeroSpec，但至少說明了一件事：AI 協作的成敗，往往不只取決於模型本身，也取決於專案上下文是否整理得足夠清楚。

Simon Willison 在 [Hallucinations in code are the least dangerous form of LLM mistakes](https://simonwillison.net/2025/Mar/2/hallucinations-in-code/) 也提到，當模型不了解你的程式庫或專案脈絡時，補對上下文通常比一味換模型更有效。

Anthropic 的工程團隊把這件事系統化為「[Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)」——找到最小的一組高訊號 token，讓 Agent 每次進來都能拿到剛好夠用的地圖。ZeroSpec 是這個原則在 Repo 層級的一種實踐。

## ZeroSpec 的做法

ZeroSpec 把 Agent 在動手前通常需要的最小上下文固定下來：

你可以把它想成 AI Agent 開工前的技術交接單：它不是流程引擎，而是先把「檔案在哪裡」「哪些規則不能踩」講清楚。

- 專案定位與架構邊界
- 版本真相來源
- 領域到程式碼的導航
- 文件治理規則

它建立在開放的 [AGENTS.md](https://agents.md/) 格式上，不另外發明專屬格式，也不要求新的服務或執行環境。所有內容都維持在一般 Markdown，方便團隊用既有的 code review 流程維護。

如果用 SDD 的開發模式來看，ZeroSpec 是一個輕量的 Layer 0 基線：API 變更觸發 SPEC 更新，架構決策觸發 ADR，需要系統快照時觸發 SA。

## 何時適合導入 ZeroSpec

| 適合導入                                       | 建議跳過                                    |
| ---------------------------------------------- | ------------------------------------------- |
| 需要一套可長期維護的 Agent 指引基線            | Repo 為一次性用途（POC、教學、短期腳本）    |
| 希望零依賴且不綁定單一平台                     | Repo 以內容筆記為主，沒有長期維護程式碼需求 |
| 希望文件能跟著開發節奏演進，不是一次性產物     | 架構仍在探索期，尚無法定義穩定硬規則        |
| 需要 Layer 0 的上下文基線，再銜接 Layer 1 工具 | 團隊既有 Layer 1 已完整處理上下文注入       |

## Layer 0 定位

ZeroSpec 是 **Layer 0（Context Readiness）**，不是執行引擎：

| 層級        | 職責                                        | 代表工具           |
| ----------- | ------------------------------------------- | ------------------ |
| **Layer 0** | 讓專案「可被 AI 讀懂」— 架構約束、導航、SoT | **ZeroSpec**       |
| **Layer 1** | 讓 AI「照流程執行任務」— 工作流、phase gate | OpenSpec, Spec Kit |

ZeroSpec 產出的文件重點是任務前理解；Layer 1 工具的重點是任務流程執行。兩者解決的問題不同，可以並行使用。

### ZeroSpec 和 SDD 的關係

- **有 SDD 的做法（SDD-like）**：ZeroSpec 用事件觸發維持 SPEC / ADR / SA 的持續更新。
- **不是完整流程 SDD**：ZeroSpec 不負責 phase gate、簽核流程與執行狀態轉換。
- **一句話記法**：ZeroSpec 是 **SDD-ready 的 Layer 0 基線**；需要嚴格流程編排時，再銜接 Layer 1 工具。

### 適合先從輕量 SDD 開始

- 如果你想先試 SDD 輔助開發，但還不想 Day-1 就導入完整 workflow，ZeroSpec 很適合拿來起步。
- 它先補的是比較輕的基線：`AGENTS.md`、`docs/README.md`，以及由事件觸發的 SPEC / ADR / SA 更新。
- 之後如果團隊真的需要更嚴格的 phase gate、審核流程或 spec workflow，可以把 ZeroSpec 留在 Layer 0，再和 OpenSpec 或 Spec Kit 併行。

## 內容模型

ZeroSpec 會先分清楚哪些內容由 AI 產生、哪些內容必須由人確認。詳見 [GUIDE.zh-TW.md §0](GUIDE.zh-TW.md#0-什麼是-zerospec)。

| 類別                    | 誰負責           | 人工投入     |
| ----------------------- | ---------------- | ------------ |
| **(A) AI 自動產生**     | AI 掃描 Repo     | 零           |
| **(B) AI 草擬、人審核** | AI 歸納 + 人確認 | 審核 5 分鐘  |
| **(C) 人必須提供**      | 無法從程式碼推導 | 回答幾個問題 |

---

## 範例輸出

使用 Prompt Pack 後，AI 會為你的專案產生類似下面的導航文件：

````markdown
# AGENTS.md — my-backend AI Navigation Guide

## Project Summary
**Inventory Management API** — .NET 10 (C#) + ASP.NET Core + EF Core + PostgreSQL 16
Base Namespace: `MyApp.Api`, `MyApp.Service` (follow Solution structure as source of truth)
Version source of truth: package versions per `.csproj`; .NET SDK per `global.json`

## Quick Constraints
1. Controllers handle HTTP request/response only — no business logic
2. Controllers MUST NOT access DbContext directly
3. New API path format: `/api/v1/{resource}`

## Domain-to-Code Map
| Domain             | Controller          | Core Service      |
| ------------------ | ------------------- | ----------------- |
| Product Management | `ProductController` | `IProductService` |
| Authentication     | `AuthController`    | `IAuthService`    |

## Code Generation Rules
- Controllers handle HTTP request/response only; orchestration, validation, and transaction logic belong in Service (violations rejected in PR review)
- Controllers MUST NOT access DbContext directly; all data access goes through Repository/Service abstraction
- New API path format: `/api/v1/{resource}`; avoid verb-based paths and multi-version mixing

## Common Commands
| Command        | Description   |
| -------------- | ------------- |
| `dotnet build` | Build project |
| `dotnet test`  | Run tests     |
````

完整範例見 [`examples/`](examples/) 目錄，包含 .NET 雙 API、Java Library、Python Package、React Monorepo 與 Day-1 最小產出。

---

## 快速開始

### 開始前

**目標專案**
- [ ] 已 clone 至本機：`git clone <your-repo-url>`
- [ ] 以 IDE 或 CLI 在**目標專案根目錄**啟動

> ZeroSpec 獨立存放即可，**不需要加入你的目標 Repo**。
> Bootstrap 完成後，你的 Repo 只新增 `AGENTS.md` 和 `docs/README.md` 兩個檔案。

**AI Agent 外掛**（以下擇一，必須具備 Repo 讀寫能力）

| 工具                     | 啟用方式                                                                    |
| ------------------------ | --------------------------------------------------------------------------- |
| GitHub Copilot (VS Code) | 切換至 **Agent 模式**（確認 `#codebase` 可用）                              |
| Cursor                   | 使用 **Composer — Agent**（非 Chat 模式）                                   |
| Codex CLI                | 在專案根目錄啟動；根據 [agents.md](https://agents.md/) 慣例讀取 `AGENTS.md` |
| Generic CLI              | 在專案根目錄啟動，貼入 Prompt Pack 內容                                     |
| Claude Code              | 預設即具備讀寫能力                                                          |
| Windsurf                 | 使用 **Cascade 模式**                                                       |
| JetBrains AI Assistant   | 開啟 **Attach project files** 選項                                          |

> 不建議：無法完整存取本機 Repo 的環境（例如 ChatGPT / Claude.ai 網頁版）
>
> 若需要實際寫入檔案，請避免使用純 Plan 模式；`INIT-SCAN` 這類只做分析、不寫檔的步驟，則可視平台能力使用。

> GitHub Copilot 用戶：Copilot 不一定自動讀 `AGENTS.md`，需用 `@AGENTS.md` 引用或建立 `.github/copilot-instructions.md`，詳見 [DAILY-USAGE.zh-TW.md §2.2](DAILY-USAGE.zh-TW.md#22-githubcopilot-instructionsmd-與-agentsmd-的共存)。

> **非英文專案提示**：Prompt Pack 以英文撰寫，產出語言通常會依專案語境判斷。若產出語言不符合預期，請在第一句明確指定目標語系（例如：`請用 zh-TW 回覆`）。若你的 Repo 以英文為主、但希望產出台灣正體中文，請見 [DAILY-USAGE.zh-TW.md §5.8](DAILY-USAGE.zh-TW.md#58-指定產出語言例如-zh-tw)。

### 快速起步

1. 在目標專案啟動 AI Agent（IDE 的 Agent 模式或在根目錄啟動 CLI session），貼上 [`prompts/INIT-SCAN.md`](prompts/INIT-SCAN.md)。
2. 在同一對話貼上 [`prompts/INIT-BUILD.md`](prompts/INIT-BUILD.md)。
3. 審核產出的 `AGENTS.md` 與 `docs/README.md`，再用一個真實小任務驗證。

### 完整流程（30 分鐘內完成）

### Step 1：分析現況（INIT-SCAN）

1. 開啟 [`prompts/INIT-SCAN.md`](prompts/INIT-SCAN.md)，複製 Prompt
2. IDE 切換至**目標專案根目錄**，開啟 **Agent 模式**（CLI 工具則直接在根目錄啟動 CLI Agent）
3. 貼入 Prompt → AI 掃描 Repo → 產出結構化現況盤點（不寫檔）
4. 確認分析結果、回答 2–3 個待確認問題（約 5–10 分鐘）

### Step 2：建置文件（INIT-BUILD）

1. 開啟 [`prompts/INIT-BUILD.md`](prompts/INIT-BUILD.md)，複製 Prompt
2. 在同一對話中貼入 → AI 詢問幾個團隊決策問題（每題附預設建議）
3. 回答或確認後，AI 產出 `AGENTS.md` + `docs/README.md`
4. 審核 AI 草擬的領域對照表與命名慣例 → 確認寫入
5. AI 額外提供**現況評估與建議**（掃描摘要 + 建議第一份 SPEC + 下一步行動）

### Step 3：驗證

以新的 `AGENTS.md` 跑一個真實小任務（例如新增一支 API），確認 Agent 使用正確的 Namespace / Package 並遵守架構約束。

> **若你的專案已有大量既有 API（Brownfield）**，建議在進入 Step 4 前先跑 **SA Prompt** 產出系統架構快照，再以「最近有異動」的 API 優先補第一份 SPEC。
> 新/既有 API 並行的補登策略（含 Step 3.5 的補登優先序與 As-Is 原則）詳見 [GUIDE.zh-TW.md §7](GUIDE.zh-TW.md#7-導入與持續運作流程)。

### Step 4：建立第一份 SPEC

根據 AI 在 Step 2 的建議，開啟 [`prompts/SPEC.md`](prompts/SPEC.md) 建立第一份 SPEC。
這是從「一次性產出」進入「**持續運作 SDD 機制**」的關鍵銜接。

### 導入後怎麼用？

| 觸發事件                                   | 使用 Prompt Pack / 方式                                                                                                                                                     |
| ------------------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 新增/變更 API                              | [`prompts/SPEC.md`](prompts/SPEC.md)                                                                                                                                        |
| 架構決策                                   | [`prompts/ADR.md`](prompts/ADR.md)                                                                                                                                          |
| 系統快照                                   | [`prompts/SA.md`](prompts/SA.md)                                                                                                                                            |
| 多模組開發任務（3+ Controller/handler 檔案或 2+ SPEC） | [`prompts/IMPL.md`](prompts/IMPL.md)                                                                                                                                        |
| 專案演進需同步文件                         | [`prompts/UPDATE.md`](prompts/UPDATE.md)                                                                                                                                    |
| 驗證既有 SPEC 是否仍跟程式碼一致           | [`prompts/DRIFT.md`](prompts/DRIFT.md)                                                                                                                                      |
| 需要平台 pointer 設定（可選）              | 複製 [`templates/pointers/`](templates/pointers/) 中引用/連結 `AGENTS.md` 的進入點檔案；Codex CLI、JetBrains、generic CLI 通常直接使用 `AGENTS.md`                         |
| 想使用 VS Code Prompt 捷徑（可選）         | 將 [`templates/prompts/*.prompt.md`](templates/prompts/) 複製到專案的 `.github/prompts/`；確認 `#file:prompts/` 可解析。見 [DAILY-USAGE.zh-TW.md](DAILY-USAGE.zh-TW.md) |
| 想以意圖觸發 Prompt Pack 路由（可選 Agent-Skill） | **專案內**：VS Code Copilot 使用 `.agents/skills/zerospec/`。**個人全域**：Claude Code 透過 `sync-skills` 輔助腳本安裝到 `~/.claude/skills/`；Codex CLI 在支援 user skills 時手動複製到 `$HOME/.agents/skills/`。詳見 [`skills/README.md`](skills/README.md)。 |
| 未觸發以上事件                             | **不建立任何文件**                                                                                                                                                          |

> **可選 adapter 一覽** — ZeroSpec 的標準入口永遠是 `prompts/*.md`（複製貼上即可用）。Adapter 只減少手動步驟，不取代標準 Prompt：
>
> | Adapter           | 功能                                               | 安裝位置                           |
> | ----------------- | -------------------------------------------------- | ---------------------------------- |
> | **Prompt Files**  | VS Code Prompt 介面的 `prompts/*.md` 快捷入口      | `.github/prompts/` + 可解析的 `prompts/` |
> | **Agent-Skill**   | 依意圖路由到正確 Prompt Pack                       | 專案內或個人 skill 資料夾          |
> | **Pointers**      | 引用/連結 `AGENTS.md` 的平台進入點檔案             | Repo 根目錄                        |
>
> 三者皆為可選。詳見 [DAILY-USAGE.zh-TW §2.2](DAILY-USAGE.zh-TW.md#22-githubcopilot-instructionsmd-與-agentsmd-的共存)。

建議每月做一次快速回顧、每季做一次完整回顧，詳細做法見 [GUIDE.zh-TW.md §7](GUIDE.zh-TW.md#7-導入與持續運作流程)。

如果你需要模型選擇建議、多語系工作方式或長期日常操作範例，建議放到 [DAILY-USAGE.zh-TW.md](DAILY-USAGE.zh-TW.md) 這類較長的使用指南，而不是塞在 README 首頁。

### 驗收方式

ZeroSpec 內建跨平台驗收腳本。

這些腳本用來驗證 ZeroSpec repo 本身，不會驗證你在目標專案產出的 `AGENTS.md` 或 `docs/README.md`。

檢查項目包含：

- 核心 Prompt 檔案是否完整（INIT-SCAN / INIT-BUILD / UPDATE）
- SPEC/ADR/SA 是否包含前置條件
- 重要模板與 Day-1 範例是否可用

執行方式：

- macOS / Linux：`bash scripts/verify-zerospec.sh`
- Windows（PowerShell）：`pwsh -File scripts/verify-zerospec.ps1`

腳本會輸出 PASS / FAIL 摘要；若有任何失敗，會回傳非 0 結束碼，適合手動驗收或 CI 使用。

最小 CI 範本（GitHub Actions）已提供於：`.github/workflows/verify-zerospec.yml`

- 觸發條件：`pull_request`、`push`（`main`）
- 驗證內容：僅執行 `bash scripts/verify-zerospec.sh`

---

## Repo 結構

```
zerospec/
├── .github/
│   ├── ISSUE_TEMPLATE/           ← Issue template 與 chooser 設定
│   ├── pull_request_template.md  ← PR 描述範本
│   └── workflows/
│       └── verify-zerospec.yml   ← PR / push 自動驗收（最小 CI）
├── AGENTS.md                    ← AI 導航指引（給在 ZeroSpec 本身工作的貢獻者）
├── CONTRIBUTING.md              ← 貢獻指南
├── CODE_OF_CONDUCT.md           ← 社群互動與行為期待
├── SECURITY.md                  ← 私下回報漏洞的安全性政策
├── SUPPORT.md                   ← 該去哪裡提問、回報問題與提出建議
├── README.md                    ← 你正在讀的這份
├── GUIDE.md                     ← 完整方法論（設計原則、防漂移、持續運作、業界佐證）
├── DAILY-USAGE.md               ← 長期使用者指南（Day-2+ 日常操作、IDE 配置、情境劇本）
├── prompts/
│   ├── INIT-SCAN.md             ← Bootstrap 第一步：分析現況（不寫檔）
│   ├── INIT-BUILD.md            ← Bootstrap 第二步：產生 AGENTS.md + docs/README.md
│   ├── SPEC.md                  ← 觸發：API 變更 → 產 SPEC
│   ├── ADR.md                   ← 觸發：架構決策 → 產 ADR
│   ├── SA.md                    ← 觸發：系統快照 → 產 SA
│   ├── AUDIT.md                 ← 觸發：稽核 AGENTS.md 品質（不寫檔）
│   ├── DRIFT.md                 ← 觸發：驗證既有 SPEC 是否仍跟程式碼一致（不寫檔）
│   ├── IMPL.md                  ← 觸發：複雜多模組開發 → 實作並同步 SPEC
│   └── UPDATE.md                ← 持續：更新 AGENTS.md + docs/README.md
├── templates/
│   ├── ADR-TEMPLATE.md          ← 直接可用的 ADR 模板
│   ├── SPEC-TEMPLATE.md         ← 直接可用的 SPEC 模板
│   ├── SA-TEMPLATE.md           ← 直接可用的 SA 模板
│   ├── DOCS-README-TEMPLATE.md  ← docs/README.md 文件治理模板
│   ├── SPEC-INDEX-TEMPLATE.md   ← docs/spec/README.md 子索引模板（門檻觸發）
│   ├── prompts/                 ← 可選：VS Code Prompt Files adapters（可複製到 .github/prompts/）
│   │   └── *.prompt.md          ← 只引用 prompts/*.md 的輕量 adapter
│   └── pointers/                ← 可選：引用或連結 AGENTS.md 的平台進入點模板
├── skills/
│   ├── README.md                ← Adapter 資產指南（路徑選擇、安裝/複製指令、驗證清單）
│   └── zerospec/
│       ├── SKILL.md             ← Skill-style Router（已用 Claude Code 驗證）
│       └── prompts/             ← Prompt 子檔（由 sync-skills.sh / sync-skills.ps1 從 prompts/ 同步）
├── scripts/
│   ├── verify-zerospec.sh       ← macOS/Linux 驗收腳本
│   ├── verify-zerospec.ps1      ← Windows PowerShell 驗收腳本
│   ├── sync-skills.sh           ← macOS/Linux：同步 prompts/ → skills/、安裝至 Claude 全域、或檢查漂移（CI 門檻）
│   └── sync-skills.ps1          ← Windows PowerShell：同步 prompts/ → skills/、安裝至 Claude 全域、或檢查漂移（CI 門檻）
├── examples/
│   ├── minimal-day1/            ← Day-1 最小產出範例（起步長這樣）
│   ├── dotnet-dual-api/         ← .NET 雙 API Host 範例
│   ├── java-library/            ← Java Library 範例
│   ├── python-package/          ← Python Package 範例
│   └── react-nx-monorepo/       ← React + Nx Monorepo 前端範例
├── anti-patterns.md             ← 反模式清單
├── CHANGELOG.md
└── LICENSE
```

---

## 建議採用指標

這些是實務觀察目標，不是保證或 SLA。請依實際導入期間、repo 規模與團隊流程調整。

| 指標                                 | 目標      |
| ------------------------------------ | --------- |
| Day-1 人工投入時間（小型/中型 repo） | ≤ 30 分鐘 |
| 人工新寫內容比例（C 類）             | ≤ 20%     |
| 首次回合可合併率                     | ≥ 70%     |
| 架構硬規則違反率                     | ≤ 10%     |
| API 變更後 SPEC 草稿覆蓋率           | ≥ 90%     |

---

## 後續更新方向

- 持續改善主流 GenAI Agent 的相容性與 Prompt 穩定性
- 讓跨專案指引、文件治理與導覽方式更易讀
- 在有實際需求時補充 CI、驗收與量測範本
- 逐步釐清 Layer 0 → Layer 1 的銜接方式

## Contributing

歡迎提交 PR。貢獻方向、提交前檢查、PR 撰寫建議請見 [CONTRIBUTING.zh-TW.md](CONTRIBUTING.zh-TW.md)。
社群互動與回報入口請見 [CODE_OF_CONDUCT.zh-TW.md](CODE_OF_CONDUCT.zh-TW.md)、[SECURITY.zh-TW.md](SECURITY.zh-TW.md)、[SUPPORT.zh-TW.md](SUPPORT.zh-TW.md)。

---

## 延伸閱讀

- [GUIDE.zh-TW.md](GUIDE.zh-TW.md) — 較完整的方法與持續運作說明
- [DAILY-USAGE.zh-TW.md](DAILY-USAGE.zh-TW.md) — 長期使用者指南（Day-2+ 日常操作、IDE 配置、情境劇本）
- [anti-patterns.zh-TW.md](anti-patterns.zh-TW.md) — 常見錯誤與修正方法
- [我為什麼做 ZeroSpec（作者 Blog）](https://coreynote.life/posts/2026/04/zerospec/) — 背景故事與動機

---

## 參考資料

1. [Stack Overflow Developer Survey 2024: AI](https://survey.stackoverflow.co/2024/ai/)
2. [Stack Overflow Developer Survey 2025: AI](https://survey.stackoverflow.co/2025/ai/)
3. [METR：Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)
4. [AGENTS.md](https://agents.md/)
5. [Simon Willison：Hallucinations in code are the least dangerous form of LLM mistakes](https://simonwillison.net/2025/Mar/2/hallucinations-in-code/)
6. [Anthropic Engineering：Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
7. [GitHub Blog：5 Tips for Writing Better Custom Instructions for Copilot](https://github.blog/ai-and-ml/github-copilot/5-tips-for-writing-better-custom-instructions-for-copilot/)

---

## License

MIT License — see [LICENSE](LICENSE)
