# Changelog

本文件追蹤 ZeroSpec 框架的版本變更歷程。

---

## v0.3 — 2026-04-22

> Greenfield / Brownfield 導入路徑分叉 + 既有專案 SPEC 補登策略成形。

### 新增

- `docs:` GUIDE.md §7 新增「Step 3.5：依專案類型選擇下一步」，區分 Greenfield（全新專案）與 Brownfield（既有專案）兩條導入路徑，含補登優先序（4 層）、As-Is 原則、SDD 最低門檻、正規化不完整說明
- `docs:` README.md 快速開始 Step 3 後新增 Brownfield 提示區塊，指向 GUIDE.md §7 完整策略
- `prompts:` INIT-BUILD.md 第四步「現況評估與下一步建議」新增 Greenfield/Brownfield 自動偵測與對應的下一步建議
- `docs:` DAILY-USAGE.md §4 新增「劇本 F：既有專案（Brownfield）首次導入後的第一個月」，含 Week 1 SA + 第一份 SPEC、Week 2–4 雙軌並行、月底回顧
- `docs:` anti-patterns.md 新增反模式 #19：一次補齊所有既有 API 的 SPEC（Brownfield 補登應依優先序，Dead Zone 可接受無 SPEC）
- `scripts:` 驗收腳本補強 Greenfield/Brownfield 相關段落的存在性檢查

### 設計補強

- **As-Is 原則**：補 SPEC 的目標是讓 AI 理解「現在的程式碼行為」，不是記錄理想架構；To-Be 改善記在 TODO 欄，不混入 As-Is SPEC
- **正規化不完整**：Dead Zone API（長期未動、無 Consumer）可接受永遠沒有 SPEC，文件存在的前提是有消費者
- **Brownfield 建議順序**：先 SA（全局理解）→ 再補高優先 SPEC（依優先序）→ 開發軌正常觸發 SPEC

### 主流 SDD 做法借鏡

參考 SpecKit / OpenSpec / Kiro / AGENTS.md 官方標準後補入以下增強（維持零依賴精神）：

- `prompts:` SPEC.md 新增「Bugfix 變體」段落，借鏡 Kiro Bugfix Spec 的 Current / Expected / Unchanged 結構，以 Changelog 形式融入既有 SPEC，不另建 Bugfix 專檔
- `docs:` DAILY-USAGE.md §2.5 新增 Context Hygiene 段落（進入實作前清場、一次任務一條 session、跨 session 用 150 字結論銜接），借鏡 OpenSpec 官方 usage notes
- `docs:` GUIDE.md §3.6 新增 Nested AGENTS.md 指引（monorepo 子 package 層級導航），對齊 AGENTS.md 官方標準的最近檔案優先原則
- `docs:` README.md 核心特性新增「對齊 AGENTS.md 官方開放格式」一項，明確標示 ZeroSpec 在 AGENTS.md（Agentic AI Foundation / Linux Foundation）之上加入 SDD 治理

### Claude Code 官方實踐借鏡

參考 Anthropic 對 CLAUDE.md 的官方最佳實踐後補入以下增強：

- `docs:` README.md 修復核心特性兩則 bullet 被合併的換行問題
- `docs:` GUIDE.md §3.4 長度建議由 300 行收緊為 200 行主線（上限仍保留 300），補入「該寫 vs 不該寫」對照表、每行自檢法則金句、強調語法節制使用原則、HTML 註解作為維護者備忘的技巧
- `docs:` anti-patterns.md 新增反模式 #21 AGENTS.md 臃腫失焦、#22 AI 反覆違規就加更多規則（惡性循環）
- `docs:` DAILY-USAGE.md §2.2 新增「Claude Code 相容寫法：`CLAUDE.md` + `@AGENTS.md` import」，讓 Claude Code 使用者零成本相容 ZeroSpec 產出
- `docs:` DAILY-USAGE.md §5.6 新增診斷清單「AI 反覆違反同一條規則」，按「AGENTS.md 太長 → 規則有歧義 → 對話太長」優先順序排查
- `docs:` DAILY-USAGE.md §4 新增劇本 G「Explore → Plan → Implement 實作節奏」，對應 Anthropic 推薦的分段工作流程
- `prompts:` INIT-BUILD.md「常用開發指令」段落強制要求 Agent 補齊建置、測試、Lint、型別檢查四類驗證指令，呼應「給 AI 一個驗證自己工作的方法」原則

### 其他小補強

- `docs:` GUIDE.md §3.5 Quick Constraints 補入「強調語法使用注意」段落，引用 DAILY-USAGE §5.6 診斷流程作為前置條件
- `docs:` DAILY-USAGE.md 劇本 A 尾端補一行指向劇本 G 的連結，提示跨多檔任務建議採 Explore→Plan→Implement 節奏

### 範圍收斂與持續運作補強

