# ZeroSpec — SPEC Prompt Pack

> 當 **API 新增或行為變更** 時使用。將以下 Prompt 貼入 AI Agent，自動產生 SPEC 文件草稿。

---

## 觸發條件

- 新增對外 API 端點
- 修改既有 API 的 Request / Response 結構
- 變更 API 的權限需求或業務規則

---

## 使用方式

1. 確認觸發條件已滿足
2. 複製下方 Prompt 貼入 Agent
3. Agent 產出 SPEC 草稿後，審核內容並存檔至 `docs/spec/`

---

````
---BEGIN PROMPT---

請為本次 API 變更產生或更新 SPEC 文件。

## 前置條件

- `AGENTS.md` 已存在（若無，先用 INIT-SCAN + INIT-BUILD 建立）
- `docs/README.md` 已存在（若無，請先使用 INIT-BUILD 建立）

## 執行步驟

1. **讀取 AGENTS.md**：了解專案技術棧、架構層級、API 路徑慣例與權限格式
2. **讀取 docs/README.md**：確認命名正規式、SPEC 編號順序與候選文件清單
3. **掃描相關原始碼**：讀取本次變更涉及的 Controller、Service、DTO 類別
4. **讀取既有文件（若為更新）**：若判定為更新既有 SPEC，請務必先讀取該 `docs/spec/SPEC-xxx.md` 的原始內容，避免覆寫遺失既有 API 定義
5. **產出 SPEC 草稿**，格式如下：

```markdown
# SPEC-xxx: {業務領域名稱}

| 欄位     | 值                                           |
| -------- | -------------------------------------------- |
| 版本     | v0.1                                         |
| 狀態     | Draft                                        |
| 適用範圍 | （此 SPEC 涵蓋的 Controller / Service 範圍） |
| 關聯     | SA-xxx, ADR-xxx（若有）                      |

## 概述
（從程式碼推斷此領域的業務目標與 API 端點範圍）

## 介面定義
### `METHOD /api/v1/resource`
| 項目     | 說明 |
| -------- | ---- |
| 功能     | ...  |
| 權限     | ...  |
| Request  | ...  |
| Response | ...  |

## DTO 定義
（列出關鍵 DTO 類別與欄位）

## 業務規則
（從程式碼中的驗證邏輯與註解推斷）

## Changelog
| 版本 | 日期       | 變更內容 |
| ---- | ---------- | -------- |
| v0.1 | {今天日期} | 初版建立 |
```

## 規則

- 命名格式：`SPEC-{三位數}_{小寫連字號描述}.md`
- 如果是更新既有 SPEC：只修改變更的段落 + 在 Changelog 追加一列
- 版本號只寫 Major.Minor（不寫 Patch）
- DTO 欄位從實際程式碼萃取，不猜測
- 任何欄位若缺乏程式碼或設定檔證據，標註 `[待確認]`，不得猜測
- 業務規則與權限定義段落標註 `[待審核]`（需人確認邊界條件與 RBAC 一致性）

## 產出後驗證

1. 檢查文件中引用的 class / method / API 路徑是否在程式碼中真實存在
2. 確認 `docs/README.md` 的文件清單已包含新產出的 SPEC 文件
3. 若候選文件表中有對應條目，將其移至文件清單

---END PROMPT---
````
