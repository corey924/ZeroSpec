# AGENTS.md — etl-pipeline-core AI 導航指引

> 本文件是 GenAI Agent 理解 etl-pipeline-core 專案的首要入口。請在處理任何程式碼任務前先讀完本文件。

## 專案定位

**ETL 轉換核心庫** — 封裝 ETL 管線的任務排程、重試機制與多來源 Adapter 串接，以 **Python Package** 供主應用服務安裝使用。

- **技術棧**：Python 3.12 + SQLAlchemy 2.0 + APScheduler 3.10
- **Root Package**：`etl_pipeline_core`（以 `src/` 實際結構為準）
- **架構特性**：Library，無獨立 HTTP API，透過 config 初始化後注入主應用
- **對外入口**：唯一公用介面為 `PipelineService`，其餘模組均為內部實作
- **版本真相來源**：依賴版本以 `pyproject.toml` 為唯一準據

## 快速約束

1. 唯一對外介面：`PipelineService`，不可新增 HTTP 端點（不加 FastAPI / Flask route）
2. 排程邏輯（`TaskScheduler`）由本 Library 自管，不可移至消費方應用
3. 新增 Adapter 必須同步更新 `AdapterFactory` registry 與 SPEC

## 業務領域 ↔ 模組對照表

| 職責領域         | 關鍵模組 / Class                                |
| ---------------- | ----------------------------------------------- |
| **對外公用介面** | `service/pipeline_service.py`                   |
| **任務排程**     | `scheduler/task_scheduler.py`                   |
| **來源 Adapter** | `adapter/base_adapter.py`, `adapter/factory.py` |
| **重試與補償**   | `retry/retry_handler.py`, `retry/backoff.py`    |
| **資料存取**     | `repository/task_repository.py`                 |

## 程式碼產生規範

### 架構約束

- 唯一對外介面是 `PipelineService`，不新增 HTTP 端點
- 排程邏輯由本 Library 自管，不委派至消費方應用
- 新增 Adapter 必須更新 `AdapterFactory` 的 registry 與 SPEC 說明

### 型別與風格

- 使用 Python Type Hints (PEP 484) 標註所有 public function / method 的參數與回傳值
- 使用 Pydantic v2 定義 DTO / Config model
- 遵循 Ruff 進行 Linter 檢查與程式碼格式化

### 介面異動規則

- 修改 `PipelineService` 任何 public method 簽章，**同一 PR 必須更新** SPEC Changelog

## GenAI 文件導航

| 你想做什麼             | 先讀這裡                              |
| ---------------------- | ------------------------------------- |
| 了解系統全貌與元件職責 | docs/analysis/SA-001                  |
| 查詢對外介面契約       | docs/spec/SPEC-001（Source of Truth） |
| 了解與主應用整合步驟   | docs/INTEGRATION.md                   |

## 常用開發指令

| 指令               | 說明                  |
| ------------------ | --------------------- |
| `make test`        | 執行測試（pytest）    |
| `make lint`        | Ruff 格式化與靜態分析 |
| `pip install -e .` | 本地開發安裝          |
| `make build`       | 建置套件              |

## 關聯專案

| 專案       | 關係           | 說明                            |
| ---------- | -------------- | ------------------------------- |
| `main-api` | Package 消費方 | 透過 pip install 引入本 Library |

## 文件維護提醒

- **PR 涉及 `PipelineService` 介面異動**：同步更新 SPEC Changelog
- **PR 涉及整合步驟變更**：更新 `docs/INTEGRATION.md`
- **新增架構決策**：撰寫新 ADR
- 文件治理規則詳見 `docs/README.md`

## 完成前自我檢查（Post-Edit Self-Check）

宣告任務完成前，必須：
1. 列出本次 diff 涉及的所有異動檔案。
2. 對照上方「程式碼 → 文件對照表」（Code-to-Docs Map），找出每份候選文件。
3. 對每份候選文件回答：`需要更新` 或 `不需要更新（原因）`。
4. 套用 Contract Ownership：需要時更新既有範圍的敘事 SPEC；否則說明 machine contract 或不更新文件已足夠的理由。
5. 執行 `make test` 與 `make lint` 確認無回歸錯誤。

**強制輸出（Forcing Function）**：AI agent 在任何含程式碼異動的回覆末尾，必須附上 `### Docs Impact` 區塊，列出：(a) 受影響的 `docs/spec/` 檔案及更新狀態；(b) 不需要更新時的說明理由。
