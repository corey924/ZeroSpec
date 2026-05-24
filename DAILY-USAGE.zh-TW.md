# ZeroSpec 長期使用者指南（Day-2+）

> **🌐 [English](DAILY-USAGE.md)**

> 本文件描述 ZeroSpec 在 Day-1 初始化之後，工程師日常開發中如何「自然地」與 SDD 機制共存。
> 適合已完成 INIT-SCAN + INIT-BUILD、手邊有 `AGENTS.md` + `docs/README.md` 的團隊。

**版本來源**：[README.md](README.md) 的 `**Version**`
**對象**：已導入 ZeroSpec 的個人開發者或小型團隊

---

## 目錄

1. [日常開發中的三種操作模式](#1-日常開發中的三種操作模式)
2. [IDE 與代理平台配置建議](#2-ide-與代理平台配置建議)
3. [ZeroSpec 本體的定位：參考而非常駐](#3-zerospec-本體的定位參考而非常駐)
4. [典型情境劇本](#4-典型情境劇本)
5. [長期維護會遇到的真實問題](#5-長期維護會遇到的真實問題)
6. [月度/季度回顧實操流程](#6-月度季度回顧實操流程)
7. [從個人到團隊的漸進擴散](#7-從個人到團隊的漸進擴散)

---

## 1. 日常開發中的三種操作模式

ZeroSpec 導入後，日常開發通常就是在保留 `AGENTS.md` 的前提下直接使用 Agent 模式。若平台配置正確，很多 AI Agent 會在啟動或任務一開始讀取 `AGENTS.md`。多數日常任務不需要再另外打開 ZeroSpec 的 Prompt Pack。

### 模式 A：純寫程式碼（90% 時間）

你照常開 Agent 模式寫 code。在配置穩定的情況下，Agent 會把 `AGENTS.md` 當作專案約束的起點。

**很多任務不需要額外執行 ZeroSpec 步驟。**

> 比較理想的結果是：Day-1 設定完成後，ZeroSpec 會逐漸融入日常開發流程，而不是變成另一份要額外維護的清單。

### 模式 B：事件觸發文件更新（~8% 時間）

當 PR 涉及 API 新增、架構決策、或重大變更時，切回「文件模式」：

1. 開新分頁或新對話
2. 從 ZeroSpec 複製對應 Prompt Pack（SPEC / ADR / SA）
3. 貼入 Agent → 產出草稿 → 審核 → 合併進 PR

**建議做法**：把文件更新視為 PR 範圍的一部分，而不是獨立的後續任務。養成習慣後，這步驟通常約 5–10 分鐘。

### 模式 C：定期回顧（~2% 時間）

每月或每季，用 UPDATE Prompt 做一次健檢。詳見 [§6](#6-月度季度回顧實操流程)。

---

## 2. IDE 與代理平台配置建議

### 多代理入口檔速查表

不同 AI 平台會在啟動時或任務開始時讀取不同的指引檔。核心原則是：**平台特定入口檔盡量以 import 或參照方式引用 `AGENTS.md`**，而不是複製內容。重複貼上同一準則，容易形成互相競爭的指令集，也會消耗 Agent 的注意力配額。

| 平台                         | 主要入口檔                                      | 自動讀取                                                     | Pointer 策略                                             |
| ---------------------------- | ----------------------------------------------- | ------------------------------------------------------------ | -------------------------------------------------------- |
| **GitHub Copilot (VS Code)** | `.github/copilot-instructions.md` + `AGENTS.md` | copilot-instructions ✅ / AGENTS.md ❌（需 `@AGENTS.md` 引用） | 在 copilot-instructions 內加入 `@AGENTS.md` 參照         |
| **Cursor**                   | `AGENTS.md` / `.cursorrules`                    | ✅                                                            | 以 AGENTS.md 為唯一來源；其他入口檔以 import 引用        |
| **Claude Code**              | `CLAUDE.md`                                     | ✅                                                            | CLAUDE.md 首行加 `@AGENTS.md`（Claude Code import 語法） |
| **Windsurf**                 | `AGENTS.md`                                     | ✅                                                            | 直接使用                                                 |
| **JetBrains AI Assistant**   | `AGENTS.md`                                     | ✅（需開啟 Attach project files）                             | 直接使用                                                 |
| **Codex CLI / Generic CLI**  | `AGENTS.md`（工具支援時）                       | Codex ✅ / generic 依工具而定                                 | 支援時使用 `AGENTS.md`；否則直接貼入 Prompt Pack 內容    |

> 入口檔與可選 adapter 詳見 §2.2；multi-root 行為詳見 §2.4。本表為一覽式速查參考。

#### 各工具最快體驗路徑（Fastest First Run）

選擇你使用的工具，照 3 步驟在任何現有專案體驗 ZeroSpec：

| 工具                    | Step 1                                  | Step 2                                                                   | Step 3（驗證）               |
| ----------------------- | --------------------------------------- | ------------------------------------------------------------------------ | ---------------------------- |
| **GitHub Copilot**      | 在專案根目錄開啟 Agent mode             | 貼入 `prompts/INIT-SCAN.md` 內容                                         | 確認 AI 產出的路徑是真實檔案 |
| **Cursor**              | 在專案根目錄開啟 Composer Agent         | 貼入 `prompts/INIT-SCAN.md` 內容                                         | 同上                         |
| **Claude Code**         | `cd` 到專案根目錄，啟動 session         | 說「幫我跑 ZeroSpec init-scan」（skill 已裝）或貼 `prompts/INIT-SCAN.md` | 確認輸出引用真實專案路徑     |
| **Windsurf**            | 在專案根目錄開啟 Cascade                | 貼入 `prompts/INIT-SCAN.md` 內容                                         | 同上                         |
| **JetBrains**           | 啟用 Attach project files，開啟 AI chat | 貼入 `prompts/INIT-SCAN.md` 內容                                         | 同上                         |
| **Codex CLI / Generic** | 在專案根目錄啟動 CLI                    | 將 `prompts/INIT-SCAN.md` 內容貼入 prompt                                | 確認輸出引用真實專案路徑     |

### 2.1 ZeroSpec Repo 不需要常駐打開

ZeroSpec 本體（`prompts/`、`templates/`、`GUIDE.md`）是「工具箱」，不是工作區。

**建議做法**：

| 方式                    | 說明                                                                                                                      | 適合誰                             |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------------- | ---------------------------------- |
| **書籤式**              | 瀏覽器或 IDE 書籤 ZeroSpec 資料夾，需要時點開複製 Prompt                                                                  | 個人開發者                         |
| **Snippet**             | 把常用 Prompt Pack 收進 IDE 的 User Snippets 或 Text Expander                                                             | 頻繁使用者                         |
| **Prompt Files**        | 將 `templates/prompts/*.prompt.md` 複製到專案的 `.github/prompts/`；可在支援的 VS Code Prompt 介面呼叫同一套 Prompt Packs | VS Code 使用者（可選 adapter）     |
| **Skill-style Adapter** | 透過 `sync-skills.sh` 或 `sync-skills.ps1` 安裝，之後可全域以意圖觸發                                                     | Claude Code / 支援 SKILL.md 的工具 |
| **Pointers**            | 從 `templates/pointers/` 複製對應平台的模板到你的專案，讓 AGENTS.md 與 AI 平台直接對接，不複製內容                        | 所有平台（Day-1 設定）             |
| **Symlink**             | 將 ZeroSpec `prompts/` 暴露到目標專案的 `prompts/`（複製或 symlink）                                                      | VS Code Prompt Files / 多專案團隊  |
| **複製貼上**            | 最簡單——需要時開 ZeroSpec README，按連結找到 Prompt，複製貼入                                                             | 所有人（Day-1 推薦的起步方式）     |

> **不建議**：把 ZeroSpec 整個資料夾加進目標專案的 workspace。這會讓 Agent 讀到不相關的 markdown，浪費 context。

> **⚠️ Prompt Files 設定**：這些 adapter 使用 `#file:prompts/XXX.md`。請確保該路徑可解析：可在同一個 VS Code multi-root workspace 開啟 ZeroSpec，或將 ZeroSpec 的 `prompts/` 目錄複製 / symlink 到目標專案並命名為 `prompts/`。若路徑無法解析，請依各 `.prompt.md` 內的 fallback 說明，手動貼入來源 Prompt。

### 2.2 `.github/copilot-instructions.md` 與 `AGENTS.md` 的共存

GitHub Copilot 同時支援兩種指引檔案：

| 檔案                              | 常見讀取時機                           | 適合放什麼                             |
| --------------------------------- | -------------------------------------- | -------------------------------------- |
| `.github/copilot-instructions.md` | Copilot 對話開始時自動讀取             | 個人偏好、語言、回覆格式（跨專案通用） |
| `AGENTS.md`                       | 平台支援時於任務開始讀取，或由參照帶入 | 專案特有約束（架構、命名、技術棧）     |

**最佳實踐**：

- `.github/copilot-instructions.md` 放「你是誰、怎麼回覆」（等同你現在的 personal profile sync）
- `AGENTS.md` 放「這個專案怎麼寫 code」（ZeroSpec 產出）
- 兩者互補不衝突，不需要合併

#### Claude Code 的相容寫法（`CLAUDE.md` + `@AGENTS.md`）

Claude Code 預設只讀 `CLAUDE.md`，不會讀 `AGENTS.md`。若你希望同時保留 ZeroSpec 的 AGENTS.md 成果，又讓 Claude Code 使用者零成本相容，在 repo 根目錄建立以下 `CLAUDE.md` 即可：

```markdown
@AGENTS.md

## Claude Code 專屬補充

（如無特殊需求，此段可留空）
```

- `@AGENTS.md` 是 Claude Code 的 import 語法，啟動時會展開 AGENTS.md 內容
- 不需要複製一份 AGENTS.md → CLAUDE.md，避免兩處維護的漂移風險
- 其他 Agent（Copilot / Cursor / Codex / Windsurf）仍照常讀 AGENTS.md
- 若有只適用 Claude Code 的規則（例如 Plan 模式觸發條件），放在 import 之後即可

#### 可選工具 Adapter

ZeroSpec 的標準入口仍是 `prompts/*.md`：任何工具都可以用複製貼上、書籤或 CLI stdin 使用 Prompt Packs。Adapter 只在能減少重複手動操作時才需要。

| 工具                     | 可選 Adapter                    | 備註                                                                                                         |
| ------------------------ | ------------------------------- | ------------------------------------------------------------------------------------------------------------ |
| GitHub Copilot (VS Code) | `templates/prompts/*.prompt.md` | 需讓 `#file:prompts/` 可解析；手動貼上仍是 fallback                                                          |
| Claude Code              | `skills/zerospec/` Router Skill | macOS/Linux：`bash scripts/sync-skills.sh --install`；Windows：`pwsh -File scripts/sync-skills.ps1 -Install` |
| Codex CLI / Generic CLI  | 不需要                          | 支援時使用 `AGENTS.md`；否則直接貼入 `prompts/*.md`                                                          |

安裝 Claude Code skill 後，第一次導入可說 `"幫我跑 ZeroSpec init-scan"`；專案已經有 `AGENTS.md` 時再說 `"幫我跑 ZeroSpec audit"`。Claude 會自動讀取對應 Prompt，並在輸出前執行內建自審（Self-Review）。跨平台同步指令與 Claude Code 驗證清單見 [`skills/README.md`](skills/README.md)。

### 2.3 Plan 模式 vs Agent 模式的選用時機

| 情境                          | 建議模式     | 原因                                          |
| ----------------------------- | ------------ | --------------------------------------------- |
| **INIT-SCAN（分析階段）**     | 兩者皆可     | SCAN 不寫檔，Plan 模式也能完成分析            |
| **INIT-BUILD（建置階段）**    | Agent        | 需要寫入 `AGENTS.md` 和 `docs/README.md`      |
| **SPEC / ADR / SA 產生**      | Agent        | 需要讀程式碼 + 寫檔                           |
| **UPDATE 回顧**               | Plan → Agent | 先用 Plan 看差異報告，確認後轉 Agent 寫入     |
| **日常寫 code**               | Agent        | 需要讀寫程式碼                                |
| **PR Review 前的文件檢查**    | Plan         | 只需判斷「是否需要補 SPEC」，不需要寫任何東西 |
| **架構討論 / 技術選型前研究** | Plan / Chat  | 純粹蒐集資訊與比較，不需要動文件              |

**實務建議**：UPDATE Prompt 最適合「Plan 先看、Agent 再改」的兩段式操作。先在 Plan 模式貼入 UPDATE Prompt 看差異報告，確認要改的地方後，再切 Agent 模式讓它實際寫入。

### 2.4 Multi-root Workspace 注意事項

如果你的 IDE 同時開多個專案（例如 my-backend + my-frontend + shared-lib），Agent 會看到所有專案的 `AGENTS.md`。

#### 核心問題：Agent 怎麼知道你在對哪個專案下指令？

多數 IDE Agent 會以**當前開啟檔案所在的 workspace folder**作為主要 context。善用這個機制，再加上一句專案前綴，就能穩定鎖定目標專案。

#### 四種做法比較

| 做法                         | 操作方式                                                   | 適合情境               | 優缺點                                   |
| ---------------------------- | ---------------------------------------------------------- | ---------------------- | ---------------------------------------- |
| **Active File 錨定**（推薦） | 貼 Prompt 前，先點開目標專案中的任一檔案（如 `AGENTS.md`） | 所有 IDE Agent         | 零額外成本，Agent 會優先以該專案內容推論 |
| **專案名前綴**               | Prompt 開頭加「目標專案：{AGENTS.md 中的專案名}」          | 任務指令型對話         | 簡潔明確；專案名需與 AGENTS.md 標題一致  |
| **明確引用 AGENTS.md**       | 「請先讀取 `my-backend/AGENTS.md` 作為本次任務的約束」     | Agent 發生跨專案混淆時 | 最強制，但略繁瑣                         |
| **貼完整路徑**               | 在 Prompt 中貼入 `/Users/xxx/Projects/my-project`          | 專案名重複或路徑歧義時 | 明確但冗長，不利團隊共享與跨環境複用     |

> **推薦組合**：Active File 錨定 + 專案名前綴。日常 90% 情境只需要 Active File 錨定就足夠。

#### 實務範例

```
# 推薦：先開目標專案的檔案，再貼 Prompt
# （此時 Agent 已從 active file 知道你在 my-backend）
目標專案：my-backend
請為本次 API 變更產生 SPEC 文件。

# Agent 混淆時的修正
請先讀取 my-backend/AGENTS.md 作為本次任務的約束，
再為 Customer API 產生 SPEC。
```

#### 各平台行為差異（摘要）

| 平台                     | 鎖定方式重點                                     | 補充說明                                                    |
| ------------------------ | ------------------------------------------------ | ----------------------------------------------------------- |
| GitHub Copilot (VS Code) | 以 active editor 所在 workspace folder 為主      | Multi-root 下每個資料夾規範都可見，active file 會影響優先序 |
| Cursor                   | Composer Agent 以 active file 專案為主要 context | 可用 `@file` 進一步指定檔案                                 |
| Claude Code              | 以 `cwd` 為 context 起點                         | 啟動前先 `cd` 到目標專案目錄                                |
| Windsurf                 | Cascade 以 active file 推斷 context              | 行為接近 Copilot                                            |

#### 開源範例命名原則

為避免洩露內部資訊，公開文件中的示例請優先使用 `my-*`、`sample-*`、`shared-*` 命名，不使用真實專案名、個人路徑或可識別線索。

### 2.5 長對話 Re-anchor 策略

AI Agent 在長對話中（約 15–20 輪後）可能逐漸偏離 AGENTS.md 的約束。主要不是因為 AGENTS.md 太長，而是對話歷史與工具輸出累積後，稀釋了指引檔案的注意力權重；但控制文件長度仍有助於提升 re-anchor 效率。

#### 何時 re-anchor？

- 發現 AI 開始違反架構規則（如在 Controller 寫業務邏輯）
- 對話已超過 15 輪且接下來的任務涉及核心約束
- 切換到不同業務模組的任務

#### 怎麼 re-anchor？

**輕量版**（推薦，適用多數場景）：

```
請重新讀取 AGENTS.md，確認接下來的操作遵守所有架構約束。
```

**精準版**（當你知道哪條規則被違反時）：

```
你剛才在 Controller 裡寫了業務邏輯，這違反了 AGENTS.md 的架構約束。
請重新讀取 AGENTS.md 的「關鍵約束」段落，然後修正。
```

**完整重置版**（對話嚴重偏離時，建議開新對話）：

```
本次對話的 context 已過度膨脹，請開啟新對話，讓 Agent 重新載入 AGENTS.md 後繼續任務。
```

#### re-anchor 頻率建議

| 對話輪數 | 建議動作                         |
| -------- | -------------------------------- |
| 1–15 輪  | 正常操作，無需 re-anchor         |
| 15–25 輪 | 若涉及架構敏感操作，貼一次輕量版 |
| 25+ 輪   | 建議開新對話重新開始             |

> 上述輪數以 128K–200K context 模型為基準。較小 context window 的模型可能在 10–15 輪就進入稀釋區，建議提前 re-anchor。

> **為什麼不用更複雜的自動化機制？** ZeroSpec 是 Layer 0 框架，不依賴 CLI 或 runtime。re-anchor 靠使用者在正確時機貼一句提醒即可，無需額外工具。

#### Context Hygiene（進入實作前的清場原則）

除了 re-anchor 之外，另一個維持 Agent 品質的關鍵是 context hygiene：

- **進入實作前清空不相關 context**：審核 SPEC / 討論架構 → 實際寫 code 是兩種任務，建議不同 session。若上一輪已是長討論，開新對話再下實作指令
- **一次任務一條 session**：Bugfix / 新功能 / 重構 分開對話，避免上一個任務的 tool output 干擾下一個判斷
- **長討論輸出「討論總結」再換 session**：若需跨 session 延續，請 AI 產出結論約 150 字的重點，下一個 session 貼入為起點，不要帶整段 history

> 參考來源：OpenSpec 官方 usage notes 明確建議「clear your context before starting implementation」。ZeroSpec 在 Prompt 層沒有自動清場機制，但使用者可以透過這三條原則達到類似效果。

---

## 3. ZeroSpec 本體的定位：參考而非常駐

### 需要開 ZeroSpec 的時刻

| 時刻                     | 你需要的東西                  | 花費時間     |
| ------------------------ | ----------------------------- | ------------ |
| PR 涉及 API 變更         | `prompts/SPEC.md` 的 Prompt   | 複製 10 秒   |
| 跨模組技術決策           | `prompts/ADR.md` 的 Prompt    | 複製 10 秒   |
| 月度回顧                 | `prompts/UPDATE.md` 的 Prompt | 複製 10 秒   |
| 忘記某個模板長怎樣       | `templates/` 目錄             | 瀏覽 30 秒   |
| 想查某個反模式的修正方法 | `anti-patterns.zh-TW.md`      | 瀏覽 1 分鐘  |
| 新人加入想了解這套方法論 | `GUIDE.zh-TW.md`              | 閱讀 15 分鐘 |

### 不需要開 ZeroSpec 的時刻

- 日常寫程式碼（Agent 自動讀 `AGENTS.md`）
- Commit / Push / PR Review（只看專案內的 SPEC 和 AGENTS.md）
- Debug / 測試（與文件治理無關）

---

## 4. 典型情境劇本

### 劇本 A：新增一支 REST API

```
timeline:
  1. 你開始寫新 API → Agent 自動讀 AGENTS.md → 遵守架構規範產 code
  2. 寫完後 → 你想到「AGENTS.md 說 PR 涉及 API 變更要更新 SPEC」
  3. 開 ZeroSpec → 複製 SPEC Prompt → 貼入 Agent
  4. Agent 讀現有 SPEC → 產出更新草稿 → 你審核 → 一起進 PR
  5. 總額外時間：~8 分鐘
```

> 若新 API 涉及跨多檔重構或新增多個資源，建議按劇本 G（Explore → Plan → Implement）分段進行，Agent 品質通常會更穩定。

### 劇本 B：升級 Spring Boot 3.5 → 4.0

```
timeline:
  1. 完成框架升版 + 程式碼調整
  2. 開 ZeroSpec → 複製 UPDATE Prompt → 貼入 Agent（Plan 模式）
  3. Agent 偵測到 build.gradle 版本變更 → 列出 AGENTS.md 差異
  4. 確認 → 切 Agent 模式 → 寫入更新
  5. 如果升版涉及架構決策（如 Virtual Threads 全面啟用）→ 接著複製 ADR Prompt
  6. 總額外時間：~15 分鐘
```

### 劇本 C：新成員加入

```
timeline:
  1. 新人 clone repo → 開 IDE → Agent 自動讀 AGENTS.md
  2. 新人問「這個專案架構是什麼？」→ Agent 根據 AGENTS.md 精準回答
  3. 新人接到任務 → Agent 幫他寫的 code 自動遵守規範
  4. 如果需要深入了解 → AGENTS.md 導航表指向 SA / SPEC / ADR
  5. 新人不需要讀 ZeroSpec 本身 — 他只需要專案內的 AGENTS.md
```

### 劇本 D：月度回顧

```
timeline:
  1. 月底 → 你花 2 分鐘打開 GUIDE.md §7 的快速回顧 Checklist 掃一遍
  2. 發現上個月新增了 3 個 Service 但對照表沒更新
  3. 複製 UPDATE Prompt → Agent 自動偵測差異 → 建議更新
  4. 確認 → 寫入 → commit
  5. 總時間：~15 分鐘
```

### 劇本 E：PR Review 時判斷是否需要補文件

```
timeline:
  1. Review 別人的 PR → 看到 Controller 新增了兩支 API
  2. 打開 AGENTS.md → 文件維護提醒寫「PR 涉及 API 變更需更新 SPEC」
  3. 在 PR 留言：「這個變更需要用 SPEC Prompt 補一份 SPEC 草稿」
  4. 你不需要自己動手 — 只需要提醒
```

### 劇本 F：既有專案（Brownfield）首次導入的第一個月

```
情境：你的專案已有中量/大量 API，INIT-BUILD 剛完成，
      AGENTS.md 和 docs/README.md 已到位。

Week 1：建立全局理解
  1. 跑一次 SA Prompt → 讓 Agent 產出系統架構快照（docs/analysis/SA-001.md）
  2. 選出「最近 30 天有程式碼異動」的 API → 這是你的補登 Tier 1 清單
     （完整補登優先序：最近有異動 > 跨系統/跨團隊依賴 > 業務邏輯複雜，見 GUIDE.md §7 Step 3.5）
  3. 對 Tier 1 最重要的一支 API 跑 SPEC Prompt → 建立第一份 SPEC
  4. 把 SA + SPEC 一起進 commit → 宣告 ZeroSpec 正式啟動

Week 2–4：並行兩條軌道
  開發軌：所有新 API 或有變更的 API → 正常觸發 SPEC（這條軌道是必須的）
  補登軌：每週挑 1–2 支 Tier 1 API 補 SPEC（維持節奏，不要一次衝太多）

  補 SPEC 時的 As-Is 原則：
  - 目標是描述「現在的程式碼行為」，不是理想架構
  - 發現問題先記在 SPEC 的 TODO 欄，不混入 As-Is 描述

月底回顧：
  - 清點補了幾份 SPEC → 確認 Tier 1 是否大致覆蓋
  - 有無 Dead Zone API（長期未動、無 Consumer）→ 標記「無需補登」，不要浪費時間
  - 開發軌運作是否正常 → 有沒有 API 變更但漏掉 SPEC？

總額外時間：Week 1 約 45–60 分鐘（SA + 第一份 SPEC）；Week 2–4 每週 10–20 分鐘
```

### 劇本 G：Explore → Plan → Implement 的實作節奏（推薦用於中等以上任務）

多數 Agent 平台（Claude Code Plan 模式、Copilot Chat、Cursor Composer）都支援「先分析、再實作」的分段操作。對於跨多檔的任務，先分段走一輪通常比讓 Agent 直接動手更穩定：

```
任務：在 my-backend 新增 OAuth 登入流程（跨 AuthController、SecurityConfig、User entity）

Step 1 — Explore（Plan 模式）
  貼入：「請讀 src/auth/ 了解現行 session 管理，讀 SecurityConfig 看過濾器鏈，不要寫任何檔案」
  產出：結構化摘要 + 影響範圍清單

Step 2 — Plan（同 Plan 模式）
  貼入：「基於上述理解，請提出加入 Google OAuth 的實作計畫，列出每個檔案的改動」
  產出：檔案層級的變更計畫
  → 人審核計畫，直接在計畫上修改或打回重來

Step 3 — Implement（切 Agent 模式 / 新對話）
  貼入：「依上面計畫實作，並執行 make test 驗證結果」
  → Agent 寫 code + 跑驗證指令

Step 4 — Commit & SPEC（同對話）
  貼入：「本次變更涉及 Auth API，請用 SPEC Prompt 產對應 SPEC，再一起 commit」
```

**何時可跳過這節奏**：單檔 typo、單行 log 新增、單純 rename 這類「一句話描述得完的 diff」。計畫階段的成本只在任務複雜時才划算。

**為什麼值得做**：AGENTS.md 能提供結構約束，但無法替代任務層級的計畫；Explore 階段能讓 Agent 在動手前認清本次任務的邊界，這通常是降低「生出貌似正確但遺漏 edge case」風險的實用做法。

### 劇本 H：確認現有 SPEC 是否仍與程式碼一致

在懷疑 SPEC 已漂移、版本發布前、或定期回顧時使用。

```
觸發範例：
- PR reviewer 回饋：「這份 SPEC 描述的還是舊的認證流程」
- 兩個月前做了模組重構，不確定 SPEC 是否跟著更新過
- 月度回顧：抽查 1–2 份高異動 SPEC 確認漂移狀況

工作流程：
1. 從 ZeroSpec 開啟 prompts/DRIFT.md，複製 Prompt
2. 在目標專案開啟 Agent 模式
3. 選擇性指定：「Check drift for: docs/spec/SPEC-001_auth.md」
   （留空則檢查全部 docs/spec/SPEC-*.md）
4. 貼入 Prompt → Agent 掃描程式碼 vs SPEC → 產出漂移報告（不寫任何檔案）
5. 依嚴重度處理：
   - BREAKING → 立即用 SPEC Prompt 更新（Bugfix Variant 格式）
   - DRIFT    → 在下一個 feature PR 一起帶入 SPEC 更新
   - STALE    → 在 Changelog 補上約略日期與說明
   - CLEAN    → 無需動作
```

**關鍵限制**：DRIFT **不寫任何檔案**，只產出報告——由你判斷哪些發現需要後續處理。

---

### 情境 I：多模組 Coding 同步 SPEC——何時使用 IMPL.md

當一個開發任務預計會碰到多個 Controller 並同時影響多份 SPEC 時，請使用 [IMPL Prompt Pack](prompts/IMPL.md)。它加入明確的逐步守衛，避免 AI 完成程式碼後悄悄跳過文件同步。

```
觸發範例：
- 「新增 Group Management 模組」——3 個新 Controller、SPEC-002 與 SPEC-003 同時異動
- 「重構 Auth 層」——AuthController、PermissionService、UserRepository 全部要改
- 任何你明知會跨 2 份以上 docs/spec/ 的任務

何時用 IMPL vs 只靠 AGENTS.md Post-Edit Self-Check：
- 1 個 Controller、1 份 SPEC 異動  → AGENTS.md Post-Edit Self-Check 就夠了
- 3+ Controller/handler、2+ SPEC → 改用 IMPL.md 取得明確的逐步同步指引

工作流程：
1. 從 ZeroSpec 開啟 prompts/IMPL.md，複製 Prompt
2. 在 Prompt 上方或下方描述任務（哪個模組、哪些變更）
3. Agent 先輸出計畫：受影響的程式碼區域 → 對應的 SPEC 文件（coding 前）
4. 你審閱計畫——修改或拒絕後 Agent 再實作
5. Agent 實作程式碼，接著對每份受影響的 SPEC 執行 Step 3 SPEC Sync
6. 每次回覆末尾都會出現 ### Docs Impact 區塊，列出所有受影響 SPEC 及更新狀態
```

**為什麼重要**：沒有 IMPL.md，多模組任務可能在程式碼端成功完成，同時讓 2–3 份 SPEC 悄悄過時。強制輸出（Forcing Function）的 `### Docs Impact` 區塊讓評估結果在每一個回覆中都可見。

---

## 5. 長期維護會遇到的真實問題

### 5.1 「我忘了要更新 SPEC」

**根因**：事件觸發依賴人的自覺，沒有自動提醒。

**緩解策略**：
- **最低成本**：在 PR template 加一行 Checklist：`- [ ] 若涉及 API 變更，是否已用 SPEC Prompt 更新 SPEC？`。可直接複製現成的 [`templates/pull_request_template.md`](templates/pull_request_template.md) 到你的專案 `.github/pull_request_template.md`。
- **中等成本**：PR Review 時養成習慣——看到 Controller 變更就問「SPEC 有更新嗎？」
- **高成本**：CI 腳本自動偵測 Controller 檔案變更但 `docs/spec/` 無對應修改，發出警告

### 5.2 「AGENTS.md 領域對照表慢慢過時了」

**根因**：新增模組時沒有同步更新，UPDATE Prompt 不是自動跑的。

**緩解策略**：
- 行事曆設定每月固定 15 分鐘「SDD 快速回顧」事件
- UPDATE Prompt 的差異報告會自動偵測新增/移除的 Controller / Service
- 如果對照表落後超過 3 個模組，Agent 寫出來的 code 往往仍可用——因為影響正確性的通常還是 `AGENTS.md` 的架構規範（C 類），而不是對照表（B 類）本身。對照表更像是幫 Agent 快速定位檔案的導航輔助。

### 5.3 「團隊其他人不買單」

**根因**：SDD 對個人有即時回報（Agent 寫的 code 品質變好），但對團隊的價值需要累積才看得到。

**漸進擴散策略**：見 [§7](#7-從個人到團隊的漸進擴散)。

### 5.4 「Prompt Pack 用久了想客製化」

**完全正常且被鼓勵。** ZeroSpec 是起點不是終點。

**可客製化的方向**：
- 在 SPEC Prompt 中加入專案特有的 DTO 命名慣例
- 在 ADR Prompt 中加入團隊必須評估的維度（如成本、合規性）
- 在 UPDATE Prompt 中加入額外檢查項（如 i18n 翻譯 Key 同步）

**客製化原則**：修改你專案中的 Prompt 副本，不要改 ZeroSpec 本體。這樣 ZeroSpec 升版時不會衝突。

#### 具體做法（推薦約定）

```
<your-repo>/
├── AGENTS.md
├── docs/
└── .zerospec/
    └── prompts/
        ├── SPEC-custom.md      ← 你客製化的副本，-custom 後綴表示已改
        ├── ADR-custom.md
        └── UPDATE-custom.md
```

- **命名規則**：原檔名 + `-custom` 後綴；同檔名無後綴代表未改，可跳過 diff
- **位置**：放 `.zerospec/prompts/`（或 `docs/prompts/`），通過 git 追蹤客製化歷史
- **升版比對**：升級 ZeroSpec 後跑一次：
  ```
  diff <新版>/prompts/SPEC.md .zerospec/prompts/SPEC-custom.md
  ```
  看官方版有什麼新增段落 → 手動正確移植到 `-custom` 副本

#### 「何時該回饋上游」判斷

- 若你的客製化改動在多個專案都在用 → 可考慮回 PR 給 ZeroSpec 本體（讓官方正式支援）
- 若只是單一專案限定慣例 → 寫在 `-custom` 副本繼續維護即可，不需回流

### 5.5 「docs/ 目錄文件越來越多，不確定該不該停」

**判斷標準**：文件是否有明確的消費者。

| 消費者       | 文件類型 | 持續產出                                 |
| ------------ | -------- | ---------------------------------------- |
| AI Agent     | SPEC     | ✅ 每次 API 變更就更新（Source of Truth） |
| 新成員 / AI  | SA       | ⚠️ 只在里程碑或需要系統快照時產出         |
| 團隊決策記錄 | ADR      | ⚠️ 只在有 either/or 決策時                |
| DevOps / AI  | INFRA    | ⚠️ 只在部署變更時                         |

如果一份文件寫完後從沒被引用過，它可能不需要存在。

### 5.6 「AI 反覆違反同一條 AGENTS.md 規則」

**建議檢查順序**：

1. **AGENTS.md 過長 / 核心規則被噪音埋沒**：檔案明顯偏長且含大量 AI 本來就會的通用常識 → 核心規則落在注意力稀釋區
2. **規則描述有歧義**：同一條規則在 AGENTS.md 兩處描述不一致，或語句抽象到 AI 無法驗證（如「寫乾淨程式碼」）
3. **對話已過長 / context 稀釋**：超過 15–20 輪的長對話，AGENTS.md 的注意力權重被後續對話輸出稀釋
4. **領域對照表已過期**：對照表中的 Controller 或 Package 路徑已刪除或改名——用 AUDIT Dimension 8 抽查，或用 DRIFT Prompt 確認 SPEC 內容與程式碼是否一致

**診斷流程**：

```
1. 計算 AGENTS.md 行數
   wc -l AGENTS.md
  → 若已明顯偏長：套用 GUIDE §3.4 每行自檢法則修剪，移除 AI 無需被提醒的通用常識

2. 檢視被違反的規則本文
   → 同一規則在檔案中是否重複出現但敘述不一致？
   → 規則是否具體到可驗證（如「Controller 不寫 DbContext」），還是抽象（如「保持程式碼整潔」）？
   → 具體化或統一敘述後再觀察

3. 如果規則已經具體且 AGENTS.md 不長，檢查對話
   → 若對話 > 15 輪：貼一次輕量 re-anchor（見 §2.5）
   → 若對話 > 25 輪：開新對話重來

4. 仍無效的最後手段：在該規則前加 IMPORTANT: 或 YOU MUST
   → 但注意：若每條規則都加強調語，等於沒有強調
```

**不建議的反應**：再加一條新規則「禁止違反規則 X」。這只會讓 AGENTS.md 更長、問題更嚴重（詳見 [anti-patterns #22](anti-patterns.zh-TW.md)）。

### 5.7 「想快速驗收 AGENTS.md 是否真的有效」

寫完或大改 AGENTS.md 後，**用新對話跑一輪快速測試**（幾分鐘即可），比讀完整份文件更能反映 Agent 實際理解程度：

| 測試題型   | 範例問法                                                             | 期望答對的訊號                          |
| ---------- | -------------------------------------------------------------------- | --------------------------------------- |
| 導航題     | 「認證邏輯在哪個 package / module？」                                | 指向對照表列出的實際路徑，不是通用推測  |
| 規則題     | 「新增一支 API 的路徑與分層要求？」                                  | 引用 Quick Constraints 或程式碼產生規範 |
| 反例辨識題 | 貼一段「在 Controller 直接操作 DbContext」的程式碼問「這違反什麼？」 | 準確點名被違反的硬規則並建議正確位置    |

**結果判讀**：

- **大多答對**：AGENTS.md 健康，可正常使用
- **少量答錯**：該領域的導航或規則需要補強，針對性修
- **多數答錯**：跑 [AUDIT Prompt](prompts/AUDIT.md) 做整體稽核

> 每次 AGENTS.md 大改（例如 UPDATE Prompt 寫檔後、Brownfield 補 SPEC 後）建議都跑一次。

### 5.8 指定產出語言（例如 zh-TW）

所有 ZeroSpec Prompt Pack 都包含這段語言規則：

> **Language**: Detect the repository's primary language from README, docs, and code comments. Respond in that language. Default to English if ambiguous.

這代表 **Prompt 本身永遠是英文**（指令格式），但 **產出檔案**（`AGENTS.md`、SPEC、ADR 等）通常會依據專案偵測到的語言決定。很多專案不需要額外操作。

**自動偵測可能失準的時機**：如果你的專案 README 以英文撰寫，但你希望 `AGENTS.md` 與 `docs/` 使用其他語言（如台灣正體中文），Agent 可能會預設產出英文。此時可使用以下覆寫方式：

| 範圍       | 做法                                                                                                   | 適用時機       |
| ---------- | ------------------------------------------------------------------------------------------------------ | -------------- |
| **一次性** | 在 Prompt 前加一行：`所有產出檔案請使用台灣正體中文（zh-TW）。`                                        | 臨時任務或測試 |
| **專案層** | 在 `AGENTS.md` 開頭或 `.github/copilot-instructions.md` 加入：`All generated docs should be in zh-TW.` | 團隊一致性     |
| **個人層** | 在 IDE 全域設定（如 `~/.copilot/instructions/`）加入：`Prefer zh-TW for generated docs.`               | 個人長期偏好   |

**建議**：團隊成員語言一致時，用專案層設定。混合語言團隊則讓自動偵測運作，必要時用一次性覆寫。

---

## 6. 月度/季度回顧實操流程

### 月度快速回顧（15 分鐘）

```
實際操作步驟：
1. 開終端機 → `git log --since="1 month ago" --oneline -- '*.java' '*.ts' '*.cs' | wc -l`
   → 大致感受這個月的變更量

2. 打開 AGENTS.md → 快速掃過領域對照表
   → 有沒有上個月新增的 Controller / Service 沒列進來？

3. 打開 docs/README.md → 看文件清單
   → docs/ 目錄下有沒有新檔案沒收錄？

4. 如果有落差 → 複製 UPDATE Prompt → 貼入 Agent → 讓它產差異報告
5. 確認 → 寫入 → commit → done

6. 選擇性：用 DRIFT Prompt 抽查 1–2 份高異動 SPEC
   → 這個月是否有行為變更但 SPEC 還沒跟上？
   → 有 BREAKING 發現 → 在下個版本發布前更新 SPEC
```

### 季度完整回顧（30 分鐘）

除上述步驟外：

```
額外步驟：
6. 回顧這一季 Agent 寫出來的 PR → 有沒有反覆違反同一條規則？
   → 若有，調整 AGENTS.md 中該規則的描述清晰度

7. 檢查 AGENTS.md 的行數 → 是否已明顯偏長？
  → 若是，考慮把低頻使用的段落移到 docs/ 子文件

8. 與團隊成員確認架構硬規則是否仍然適用
   → 有沒有「大家都默認違反但沒人改文件」的規則？

9. 如果這一季有重大架構變更 → 考慮跑一次 SA Prompt 產新的系統快照
```

---

## 7. 從個人到團隊的漸進擴散

### Phase 1：個人先行（Week 1-4）

- 你自己跑 INIT-SCAN + INIT-BUILD
- 用產出的 `AGENTS.md` 開發，體感 Agent 品質提升
- 偷偷在 PR 裡帶上 SPEC 更新，讓隊友看到文件自然產出

### Phase 2：消極擴散（Month 2-3）

- 團隊成員使用 Agent 開發時，自動受益於 `AGENTS.md` 的規範
- 他們不需要知道 ZeroSpec 存在——他們只知道「Agent 懂我們的架構了」
- PR Review 時偶爾提醒「API 變更需要補 SPEC」

### Phase 3：主動引入（Quarter 2）

當團隊已經習慣 AGENTS.md 的存在後：

- 在團隊會議中簡短介紹 SPEC Prompt + UPDATE Prompt（5 分鐘）
- 在 PR template 加入 SDD Checklist
- 指定一位「SDD 守門人」（不一定是你）負責月度回顧

### Phase 4：自運轉（Quarter 3+）

- 每個人都知道 API 變更要跑 SPEC Prompt
- 月度回顧變成固定例行
- 你只需要在季度回顧時介入

---

## 附錄：常見問題

### Q：ZeroSpec 的 README.md 需要常駐打開嗎？

**不需要。** ZeroSpec 的 README 是「使用手冊」，不是運行時依賴。就像你不會每天翻 React 官方文件一樣——你把它學會後，需要時再查。

### Q：ZeroSpec 應該加進 `.github/copilot-instructions.md` 嗎？

**不應該。** `copilot-instructions.md` 是給個人偏好用的（語言、格式、角色）。專案級約束由 `AGENTS.md` 負責。兩者職責分離。

但你可以在 `copilot-instructions.md` 中加一句提醒：

```markdown
## ⚡ Protocol: SDD
處理 PR 涉及 API 新增或行為變更時，主動提醒是否需要更新 SPEC。
```

### Q：我能不能讓 Agent 在每次對話開始時自動讀 ZeroSpec？

**不建議。** ZeroSpec 本體（prompts/ + templates/ + GUIDE.md）加起來已有數千行，會明顯消耗 context window。Agent 通常只需要讀你專案中的精簡 `AGENTS.md` 就夠了。

### Q：多人團隊中，誰負責跑 UPDATE Prompt？

**建議由最熟悉專案架構的人負責**——通常是 Tech Lead 或主要維護者。月度回顧可以輪班，但審核結果需要有架構判斷力的人把關。

### Q：文件越來越多，會不會回到「文件太多沒人看」的老問題？

ZeroSpec 的設計本身就在對抗這個問題：
- **Lazy Evaluation**：不預建空殼，觸發才建
- **SPEC 是唯一強制文件**：其他都是「值得有」但非必要
- **每份文件都有消費者**：SA 給新人和 Agent、ADR 給未來的決策者、SPEC 給日常開發的 Agent
- 如果一份文件三個月沒被引用，它可能可以歸檔

---

*本文件隨 ZeroSpec v0.1 發布。建議在導入滿一個月後再來閱讀，Day-1 不需要看這份。*
