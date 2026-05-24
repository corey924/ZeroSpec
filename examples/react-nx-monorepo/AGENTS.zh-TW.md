# AGENTS.md — inventory-frontend AI 導航指引

> 本文件是 GenAI Agent 理解 inventory-frontend 專案的首要入口。請在處理任何程式碼任務前先讀完本文件。

## 專案定位

**智慧倉儲 Web 前端** — 提供管理介面（Web SPA）與後端代理層（Express BFF），消費 inventory-api-hub REST API。

- **技術棧**：React 19 + TypeScript 5.8 + Nx 19 Monorepo + Ant Design 5
- **Alias Mapping**：`@frontend/*` 對應 `libs/frontend/*/src/`（以 `tsconfig.base.json` 為準）
- **架構**：SPA（Single Page Application）+ BFF（Backend for Frontend）雙層
- **部署**：Azure App Service（Docker 容器）
- **版本真相來源**：套件版本以 `package.json`、`nx.json`、`tsconfig.base.json` 為唯一準據

## 快速約束

1. 狀態管理：Zustand（全域）/ React Context（頁面）/ React Query（伺服器狀態）— 不用 Redux 或 MobX
2. 樣式：僅用 styled-components — 不寫 inline styles，不用 CSS Modules
3. 受保護頁面必須配置 `permissionKeys`

## 業務頁面 ↔ 程式碼對照表

| 業務領域 | 頁面模組               | API Hooks            |
| -------- | ---------------------- | -------------------- |
| 認證     | `auth/`                | `auth-hooks.ts`      |
| 庫存管理 | `inventory-mngt-page/` | `inventory-hooks.ts` |
| 設備管理 | `device-mngt-page/`    | `device-hooks.ts`    |
| 報表     | `report-page/`         | `report-hooks.ts`    |

## Nx Workspace 結構

```
inventory-frontend/
├── apps/
│   ├── frontend/       ← React 19 SPA（:3000）
│   └── backend/        ← Express BFF（:3333 dev / :3000 prod）
├── libs/
│   ├── frontend/
│   │   ├── components/ ← @frontend/components
│   │   ├── pages/      ← @frontend/pages
│   │   ├── routes/     ← @frontend/routes
│   │   └── supports/   ← @frontend/supports
│   └── devkit/         ← Nx 自訂 Generator
└── types/              ← 全域型別定義
```

## 程式碼產生規範

### API Hook 規範

- 使用 React Query v5：`useQuery()` 讀取 / `useMutation()` 寫入
- HTTP client 使用 Axios（baseURL 為 `/api`，經 BFF 代理）
- 命名格式：`{domain}-hooks.ts`

### 狀態管理

- **全域狀態**：Zustand + Immer — 只用於認證/使用者/路由等跨頁面共享
- **頁面狀態**：React Context — 各頁面的 `context.tsx`
- **伺服器狀態**：React Query — API 資料取得/快取
- 不使用 Redux、MobX 或其他狀態管理方案

### 樣式規範

- 使用 styled-components 撰寫元件樣式
- 不寫 inline styles，不使用 CSS Modules

### 路由與權限

- 路由定義在 `libs/frontend/routes/src/configs/route-config.tsx`
- 受保護頁面必須配置 `permissionKeys` 陣列

## GenAI 文件導航

| 你想做什麼                   | 先讀這裡                           |
| ---------------------------- | ---------------------------------- |
| 了解系統全貌與模組關係       | docs/analysis/SA-001               |
| 查詢元件庫有哪些元件         | docs/components/COMPONENT-INDEX.md |
| 查詢某一項架構決策的完整記錄 | docs/adr/                          |
| 了解 Nx 工作區配置           | nx.json                            |

## 常用開發指令

| 指令                    | 說明                              |
| ----------------------- | --------------------------------- |
| `npx nx serve frontend` | 啟動 React SPA Dev Server (:3000) |
| `npx nx serve backend`  | 啟動 Express BFF (:3333)          |
| `npx nx build frontend` | 建置前端                          |
| `npx nx test frontend`  | 執行前端單元測試                  |

## 關聯專案

| 專案                | 關係         | 說明                     |
| ------------------- | ------------ | ------------------------ |
| `inventory-api-hub` | API Provider | .NET 後端，提供 REST API |

## 文件維護提醒

- **PR 涉及 BFF 路由或 API hook 變更**：同步更新 `docs/spec/` 對應 SPEC
- **新增或移除共用元件**：更新 `docs/components/COMPONENT-INDEX.md`
- **新增架構決策**：撰寫新 ADR
- 文件治理規則詳見 `docs/README.md`

## 完成前自我檢查（Post-Edit Self-Check）

宣告任務完成前，必須：
1. 列出本次 diff 涉及的所有異動檔案。
2. 對照上方「程式碼 → 文件對照表」（Code-to-Docs Map），找出每份候選文件。
3. 對每份候選文件回答：`需要更新` 或 `不需要更新（原因）`。
4. 若介面、schema、Permission 或 Business Rule 有異動，更新對應 SPEC。
5. 執行 `npx nx affected --target=test` 確認無回歸錯誤。

**強制輸出（Forcing Function）**：AI agent 在任何含程式碼異動的回覆末尾，必須附上 `### Docs Impact` 區塊，列出：(a) 受影響的 `docs/spec/` 檔案及更新狀態；(b) 不需要更新時的說明理由。
