# edge-comm-core — 文件治理中心

> 本文件定義專案文件的分層規則、命名規範與維護條件。
> GenAI Agent 在處理文件相關任務時應先讀取本文件。

## SDD 文件四層分類

| 分類               | 目錄             | 命名格式                   | 觸發條件                           |
| ------------------ | ---------------- | -------------------------- | ---------------------------------- |
| SA（系統分析）     | `docs/analysis/` | `SA-{三位數}_{描述}.md`    | 里程碑或架構重大變更               |
| ADR（架構決策）    | `docs/adr/`      | `ADR-{三位數}_{描述}.md`   | 跨模組技術二選一決策               |
| SPEC（敘述型契約） | `docs/spec/`     | `SPEC-{三位數}_{描述}.md`  | 高風險公開行為或既有 SPEC 範圍變更 |
| INFRA（基礎設施）  | `docs/infra/`    | `INFRA-{三位數}_{描述}.md` | 部署拓樸或 CI 變更                 |

- 命名正規式：`^(SA|ADR|SPEC|INFRA)-\d{3}_[a-z0-9-]+\.md$`
- **彈性擴充**：Library 專案可用 INTEGRATION 取代 INFRA

## Contract Ownership

- **Machine-verifiable contract**：Java public signature 負責 field 與 type。
- **Narrative SPEC**：負責行為、業務規則、權限、相容性與 consumer impact。

**最低維護規則**：凡 PR 涉及 `CommunicationCoreService` 介面異動，必須同步更新 SPEC 內容與 Changelog。

## ADR 觸發條件

- ✅ 需要 ADR：架構分層策略選型、Adapter 設計模式選擇、技術方案二選一
- ❌ 不需要 ADR：新增一個 Adapter 實作、修改逾時參數、單純 bug fix

## 候選文件（Lazy Evaluation）

> 只在觸發條件成立時建立，不預建空殼。

| 候選文件                                           | 觸發時機                     |
| -------------------------------------------------- | ---------------------------- |
| `SPEC-001_communication-core-service-interface.md` | 對外介面需正式契約時         |
| `SA-001_communication-core-system-analysis.md`     | 專案規模擴大需系統快照時     |
| `INTEGRATION.md`                                   | 與主後端整合步驟需正式記錄時 |

## 文件清單

| 文件                                             | 路徑                                                  | 狀態   |
| ------------------------------------------------ | ----------------------------------------------------- | ------ |
| SPEC-001_communication-core-service-interface.md | spec/SPEC-001_communication-core-service-interface.md | 啟用中 |
