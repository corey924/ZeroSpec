# Changelog

本文件追蹤 ZeroSpec 框架的版本變更歷程。

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
- LICENSE 採 MIT License，並調整為 `Corey and contributors`

### 驗證

- `bash scripts/verify-zerospec.sh`：65 PASS / 0 FAIL
