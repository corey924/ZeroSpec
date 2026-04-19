# ZeroSpec

> **ZeroSpec is a zero-dependency Markdown framework that helps AI agents understand your repository structure, rules, and source of truth before coding.**
> 不裝框架、不跑 CLI，用結構化 Markdown 建立 AI 可讀的專案基線。

**版本**：v0.2
**狀態**：Active

---

## ZeroSpec 是什麼？

ZeroSpec 是一套零依賴、純 Markdown 的專案文件基線，用來整理 AI Agent 真正需要的上下文：

- 專案定位
- 架構約束
- 版本真相來源
- 模組導航
- 文件治理規則

多數 AI Coding Agent 在接手任務前，會先讀取專案根目錄的指引檔，例如 `AGENTS.md`。如果這些檔案缺少結構、內容過時，或把真正重要的規範埋在雜訊裡，常見結果會是：

- 找不到正確的模組或目錄
- 寫出違反分層的程式碼
- 引用錯誤版本、過時路徑或不存在的介面

ZeroSpec 的目標很單純：**用低維護成本，讓 AI Agent 能快速讀懂你的專案，並在日常開發中穩定遵守團隊規範。**

它特別適合：

- 想把專案整理成 AI 易讀、團隊也能長期維護的型態
- 不想引入額外 CLI、框架或複雜平台綁定
- 希望文件是「跟得上開發節奏的工作基線」，而不是一次性產物

### 核心特性

- **零依賴**：不需要安裝工具、CLI 或額外 runtime
- **低人工成本**：AI 掃描 Repo 產生初稿，人只需要審核關鍵決策
- **可持續運作**：不是 Day-1 做完就放著，而是能支撐後續更新與回顧
- **事件觸發擴張**：文件在真的需要時才建立，不預先堆一批空檔案
- **跨代理相容**：可搭配 GitHub Copilot、Codex、Claude、Gemini、Cursor 等主流代理
- **可銜接其他流程**：可作為更高層工作流或規格管理工具的 Layer 0

### Layer 0 定位

ZeroSpec 是 **Layer 0（Context Readiness）**，不是執行引擎：

| 層級        | 職責                                        | 代表工具          |
| ----------- | ------------------------------------------- | ----------------- |
| **Layer 0** | 讓專案「可被 AI 讀懂」— 架構約束、導航、SoT | **ZeroSpec**      |
| **Layer 1** | 讓 AI「照流程執行任務」— 工作流、phase gate | OpenSpec, SpecKit |

**與 Layer 1 工具並行使用**：ZeroSpec 產出的 SPEC 是「AI 可讀的介面契約與業務脈絡」，用途是讓 Agent 在任務開始前正確理解邊界；Layer 1 工具（如 OpenSpec、SpecKit）的 SPEC 則是「執行流程規格」，驅動 phase gate 或 workflow engine。兩者服務目的不同，可以並行存在而不互相覆蓋。常見的銜接方式是：以 ZeroSpec SPEC 作為 Layer 1 工具的人類可讀輸入基礎，由 Layer 1 工具在其之上定義執行步驟與驗收條件。

### 內容產生三層分流

