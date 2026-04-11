# AGENTS.md — inventory-frontend AI 導航指引

> 本文件是 GenAI Agent 理解 inventory-frontend 專案的首要入口。請在處理任何程式碼任務前先讀完本文件。

## 專案定位

**智慧倉儲 Web 前端** — 提供管理介面（Web SPA）與後端代理層（Express BFF），消費 inventory-api-hub REST API。

- **技術棧**：React 19 + TypeScript 5.8 + Nx 19 Monorepo + Ant Design 5
- **Alias Mapping**：`@frontend/*` 對應 `libs/frontend/*/src/`（以 `tsconfig.base.json` 為準）
- **架構**：SPA（Single Page Application）+ BFF（Backend for Frontend）雙層
- **部署**：Azure App Service（Docker 容器）
- **版本真相來源**：套件版本以 `package.json`、`nx.json`、`tsconfig.base.json` 為唯一準據

## GenAI 文件導航

| 你想做什麼                   | 先讀這裡                           |
| ---------------------------- | ---------------------------------- |
| 了解系統全貌與模組關係       | docs/analysis/SA-001               |
| 查詢元件庫有哪些元件         | docs/components/COMPONENT-INDEX.md |
| 查詢某一項架構決策的完整記錄 | docs/adr/                          |
| 了解 Nx 工作區配置           | nx.json                            |

## Nx Workspace 結構

```
inventory-frontend/
├── apps/
│   ├── frontend/          ← React 19 SPA（:3000）
│   └── backend/           ← Express BFF（:3333 dev / :3000 prod）
├── libs/
│   ├── frontend/
│   │   ├── components/    ← @frontend/components — 共用 UI 元件庫
│   │   ├── pages/         ← @frontend/pages — 頁面模組
│   │   ├── routes/        ← @frontend/routes — 路由定義與權限守衛
│   │   └── supports/      ← @frontend/supports — API hooks / Store / Theme
│   └── devkit/            ← Nx 自訂 Generator
└── types/                 ← 全域型別定義
```

## 程式碼產生規範

### API Hook 規範

- 使用 React Query (TanStack Query v5)：`useQuery()` 讀取 / `useMutation()` 寫入
- HTTP client 使用 Axios（baseURL 為 `/api`，經 BFF 代理）
- 命名格式：`{domain}-hooks.ts`

### 狀態管理

- **全域狀態**：Zustand + Immer — 只用於認證/使用者/路由等跨頁面共享
- **頁面狀態**：React Context — 各頁面的 `context.tsx`
- **伺服器狀態**：React Query — API 資料取得/快取
- 不使用 Redux、MobX 或其他狀態管理方案

### 樣式規範

- 使用 **styled-components** 撰寫元件樣式
- **不寫 inline styles**，不使用 CSS Modules

### 路由與權限

- 路由定義在 `libs/frontend/routes/src/configs/route-config.tsx`
- 受保護頁面必須配置 `permissionKeys` 陣列

## 常用開發指令

| 指令                    | 說明                                |
| ----------------------- | ----------------------------------- |
| `npx nx serve frontend` | 啟動 React SPA Dev Server (:3000)   |
| `npx nx serve backend`  | 啟動 Express BFF Dev Server (:3333) |
| `npx nx build frontend` | 建置前端                            |
| `npx nx test frontend`  | 執行前端單元測試                    |

## 關聯專案

| 專案             | 關係         | 說明                     |
| ---------------- | ------------ | ------------------------ |
| `inventory-api-hub` | API Provider | .NET 後端，提供 REST API |

## 文件維護提醒

- **PR 涉及 BFF 路由或 API hook 變更**：同步更新 `docs/spec/` 對應 SPEC 文件
- **新增或移除共用元件**：更新 `docs/components/COMPONENT-INDEX.md`
- **新增架構決策**：撰寫新 ADR
- 文件治理規則詳見 `docs/README.md`
