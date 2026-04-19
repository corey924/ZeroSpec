# Changelog

本文件追蹤 ZeroSpec 框架的版本變更歷程。

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