ZeroSpec 的核心設計之一，是先分清楚哪些內容應由 AI 產生、哪些內容必須由人確認。詳見 [GUIDE.md §0](GUIDE.md#0-什麼是-zerospec)。

| 類別                    | 誰負責           | 人工投入    |
| ----------------------- | ---------------- | ----------- |
| **(A) AI 自動產生**     | AI 掃描 Repo     | 零          |
| **(B) AI 草擬、人審核** | AI 歸納 + 人確認 | 審核 5 分鐘 |
| **(C) 人必須提供**      | 無法從程式碼推導 | 回答 5–8 題 |

---

## 範例輸出

使用 Prompt Pack 後，AI 會為你的專案產生類似下面的導航文件：

````markdown
# AGENTS.md — my-backend AI 導航指引

## 專案定位
**庫存管理 API** — .NET 10（C#）+ ASP.NET Core + EF Core + PostgreSQL 16
Base Namespace：`MyApp.Api`、`MyApp.Service`（以 Solution 結構為準）
版本真相來源：套件版本以各 `.csproj` 為準，.NET SDK 以 `global.json` 為準

## 關鍵約束（Quick Constraints）
1. Controller 只處理 HTTP 請求/回應，不含業務邏輯
2. 不可在 Controller 直接操作 DbContext
3. 新 API 路徑格式：`/api/v1/{resource}`

## 領域/模組 ↔ 程式碼對照表
| 業務領域 | Controller          | 核心 Service      |
| -------- | ------------------- | ----------------- |
| 商品管理 | `ProductController` | `IProductService` |
| 認證     | `AuthController`    | `IAuthService`    |

## 程式碼產生規範
- Controller 只處理 HTTP 請求/回應；流程編排、驗證與交易邏輯放在 Service（違者 PR 退件）
- 不可在 Controller 直接操作 DbContext；資料存取統一走 Repository/Service 抽象
- 新 API 路徑格式：`/api/v1/{resource}`，避免動詞式路徑與多版本混用

## 常用指令
| 指令           | 說明     |
| -------------- | -------- |
| `dotnet build` | 建置專案 |
| `dotnet test`  | 執行測試 |
````

完整範例見 [`examples/`](examples/) 目錄，包含 .NET 雙 API、Java Library、Python Package、React Monorepo 與 Day-1 最小產出。

---

## 開始前

**目標專案**
- [ ] 已 clone 至本機：`git clone <your-repo-url>`
- [ ] 以 IDE 開啟**目標專案的根目錄**

> ZeroSpec 獨立存放即可，**不需要加入你的目標 Repo**。
> Bootstrap 完成後，你的 Repo 只新增 `AGENTS.md` 和 `docs/README.md` 兩個檔案。

**AI Agent 外掛**（以下擇一，必須具備 Repo 讀寫能力）

| 工具                     | 啟用方式                                       |
| ------------------------ | ---------------------------------------------- |
| GitHub Copilot (VS Code) | 切換至 **Agent 模式**（確認 `#codebase` 可用） |
| Cursor                   | 使用 **Composer — Agent**（非 Chat 模式）      |
| Claude Code              | 預設即具備讀寫能力                             |
| Windsurf                 | 使用 **Cascade 模式**                          |
| JetBrains AI Assistant   | 開啟 **Attach project files** 選項             |

> 不適用：ChatGPT / Claude.ai 網頁版（無法讀取本機 Repo）
>
> 若需要實際寫入檔案，請避免使用純 Plan 模式；`INIT-SCAN` 這類只做分析、不寫檔的步驟，則可視平台能力使用。

**推薦 LLM 模型**（依方案自選版本，只列系列名）

| 任務情境 | 推薦模型系列 | 說明 |
| -------- | ------------ | ---- |
| 日常編碼（CRUD、重構、bug fix） | Claude Sonnet / GPT / Gemini Pro | 速度與品質平衡，日常首選 |
| 架構分析、系統掃描（INIT-SCAN / SA） | Claude Opus / o-series | 長 context 深度推理，適合全局分析 |
| 大量程式碼生成（INIT-BUILD / SPEC） | Claude Sonnet / GPT-Codex | 程式碼產出導向，支援 Repo 讀寫 |
| 快速查詢、輕量任務 | Gemini Flash | 低延遲快速回應 |

> 版本依個人方案與額度自行選擇。建議選用具備長 context window 且支援 Repo 讀寫的模型。

---

## 快速開始（30 分鐘內完成）

### Step 1：分析現況（INIT-SCAN）

1. 開啟 [`prompts/INIT-SCAN.md`](prompts/INIT-SCAN.md)，複製 Prompt
2. IDE 切換至**目標專案根目錄**，開啟 **Agent 模式**
3. 貼入 Prompt → AI 掃描 Repo → 產出結構化現況盤點（不寫檔）
4. 確認分析結果、回答 2–3 個待確認問題（約 5–10 分鐘）

### Step 2：建置文件（INIT-BUILD）

1. 開啟 [`prompts/INIT-BUILD.md`](prompts/INIT-BUILD.md)，複製 Prompt
2. 在同一對話中貼入 → AI 詢問 5–8 個團隊決策問題（每題附預設建議）
3. 回答或確認後，AI 產出 `AGENTS.md` + `docs/README.md`
4. 審核 AI 草擬的領域對照表與命名慣例 → 確認寫入
5. AI 額外提供**現況評估與建議**（掃描摘要 + 建議第一份 SPEC + 下一步行動）

### Step 3：驗證

以新的 `AGENTS.md` 跑一個真實小任務（例如新增一支 API），確認 Agent 使用正確的 Namespace / Package 並遵守架構約束。

### Step 4：建立第一份 SPEC

根據 AI 在 Step 2 的建議，開啟 [`prompts/SPEC.md`](prompts/SPEC.md) 建立第一份 SPEC。
這是從「一次性產出」進入「**持續運作 SDD 機制**」的關鍵銜接。

### 導入後怎麼用？

| 觸發事件           | 使用 Prompt Pack                         |
| ------------------ | ---------------------------------------- |
| 新增/變更 API      | [`prompts/SPEC.md`](prompts/SPEC.md)     |
| 架構決策           | [`prompts/ADR.md`](prompts/ADR.md)       |
| 系統快照           | [`prompts/SA.md`](prompts/SA.md)         |
| 專案演進需同步文件 | [`prompts/UPDATE.md`](prompts/UPDATE.md) |
| 未觸發以上事件     | **不建立任何文件**                       |

建議每月做一次快速回顧、每季做一次完整回顧，詳細做法見 [GUIDE.md §7](GUIDE.md#7-導入與持續運作流程)。

### 驗收方式

ZeroSpec 內建跨平台驗收腳本，可快速檢查：

- 核心 Prompt 檔案是否完整（INIT-SCAN / INIT-BUILD / UPDATE）
- SPEC/ADR/SA 是否包含前置條件
- 重要模板與 Day-1 範例是否可用

執行方式：

- macOS / Linux：`bash scripts/verify-zerospec.sh`
- Windows（PowerShell）：`powershell -ExecutionPolicy Bypass -File .\scripts\verify-zerospec.ps1`

腳本會輸出 PASS / FAIL 摘要；若有任何失敗，會回傳非 0 結束碼，適合手動驗收或 CI 使用。

最小 CI 範本（GitHub Actions）已提供於：`.github/workflows/verify-zerospec.yml`

- 觸發條件：`pull_request`、`push`（`main`）
- 驗證內容：僅執行 `bash scripts/verify-zerospec.sh`

---

## Repo 結構

```
zerospec/
├── .github/
│   ├── pull_request_template.md  ← PR 描述範本
│   └── workflows/
│       └── verify-zerospec.yml   ← PR / push 自動驗收（最小 CI）
├── CONTRIBUTING.md              ← 貢獻指南
├── README.md                    ← 你正在讀的這份
├── GUIDE.md                     ← 完整方法論（設計原則、防漂移、持續運作、業界佐證）
├── DAILY-USAGE.md               ← 長期使用者指南（Day-2+ 日常操作、IDE 配置、情境劇本）
├── prompts/
│   ├── INIT-SCAN.md             ← Bootstrap 第一步：分析現況（不寫檔）
│   ├── INIT-BUILD.md            ← Bootstrap 第二步：產生 AGENTS.md + docs/README.md
│   ├── SPEC.md                  ← 觸發：API 變更 → 產 SPEC
│   ├── ADR.md                   ← 觸發：架構決策 → 產 ADR
│   ├── SA.md                    ← 觸發：系統快照 → 產 SA
│   └── UPDATE.md                ← 持續：更新 AGENTS.md + docs/README.md
├── templates/
│   ├── ADR-TEMPLATE.md          ← 直接可用的 ADR 模板
│   ├── SPEC-TEMPLATE.md         ← 直接可用的 SPEC 模板
│   ├── SA-TEMPLATE.md           ← 直接可用的 SA 模板
│   └── DOCS-README-TEMPLATE.md  ← docs/README.md 文件治理模板
├── scripts/
│   ├── verify-zerospec.sh       ← macOS/Linux 驗收腳本
│   └── verify-zerospec.ps1      ← Windows PowerShell 驗收腳本
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

## 驗收指標

| 指標                       | 目標      |
| -------------------------- | --------- |
| Day-1 人工投入時間         | ≤ 30 分鐘 |
| 人工新寫內容比例（C 類）   | ≤ 20%     |
| 首次回合可合併率           | ≥ 70%     |
| 架構硬規則違反率           | ≤ 10%     |
| API 變更後 SPEC 草稿覆蓋率 | ≥ 90%     |

---

## 後續更新方向

- 持續提升主流 GenAI Agent 的相容性與 Prompt 穩定性
- 持續補強跨專案一致性、文件治理與導覽可讀性
- 視實際使用情況逐步補充 CI、驗收與效果量測相關範本

## Contributing

歡迎提交 PR。貢獻方向、提交前檢查、PR 撰寫建議請見 [CONTRIBUTING.md](CONTRIBUTING.md)。

---

## 延伸閱讀

- [GUIDE.md](GUIDE.md) — 完整方法論（設計原則、防漂移、持續運作、業界佐證）
- [DAILY-USAGE.md](DAILY-USAGE.md) — 長期使用者指南（Day-2+ 日常操作、IDE 配置、情境劇本）
- [anti-patterns.md](anti-patterns.md) — 常見錯誤與修正方法

---

## License

ZeroSpec 採用寬鬆授權的 MIT License，允許個人、團隊與企業在保留授權聲明的前提下自由使用、修改與散布。

MIT License — see [LICENSE](LICENSE)
