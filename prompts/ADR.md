# ZeroSpec — ADR Prompt Pack

> 當 **跨模組技術二選一決策** 發生時使用。將以下 Prompt 貼入 AI Agent，自動產生 ADR 文件草稿。

---

## 觸發條件

- 架構分層策略選型（如 Clean Architecture vs Hexagonal）
- 技術方案二選一（如 Kafka vs Event Hubs、JWT vs Session）
- 跨模組共用元件的設計決策
- 基礎設施選型（如 PostgreSQL vs MySQL、Redis vs Memcached）

## 不觸發（不需要 ADR）

- 新增一支 CRUD API
- 修改 Redis TTL 預設值
- 單純的 bug fix

---

## 使用方式

1. 確認觸發條件已滿足
2. 複製下方 Prompt 貼入 Agent
3. Agent 產出 ADR 草稿後，審核內容並存檔至 `docs/adr/`

---

````
---BEGIN PROMPT---

請為本次技術決策產生 ADR 文件。

## 前置條件

- `AGENTS.md` 已存在（若無，先用 INIT-SCAN + INIT-BUILD 建立）
- `docs/README.md` 已存在（若無，請先使用 INIT-BUILD 建立）

## 執行步驟

1. **讀取 AGENTS.md**：了解專案技術棧與架構約束
2. **讀取 docs/README.md**：確認命名正規式與 ADR 編號順序
3. **讀取既有 ADR**：掃描 docs/adr/ 確認編號順序與既有決策脈絡
4. **與我確認**：
   - 這次的決策背景是什麼？（先引用可驗證證據；若資訊不足，標註 `[待確認]` 再詢問）
   - 有哪些選項？（至少列出 2 個）
   - 最終選了哪個？為什麼？
5. **產出 ADR 草稿**，格式如下：

```markdown
# ADR-xxx: {決策標題}

| 欄位     | 值                                |
| -------- | --------------------------------- |
| 決策日期 | {今天日期}                        |
| 狀態     | Accepted                          |
| 關聯     | SA-xxx, ADR-yyy, SPEC-xxx（若有） |
| 影響範圍 | （受影響的模組或領域）            |

## 背景
（從對話脈絡與程式碼推斷，標註 [待審核]）

## 考慮選項

### 選項 A — {名稱}
- 優點：...
- 缺點：...

### 選項 B — {名稱}
- 優點：...
- 缺點：...

## 決策
選擇選項 X，理由是...

## 後果
- 正面影響：...
- 負面影響 / 風險：...
- 後續行動：...
```

## 規則

- 命名格式：`ADR-{三位數}_{小寫連字號描述}.md`
- ADR 只能 Append 或 Supersede（新 ADR 標註 `Superseded by ADR-yyy`），不可修改已接受的內容
- 編號從既有 ADR 的最大值 +1 開始
- 若無可驗證證據，不補寫背景細節，統一標註 `[待確認]`

## 產出後驗證

1. 檢查文件中引用的模組、元件名稱是否在程式碼中真實存在
2. 確認 `docs/README.md` 的文件清單已包含新產出的 ADR 文件
3. 若候選文件表中有對應條目，將其移至文件清單

---END PROMPT---
````
