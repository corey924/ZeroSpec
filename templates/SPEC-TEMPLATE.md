# SPEC-xxx: 標題（業務領域名稱）

> 複製本模板並依序編號，例如 `SPEC-001_auth-and-rbac.md`。
> 命名正規式：`^SPEC-\d{3}_[a-z0-9-]+\.md$`

| 欄位     | 值                                           |
| -------- | -------------------------------------------- |
| 版本     | v0.1                                         |
| 狀態     | Draft / Active / Deprecated                  |
| 適用範圍 | （此 SPEC 涵蓋的 Controller / Service 範圍） |
| 關聯     | SA-xxx, ADR-xxx                              |

## 概述

說明此領域的業務目標與 API 端點範圍。

## 介面定義

### `METHOD /api/v1/resource`

| 項目     | 說明                                  |
| -------- | ------------------------------------- |
| 功能     | ...                                   |
| 權限     | `RESOURCE_READ`（依專案權限格式標註） |
| Request  | ...                                   |
| Response | ...                                   |

（依序列出此領域所有 API 端點）

## DTO 定義

| DTO 名稱 | 用途 | 關鍵欄位 | 型別 | 備註 |
| -------- | ---- | -------- | ---- | ---- |
| ...      | ...  | ...      | ...  | ...  |

> 可依專案技術棧替換為實際程式碼範例（如 C# record、Java Record、TypeScript interface、Python dataclass 等）。

## 狀態機（選用）

如果此領域包含狀態流轉（如 Job 狀態、訂單狀態），以 Mermaid 圖描述。

```mermaid
stateDiagram-v2
    [*] --> Created
    Created --> Active
    Active --> Completed
```

## 業務規則

列出此領域的關鍵業務規則與驗證邏輯。

## Changelog

| 版本 | 日期       | 變更內容 |
| ---- | ---------- | -------- |
| v0.1 | YYYY-MM-DD | 初版建立 |
