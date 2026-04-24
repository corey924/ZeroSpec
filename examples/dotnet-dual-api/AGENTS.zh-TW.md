# AGENTS.md — booking-backend AI 導航指引

> 本文件是 GenAI Agent 理解 booking-backend 專案的首要入口。請在處理任何程式碼任務前先讀完本文件。

## 專案定位

**大型展會預約後端系統** — 提供後台管理 API 與終端使用者 API，涵蓋劃位、付款回調、報表與營運管理。

- **技術棧**：.NET 10（C#）+ ASP.NET Core + EF Core + SQL Server + MSTest
- **架構模式**：雙 API Host（Admin / EndUser）共用 Service 層
- **Base Namespace**：`Booking.Api.Admin`、`Booking.Api.EndUser`、`Booking.Service`、`Booking.Test`（以 `Booking.sln` 為唯一結構入口）
- **部署方式**：Azure Web App（CI 由 GitHub Actions 驅動）
- **版本真相來源**：.NET SDK 以 `global.json` 為準；套件版本以各專案 `.csproj` 為準

## 快速約束

1. Controller 僅處理 HTTP request/response，不放業務邏輯
2. Controller 不可直接寫 SQL 或直接操作 DbContext
3. 不可繞過既有授權鏈路（Filter / Middleware / Policy）
4. 不可在文件中寫入真實憑證或密鑰

## 業務領域 ↔ 程式碼對照表

| 業務領域       | 主要 API Host   | 核心程式碼位置                |
| -------------- | --------------- | ----------------------------- |
| 認證與授權     | Admin + EndUser | `Controllers/`, `Middleware/` |
| 規劃與劃位營運 | EndUser + Admin | `Booking.Service/Services/`   |
| 付款與回調     | EndUser         | `Filters/`, `Services/`       |
| 報表與排程     | Admin           | `ScheduleJobs/`, `Services/`  |

## 程式碼產生規範

### 架構層級

- Controller 僅處理 HTTP request/response，不放業務邏輯
- 業務邏輯集中在 `Booking.Service/Services`
- 資料存取集中在 `Booking.Service/Repositories`

### 命名慣例

- 新增服務：`{Domain}Service`
- 新增儲存庫：`{Domain}Repository`

### 禁止事項

- 不可在 Controller 直接寫 SQL 或直接操作 DbContext
- 不可繞過既有授權鏈路（Filter / Middleware / Policy）
- 不可在文件中寫入真實憑證或密鑰

## GenAI 文件導航

| 你想做什麼                | 先讀這裡                                     |
| ------------------------- | -------------------------------------------- |
| 了解系統全貌與風險區域    | docs/analysis/SA-001_system-overview.md      |
| 查詢 API、JWT、權限、RBAC | docs/spec/SPEC-001_api-auth-and-rbac.md      |
| 查詢外部整合與背景工作    | docs/spec/SPEC-002_external-integrations.md  |
| 查詢部署與 CI/CD 設定     | docs/infra/INFRA-001_deployment-and-ci-cd.md |

## 常用開發指令

| 指令                                           | 說明              |
| ---------------------------------------------- | ----------------- |
| `dotnet build Booking.sln`                     | 建置整個 Solution |
| `dotnet test Booking.Test/Booking.Test.csproj` | 執行單元測試      |
| `dotnet run --project Booking.Api.Admin`       | 啟動後台 API      |
| `dotnet run --project Booking.Api.EndUser`     | 啟動前台 API      |

## 文件維護提醒

- **PR 涉及 API 契約或行為異動**：同步更新 `docs/spec/` 對應 SPEC 與 Changelog
- **PR 涉及架構決策**：新增或更新 `docs/adr/`
- **PR 涉及部署、CI/CD**：同步更新 `docs/infra/`
- 文件治理規則詳見 `docs/README.md`
