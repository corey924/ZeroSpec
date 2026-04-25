# Contributing to ZeroSpec

> **🌐 [English](CONTRIBUTING.md)**

感謝你願意幫忙改進 ZeroSpec。

本專案的目標很明確：**用最小維護成本，提供 AI 可讀、可持續運作的文件基線**。因此所有貢獻都請優先考慮以下原則：

- 保持簡潔，不為了完整性引入過重流程
- 優先提升可讀性、可維護性與跨代理穩定性
- 避免增加不必要的檔案、設定或重複說明
- 文件、Prompt、模板與驗收規則要彼此一致

## 歡迎的貢獻方向

- 修正 Prompt 歧義、矛盾或容易造成誤判的描述
- 補強 README、GUIDE、DAILY-USAGE 與 examples 的一致性
- 補強驗收腳本，讓錯誤更早被發現
- 改善跨代理相容性、Markdown 穩定性與 Token 效率
- 新增經過驗證的範例或實務使用情境

## 暫不建議的方向

- 為了理論完整性而大幅擴張流程
- 引入需要額外安裝的 CLI、框架或 runtime
- 預先建立大量未使用的空殼文件
- 把專案改成高度依賴單一 AI 平台的寫法

## 提交 PR 前請先確認

1. 你的變更有明確解決一個問題，或讓既有內容更清楚、更穩定
2. 若修改 `prompts/`、`templates/`、`scripts/` 或 `examples/`，已同步檢查 `README.md`、`GUIDE.md`、`DAILY-USAGE.md`、`CHANGELOG.md` 是否需要更新
3. 若修改驗收規則，已先執行：`bash scripts/verify-zerospec.sh`
4. 若新增公開治理慣例，已補到文件或範例，而不是只留在 PR 討論裡
5. PR 範圍盡量單一，避免把多種性質的修改混在同一個 PR

## PR 撰寫建議

提交 PR 時，GitHub 會自動帶出 PR Template，請依欄位填寫即可。

## 建議的 PR 類型

- `docs:` 文件導覽、說明、教學、命名調整
- `prompts:` Prompt 結構、規則、語意修正
- `templates:` 模板欄位或格式修正
- `scripts:` 驗收腳本與 CI 補強
- `examples:` 範例內容更新

## 審查偏好

- 小而明確的 PR，通常比大而全的 PR 更容易合併
- 如果是規則異動，請附上「為什麼這樣改比較穩定」
- 如果是內容刪減，請說明刪掉後是否仍保留必要資訊

## 討論規範

請用專業、尊重、可協作的方式討論。對內容有不同看法時，優先以可驗證的案例、實際使用經驗與維護成本作為判斷依據。

社群互動行為期待請見 [CODE_OF_CONDUCT.zh-TW.md](CODE_OF_CONDUCT.zh-TW.md)。
