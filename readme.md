### QGISランチャー（とりあえず作成中）  
　現在のバージョンver0.2  
　QGISポータブル版を私の趣味によりカスタマイズしたバージョン管理やインストールを含んだランチャー  
　WindowsのDOS.BATです。  
　　QGIS.BAT -----------------　ランチャー本体  
　　QGIS.CFG.BAT -------------　設定ファイル  
　　QGIS_client.cfg ----------　ＱＧＩＳを起動する場合  
　　QGIS_delivery_server.cfg -　配信サーバーとして動作する場合  
　　QGIS_internet.cfg --------　インターネットに接続する場合  
　を同じフォルダに設置してください。   
　　c:\に権限が必要です。  
#### ・QGISポータブル版の入手先  
QGIS.CFG.BAT で設定  
　site = 1  
　　https://github.com/pigreco/QGIS_portable_3x  
　site = 2  
　　http://kouapp.main.jp/ringyoqgis3/qgisportable/
#### ・統一環境としてコアプラグインに組み込み予定のプラグイン  
##### 検索  
　（設定中）https://github.com/yamamoto-ryuzo/yr-qgis-searchlayers-plugin  
　（設定中）https://github.com/yamamoto-ryuzo/GEO-search-plugin  
##### 印刷  
　（設定中）https://github.com/yamamoto-ryuzo/yr-qgis-easyinstantprint-plugin  
#### ・補足事項  
　.BATの改行コードをWindows用にするため　.gitattributes　を設置  
