# etl-pipeline-core — 文件治理中心

> 本文件定義專案文件的分層規則、命名規範與維護條件。
> GenAI Agent 在處理文件相關任務時應先讀取本文件。

## SDD 文件四層分類

| 分類              | 目錄             | 命名格式                   | 觸發條件                       |
| ----------------- | ---------------- | -------------------------- | ------------------------------ |
| SA（系統分析）    | `docs/analysis/` | `SA-{三位數}_{描述}.md`    | 里程碑或架構重大變更           |
| ADR（架構決策）   | `docs/adr/`      | `ADR-{三位數}_{描述}.md`   | 跨模組技術二選一決策           |
| SPEC（介面契約）  | `docs/spec/`     | `SPEC-{三位數}_{描述}.md`  | API 新增或行為變更（**強制**） |
| INFRA（基礎設施） | `docs/infra/`    | `INFRA-{三位數}_{描述}.md` | 部署拓樸或 CI 變更             |

- 命名正規式：`^(SA|ADR|SPEC|INFRA)-\d{3}_[a-z0-9-]+\.md$`
- **彈性擴充**：Library 專案可用 INTEGRATION 取代 INFRA

## Source of Truth

SPEC 是開發與 GenAI 的主要參照檔案。每次介面新增或修改都直接更新 SPEC，並在 Changelog 追蹤變更歷程。

**最低維護規則**：凡 PR 涉及 `PipelineService` 介面異動，必須同步更新 SPEC 內容與 Changelog。

## ADR 觸發條件

- ✅ 需要 ADR：Adapter 設計模式選擇、排程引擎選型、技術方案二選一
- ❌ 不需要 ADR：新增一個 Adapter 實作、修改重試參數、單純 bug fix

## 候選文件（Lazy Evaluation）

| 候選文件                                      | 觸發時機                     |
| --------------------------------------------- | ---------------------------- |
| `SPEC-001_pipeline-service-interface.md`      | 對外介面需正式契約時         |
| `SA-001_etl-pipeline-core-system-analysis.md` | 專案規模擴大需系統快照時     |
| `INTEGRATION.md`                              | 與主應用整合步驟需正式記錄時 |

## 文件清單

| 文件 | 路徑 | 狀態     |
| ---- | ---- | -------- |
| —    | —    | 尚無文件 |
