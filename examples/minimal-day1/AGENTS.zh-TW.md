# AGENTS.md — taskflow-api AI 導航指引

> 本文件是 GenAI Agent 理解 taskflow-api 專案的首要入口。請在處理任何程式碼任務前先讀完本文件。

## 專案定位

**任務排程管理 API** — 提供任務建立、排程、執行追蹤的後端 REST API。

- **技術棧**：.NET 10（C#）+ ASP.NET Core + EF Core + PostgreSQL 16
- **Base Namespace**：`TaskFlow.Api`、`TaskFlow.Service`（以 Solution 結構為準）
- **架構模式**：Clean Architecture（Controller → Service → Repository）
- **部署方式**：Docker Compose（本地）/ Azure App Service（生產）
- **版本真相來源**：.NET SDK 以 `global.json` 為準；套件版本以各專案 `.csproj` 為準

## 快速約束

1. Controller 僅處理 HTTP request/response，不放業務邏輯
2. Controller 不可直接操作 DbContext
3. API 路徑格式：`/api/v1/{resource}`

## 領域/模組 ↔ 程式碼對照表

| 業務領域 | Controller           | 核心 Service       |
| -------- | -------------------- | ------------------ |
| 認證     | `AuthController`     | `IAuthService`     |
| 任務管理 | `TaskController`     | `ITaskService`     |
| 排程     | `ScheduleController` | `IScheduleService` |

## 程式碼產生規範

### 架構層級

- Controller 僅處理 HTTP request/response，不放業務邏輯
- 業務邏輯集中在 `TaskFlow.Service/Services`
- 資料存取集中在 `TaskFlow.Service/Repositories`

### 路由慣例

- API 路徑格式：`/api/v1/{resource}`

### 禁止事項

- 不可在 Controller 直接操作 DbContext
- 不可在文件中寫入真實憑證或密鑰

## GenAI 文件導航

| 你想做什麼       | 先讀這裡       |
| ---------------- | -------------- |
| 了解文件治理規則 | docs/README.md |

## 常用開發指令

| 指令                                | 說明              |
| ----------------------------------- | ----------------- |
| `dotnet build TaskFlow.sln`         | 建置整個 Solution |
| `dotnet test TaskFlow.Test`         | 執行單元測試      |
| `dotnet run --project TaskFlow.Api` | 啟動 API 服務     |

## 文件維護提醒

- **PR 涉及 API 契約或行為異動**：同步更新 `docs/spec/` 對應 SPEC 與 Changelog
- **PR 涉及架構決策**：新增 `docs/adr/` 對應 ADR
- 文件治理規則詳見 `docs/README.md`
