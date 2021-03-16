# Swift-BetLead-Sport-temp
# 體育競賽用<br />
| 日 期 | 項 目 | 內 容 |
| :-----| :------ | :---- |
| 20190820 | Feature | 主框架<br/>首頁UI呈現<br/>賽事UI呈現<br/>偏好設定UI呈現<br/>BetLead小球UI呈現 |
| 20190827 | Bug fix | 修正登入登出內部邏輯異常 |
| 20190827 | Feature | 添加LiveChat SDK<br/>添加內部跳轉Deep Link 等基礎框架<br/> 底部模組優化<br/>導航欄優化<br/>API串接調適<br/>關注UI邏輯調整<br/>投注卡片UI調整<br/>|
| 20190903 | Feature | 1. 重構注單購物車(頁面上的+1)功能<br/>2. 串接滾球api 以及每五秒刷新功能<br/>3. 滾球UI建置<br/>4. 調整注單母版<br/>5. 重構注單(因為注單API變動)  <br/>6. 添加app icon <br/>7. Domain 改為stage|
| 20190910 | Feature | 1. 重構基本ＵＩ模組<br/>2. 修正API參數不合的issue<br/>3. 重構串關選項模組<br/>4. 添加handicap 項目相關參數及邏輯條件<br/>5. 投注功能UI(API邏輯待確認) |
| 20190924 | 調整 | 1. 套用新首頁樣式-今日/早盤 功能完成 -中間section 滾球/今日/早盤 功能完成 -tabbar 背景色以及按鈕顏色調整<br/>2. 我的頁面調整 -展開功能移除<br/>3. 登入頁面改為跟Betlead全站一樣的Banner動畫 |
| 20191001 | 調整 | 1. [臉部與指紋辨識]功能開啟後，若自安全中心登出帳戶再登入時，無法使用touch ID登入 -指紋辨識時機,只要打開該功能,則進入登入畫面便會主通詢問是否需要指紋辨識登入 |
| 20191001 | feature | 1. 新增“維修中” 畫面 , error execption 9100<br/>2. 新增“存提維修中” 畫面 , error execption 9200<br/>3. 新增“體育維修中” 畫面 , error execption 9300 |
| 20191008 | feature | 1. 於270秒之後 relaunch<br/>2. Token 過期自動檢查並且重新索要 |
| 20191008 | 調整 | 1. 程式優化 - 於KeyChain儲存 JWT token - 關閉iOS 13 夜間模式,為換皮新功能鋪路 - ios pod 調整 |


![betlead-sport-part1](https://user-images.githubusercontent.com/8057425/111319231-bb49d700-86a0-11eb-81b2-cc5abf77655e.gif)
![betlead-sport-part2](https://user-images.githubusercontent.com/8057425/111319248-c0a72180-86a0-11eb-8e47-c1ad1c84a001.gif)
