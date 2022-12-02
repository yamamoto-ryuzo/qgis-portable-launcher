### QGISランチャー
<<<<<<< HEAD
（現状）  
　QGISポータブル版を私の趣味によりカスタマイズしたバージョン管理やインストールを含んだランチャー  
　WindowsのDOS.BATです。  
　　QGIS.BAT -----------------　ランチャー本体  
　　QGIS.CFG.BAT -------------　設定ファイル  
　　QGIS_client.cfg ----------　ＱＧＩＳを起動する場合  
　　QGIS_delivery_server.cfg -　配信サーバーとして動作する場合  
　　QGIS_internet.cfg --------　インターネットに接続する場合  
　　QGIS_plugin.txt-----------　追加コアプラグインZIPファイルアドレス  
　を同じフォルダに設置してください。   
　　c:\に権限が必要です。  
#### ・起動モードの変更方法  
起動後，１秒位以内に下記キー押してください。  
　c:クライアントモード　　ﾃﾞﾌｫﾙﾄ設定  
　s:サーバーモード  
　n:site=1 pigreco 本家（最新版）  
　o:site=2 pigreco 本家（旧版）
#### ・統一環境としてコアプラグインに組み込み予定のプラグイン  
##### 検索  
　　https://github.com/yamamoto-ryuzo/yr-qgis-searchlayers-plugin  
　　https://github.com/yamamoto-ryuzo/GEO-search-plugin  
##### 印刷  
　　https://github.com/yamamoto-ryuzo/yr-qgis-easyinstantprint-plugin  
　　https://github.com/yamamoto-ryuzo/yr-qgis-portable-launcher-repository/raw/main/qgis-instantprint-plugin-master.zip  
##### レイヤー管理（追加予定：日本語化依頼2022-08-28）  
　　https://github.com/xcaeag/MenuFromProject-Qgis-Plugin  
##### 画面
　　https://raw.githubusercontent.com/yamamoto-ryuzo/yr-qgis-portable-launcher-repository/main/zoomview-1.1.1.zip  
#### ・補足事項  
　.BATの改行コードをWindows用にするため　.gitattributes　を設置 
