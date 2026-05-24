# AGENTS.md — edge-comm-core AI 導航指引

> 本文件是 GenAI Agent 理解 edge-comm-core 專案的首要入口。請在處理任何程式碼任務前先讀完本文件。

## 專案定位

**邊緣設備通訊核心庫** — 封裝自動化倉儲設備的指令派送、Job 生命週期管理（輪詢、重試、逾時補償）與廠商 Adapter 串接，以 **Library JAR** 方式注入主後端服務。

- **技術棧**：Java 21 + Spring Boot 3.5 + Gradle 8.14 + PostgreSQL 16（共用主後端同一 DB）
- **Base Package**：`com.example.communication`（以 `src/main/java` 實際結構為準）
- **架構特性**：Library，無獨立 HTTP API，透過 Spring AutoConfiguration 整合
- **對外入口**：唯一公用介面為 `CommunicationCoreService`，其餘 class 均為內部實作
- **版本真相來源**：依賴與 plugin 版本以 `build.gradle` 為唯一準據

## 快速約束

1. 唯一對外介面：`CommunicationCoreService`，不可新增 REST Controller
2. 排程邏輯（`JobTimeoutScanner`、`JobRetryScheduler`）由本 Library 自管，不可移至消費方專案
3. 新增廠商 Adapter 必須同步更新 `AdapterFactory` registry 與 SPEC

## 業務領域 ↔ Java Package 對照表

| 職責領域              | 關鍵 Package / Class                                         |
| --------------------- | ------------------------------------------------------------ |
| **對外公用介面**      | `service/CommunicationCoreService`                           |
| **指令派送**          | `dispatcher/CommandDispatcher`                               |
| **廠商 Adapter 串接** | `adapter/VendorAdapter`, `adapter/AdapterFactory`            |
| **Job 生命週期排程**  | `scheduler/JobTimeoutScanner`, `scheduler/JobRetryScheduler` |
| **回調處理**          | `callback/JobCompletionHandler`                              |
| **資料存取**          | `repository/JobRepository`, `repository/DeviceRepository`    |

## 程式碼產生規範

### 架構約束

- 唯一對外介面是 `CommunicationCoreService`，不新增 REST Controller
- 排程邏輯由本 Library 自管，不委派至消費方專案
- 新增廠商 Adapter 必須更新 `AdapterFactory` 的 registry 與 SPEC 介面說明

### 介面異動規則

- 修改 `CommunicationCoreService` 任何 public method 簽章，**同一 PR 必須更新** SPEC Changelog

## GenAI 文件導航

| 你想做什麼             | 先讀這裡                              |
| ---------------------- | ------------------------------------- |
| 了解系統全貌與元件職責 | docs/analysis/SA-001                  |
| 查詢對外介面契約       | docs/spec/SPEC-001（Source of Truth） |
| 了解與主後端整合步驟   | docs/INTEGRATION.md                   |

## 常用開發指令

| 指令                            | 說明             |
| ------------------------------- | ---------------- |
| `./gradlew build`               | 建置並執行測試   |
| `./gradlew test`                | 僅執行測試       |
| `./gradlew publishToMavenLocal` | 發布至本地 Maven |

## 關聯專案

| 專案                | 關係           | 說明                               |
| ------------------- | -------------- | ---------------------------------- |
| `logistics-api-hub` | Library 消費方 | 透過 Gradle 本地依賴引入本 Library |

## 文件維護提醒

- **PR 涉及 `CommunicationCoreService` 介面異動**：同步更新 SPEC Changelog
- **PR 涉及整合步驟變更**：更新 `docs/INTEGRATION.md`
- **新增架構決策**：撰寫新 ADR
- 文件治理規則詳見 `docs/README.md`

## 完成前自我檢查（Post-Edit Self-Check）

宣告任務完成前，必須：
1. 列出本次 diff 涉及的所有異動檔案。
2. 對照上方「程式碼 → 文件對照表」（Code-to-Docs Map），找出每份候選文件。
3. 對每份候選文件回答：`需要更新` 或 `不需要更新（原因）`。
4. 若介面、schema、Permission 或 Business Rule 有異動，更新對應 SPEC。
5. 執行 `./gradlew build` 確認無回歸錯誤。

**強制輸出（Forcing Function）**：AI agent 在任何含程式碼異動的回覆末尾，必須附上 `### Docs Impact` 區塊，列出：(a) 受影響的 `docs/spec/` 檔案及更新狀態；(b) 不需要更新時的說明理由。
