### QGISランチャー
<<<<<<< HEAD
（今後の予定）  
　32ビット最終版の対応  
  起動用BATのネットワークドライブへの対応（無理かも・・・）  
　QGISファイルの解凍失敗に対する対応！（解凍終了後にフラグ用のファイルを設置？）  
=======
（ただいまLGWAN内で作業中）  
　PCの状況によって動いたり動かなかったり結構いろいろ・・・  
　設定を簡素化のため　pigreco 本家　のみとなる予定  
　バージョンアップによりプロジェクトファイルが動かないことがあるので、最新バージョンと旧バージョンを切り替え可能とする予定。  
 
（32ビット対応）  
　3.16と3.22の混在して利用してもいいことなしだったので、32ビットはさようならにしました。  
　32ビットマシンは64ビットマシンへの　RDS - remoteApp　で対応が良いようです。  
>>>>>>> 13f7b14e049d1220bf8cbd0ddbb8963068a9a329
 
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
　p:site=1 pigreco 本家　ﾃﾞﾌｫﾙﾄ設定  
　k:site=2 kouapp　喜多さんのサイト  
#### ・QGISポータブル版の入手先  
QGIS.CFG.BAT で設定  
　site = 1  
　　https://github.com/pigreco/QGIS_portable_3x  
　site = 2  
　　http://kouapp.main.jp/ringyoqgis3/qgisportable/
#### ・統一環境としてコアプラグインに組み込み予定のプラグイン  
##### 検索  
　　https://github.com/yamamoto-ryuzo/yr-qgis-searchlayers-plugin  
　　https://github.com/yamamoto-ryuzo/GEO-search-plugin  
##### 印刷  
　　https://github.com/yamamoto-ryuzo/yr-qgis-easyinstantprint-plugin  
##### レイヤー管理（追加予定：日本語化依頼2022-08-28）  
　　https://github.com/xcaeag/MenuFromProject-Qgis-Plugin  
#### ・補足事項  
　.BATの改行コードをWindows用にするため　.gitattributes　を設置 
