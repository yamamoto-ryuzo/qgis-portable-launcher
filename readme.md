### QGISランチャー
<<<<<<< HEAD
（今後の予定）  
　32ビット最終版の対応  
  起動用BATのネットワークドライブへの対応（無理かも・・・）  
　QGISファイルの解凍失敗に対する対応！（解凍終了後にフラグ用のファイルを設置？）  

（現状）  
　QGISポータブル版を私の趣味によりカスタマイズしたバージョン管理やインストールを含んだランチャー  
　WindowsのDOS.BATです。  
　　QGIS.BAT -----------------　ランチャー本体  
　　QGIS.CFG.BAT -------------　設定ファイル  
　　QGIS_client.cfg ----------　ＱＧＩＳを起動する場合  
　　QGIS_delivery_server.cfg -　配信サーバーとして動作する場合  
　　QGIS_internet.cfg --------　インターネットに接続する場合  
　　QGIS_plugin.txt-----------　追加プラグインZIPファイルアドレス  
　　/QGIS_portable_repository-　QGIS本体を保存するフォルダ  
　　/plugin-------------------　プラグイン本体を保存するフォルダ  
　　/qgisconfig---------------　各種共通設定ファイルを保存するフォルダ  
　を同じフォルダに設置してください。   
　　c:\に権限が必要です。  
#### ・起動モードの変更方法  
起動後，１秒位以内に下記キー押してください。  
　c:クライアントモード　　ﾃﾞﾌｫﾙﾄ設定  
　s:サーバーモード  
#### ・統一環境としてコアプラグインに組み込み予定のプラグイン  
##### 検索  
　　https://github.com/NationalSecurityAgency/qgis-searchlayers-plugin  
　　https://github.com/yamamoto-ryuzo/GEO-search-plugin  
##### 印刷  
　　https://github.com/yamamoto-ryuzo/yr-qgis-easyinstantprint-plugin  
　　https://github.com/sourcepole/qgis-instantprint-plugin  
　　https://github.com/Orbitalnet-incs/meshprint  
##### レイヤー管理   
　　https://github.com/xcaeag/MenuFromProject-Qgis-Plugin  
##### 画面
　　https://raw.githubusercontent.com/yamamoto-ryuzo/yr-qgis-portable-launcher-repository/main/zoomview-1.1.1.zip  
##### エクセル連携
　　https://github.com/opengisch/qgis_excel_sync  
##### その他
　　https://github.com/MIERUNE/qgis-mojxml-plugin  
　　https://github.com/Orbitalnet-incs/EasyAttributeFilter  
　　https://github.com/Orbitalnet-incs/SearchZmap  
　　
#### ・補足事項  
　.BATの改行コードをWindows用にするため　.gitattributes　を設置 