- `docs:` README.md 新增「不適合的情境」區塊；GUIDE.md §0 新增「何時不該用 ZeroSpec」對照表，誠實標示一次性腳本 / POC / 探索期 / 已導入 Layer 1 等四類不建議採用的情境
- `.github:` pull_request_template.md 新增「SDD 同步檢查項」區塊，強制 PR 描述需引用 `SPEC-xxx` / `ADR-xxx` 或勾選「未觸發」
- `prompts:` 新增 `prompts/AUDIT.md`，提供 AGENTS.md 本體自檢 Prompt，結構化報告含長度 / 規則具體度 / 重複衝突 / 可刪除候選 / 必備欄位 / 注意力權重 / Token 佔用共 7 個維度（不寫檔）
- `docs:` GUIDE.md §3.3 新增「語意搜尋時代的導航表定位調整」小節，說明 Agent 具備 semantic search 時對照表應把篇幅移向 Quick Constraints 與 Don't 反例
- `docs:` DAILY-USAGE.md §5.4 補入「具體做法」小節，建議 `.zerospec/prompts/` 目錄 + `-custom` 後綴約定 + diff 對比升版流程
- `docs:` GUIDE.md §3.6 新增「Compaction 生存策略」小節，說明 Root vs Nested AGENTS.md 在長對話壓縮後的存活率差異，建議核心硬規則集中於 Root
- `scripts:` 驗收腳本補入 `prompts/AUDIT.md` 檔案存在與首行標題檢查

### 文字修繕與外部案例借鏡

- `docs:` README.md 與 GUIDE.md 版本號同步為 v0.3；修正 README「不適合的情境」區塊之錯字與段落空行
- `docs:` README.md 新增「30 秒起步」簡短卡片（精華步驟版），並在「AI Agent 外掛」下方補入 GitHub Copilot 不自動讀 AGENTS.md 的相容性提示
- `docs:` DAILY-USAGE.md §5.7 新增「Agent Bootstrap Test」快速驗收法（導航題 / 規則題 / 反例辨識題），用短流程量化驗收 AGENTS.md 是否真的有效
- `prompts:` AUDIT.md 第 4 維度（可刪除候選）新增「領域對照表在小型專案的必要性」條款——專案規模較小且 Agent 支援語意搜尋時，可考慮移除或大幅精簡
- `prompts:` AUDIT.md 新增「Token 佔用觀察（選填）」維度，健康分數同步改為語意化分級判斷
- `docs:` README.md、GUIDE.md、DAILY-USAGE.md、AUDIT.md 再修一輪錯字、重複句與殘留硬數字，將「前 500 tokens / 超過 200 行 / 回答 5–8 題」等描述改為較低維護的語意化寫法

---

## v0.2 — 2026-04-19

> 模型分流推薦 + Multi-root 防誤改 + Re-anchor 穩定性強化。

### 新增

- `docs:` README.md 新增「情境 × 模型推薦表」，依任務類型建議適合的 LLM 模型系列（不綁版號）
- `docs:` GUIDE.md §2.1 新增「模型選用建議」與「模型切換策略」段落
- `prompts:` 6 個 Prompt Pack（INIT-SCAN / INIT-BUILD / SPEC / ADR / SA / UPDATE）統一加入 Multi-root Workspace 提示區塊，含可複製的專案鎖定前綴範例與防誤改保險句
- `docs:` GUIDE.md §3.5 新增「段落排序與注意力權重」，提供 AGENTS.md 段落優先級表與 Quick Constraints 設計要點
- `docs:` DAILY-USAGE.md §2.5 新增「長對話 Re-anchor 策略」，含三種 re-anchor 範例與頻率建議
- `prompts:` INIT-BUILD Prompt 本體新增「關鍵約束（Quick Constraints）」區塊，置於專案定位之後、導航表之前
- `prompts:` UPDATE Prompt 新增 Quick Constraints 比對與同步規則，避免長期維運時與詳細規範漂移

---

## v0.1 — 2026-04-11

> 首次對外發布版本。

### 新增

- ZeroSpec 核心 Prompt Pack：`INIT-SCAN`、`INIT-BUILD`、`SPEC`、`ADR`、`SA`、`UPDATE`
- 文件模板：`DOCS-README-TEMPLATE`、`SA-TEMPLATE`、既有 `SPEC` / `ADR` 模板
- Day-1 與成熟專案範例：`.NET`、`Java Library`、`Python Package`、`React + Nx Monorepo`
- `DAILY-USAGE.md`：Day-2+ 長期使用者指南
- 驗收腳本：`scripts/verify-zerospec.sh`、`scripts/verify-zerospec.ps1`
- 最小 CI 範本：`.github/workflows/verify-zerospec.yml`
- 開源協作基線：`CONTRIBUTING.md`、`.github/pull_request_template.md`

### 重要整理

- Prompt 結構已針對主流代理使用情境整理，避免 Markdown codeblock 巢狀截斷問題
- `SPEC` / `ADR` / `SA` Prompt 已移除對外部模板路徑的錯誤前置相依，降低跨 Repo 使用摩擦
- INIT-SCAN 修正「限制」與「防漂移規則」語意衝突，合併為統一「規則」段落
- INIT-BUILD / SPEC / UPDATE Prompt 壓縮冗餘指令，降低 Token 消耗
- 驗收腳本補強 SPEC/ADR/SA 首行標題檢查與缺漏模板存在性檢查（60 → 65 assertions）
- README / GUIDE / DAILY-USAGE 已整理為對外發布可直接閱讀的導覽結構
- README 首段英文定位已調整為可直接對應 GitHub Description 的簡潔描述
- LICENSE 採 MIT License，並調整為 `Corey and contributors`

### 驗證

- `bash scripts/verify-zerospec.sh`：65 PASS / 0 FAIL
