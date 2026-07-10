# inventory-frontend — 文件治理中心

> 本文件定義專案文件的分層規則、命名規範與維護條件。
> GenAI Agent 在處理文件相關任務時應先讀取本文件。

## SDD 文件四層分類

| 分類               | 目錄             | 命名格式                   | 觸發條件                           |
| ------------------ | ---------------- | -------------------------- | ---------------------------------- |
| SA（系統分析）     | `docs/analysis/` | `SA-{三位數}_{描述}.md`    | 里程碑或架構重大變更               |
| ADR（架構決策）    | `docs/adr/`      | `ADR-{三位數}_{描述}.md`   | 跨模組技術二選一決策               |
| SPEC（敘述型契約） | `docs/spec/`     | `SPEC-{三位數}_{描述}.md`  | 高風險介面行為或既有 SPEC 範圍變更 |
| INFRA（基礎設施）  | `docs/infra/`    | `INFRA-{三位數}_{描述}.md` | 部署拓樸或 CI 變更                 |

- 命名正規式：`^(SA|ADR|SPEC|INFRA)-\d{3}_[a-z0-9-]+\.md$`
- **彈性擴充**：前端專案可加 Components 索引

## Contract Ownership

- **Machine-verifiable contract**：BFF route 與 TypeScript definition 負責 field 與 type。
- **Narrative SPEC**：負責行為、業務規則、權限、相容性與 consumer impact。

**維護規則**：既有 BFF/API-hook SPEC 的負責行為變更時更新；高風險介面行為才新建。

## ADR 觸發條件

- ✅ 需要 ADR：狀態管理方案選型、BFF 架構設計、技術方案二選一
- ❌ 不需要 ADR：新增一個頁面元件、調整樣式、單純 bug fix

## 候選文件（Lazy Evaluation）

> 只在觸發條件成立時建立，不預建空殼。

| 候選文件                                 | 觸發時機                 |
| ---------------------------------------- | ------------------------ |
| `SPEC-001_bff-api-proxy.md`              | BFF 代理層需正式契約時   |
| `SA-001_frontend-system-architecture.md` | 專案規模擴大需系統快照時 |

## 文件清單

| 文件 | 路徑 | 狀態     |
| ---- | ---- | -------- |
| —    | —    | 尚無文件 |
