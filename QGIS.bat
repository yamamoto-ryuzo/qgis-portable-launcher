rem @echo off
chcp 65001
rem "↑　文字コードの指定　UTF-8＝65001"

rem "ネットワークドライブ対応の起動フォルダ指定"
rem "ドライブ指定の権限必要か?"
pushd %~dp0

rem "見本後は必ず「””」で囲む"
rem "遅延展開する変数の記述方法を「%変数名%」から「!変数名!」に変更"
rem "for を利用時には必ず必要"
setlocal enabledelayedexpansion
goto :start

rem "====================環境設定===================="
rem "注意事項"
rem "変数の代入の=の前後に空白を入れないこと！"
rem "起動フォルダをカレントフォルダに設定"
rem "カレントフォルダがネットワークフォルダに非対応なので注意！"

:start
rem "==========環境変数の設定=========="
rem "初期設定"

rem "初期変数の読込"
for /f "tokens=1,2 delims==" %%a in (QGIS_custum.ini) do (
  set %%a=%%b
  rem "なぜか最初の１行は；をコメント認識してくれないので注意！"
  rem msg %username%  %%a,%%b
)
  rem msg %username%  %QGIS_delivery%,%QGIS_Install%,%QGIS_delivery_client%

rem "=====モードセレクト"
rem "c:クライアントモード　　ﾃﾞﾌｫﾙﾄ設定"
rem "s:サーバーモード"
rem "n:site=1 pigreco 本家（最新版）"
rem "o:site=2 pigreco 本家（旧版）"
rem "/t 1秒"
rem "/D c ﾃﾞﾌｫﾙﾄ設定"
choice /c csno /t 1 /D c /n

set selection=0
if %errorlevel% equ 1 (
    rem "ﾃﾞﾌｫﾙﾄ"
    goto :client_mode
) else if  %errorlevel% equ 2 (
    rem "配信用環境設定構築時"
    msg %username% サーバーモードで動作します。 
    goto :server_mode
) else if  %errorlevel% equ 3 (
    rem site=1　を選択
    echo 1 > QGIS_site.txt
    msg %username% QGISポータブル版をpigreco（最新版）に設定しました。
    goto :client_mode
) else if  %errorlevel% equ 4 (
    rem site=2　を選択
    echo 2 > QGIS_site.txt
    msg %username% QGISポータブル版をpigreco（旧版）に設定しました。
    goto :client_mode
) else (
    goto :client_mode
)

:server_mode
call :config_setup
rem "サーバーへクライアントのインストール"
rem "その後，サーバー環境としてクライアントを起動"
rem "ここで，設定したプロファイルがクライアントに配信される"
set QGIS_Install=%QGIS_delivery_client%
set mode=server
goto :Start_download

:client_mode
call :config_setup
set mode=client 
goto :Start_download

:config_setup
rem "=====呼び出しコマンド"
rem "QGIS.cfg.bat"の読み込み"
REM 設定ファイルの読み込み（結合）
rem "ダウンロードサイトの選択"
for /f %%a in (QGIS_site.txt) do (
  set site=%%a
)

rem "ダウンロードサイト"
rem -----------------------------------------------------
rem "デフォルト　site=1 pigreco 本家（最新版）"
if %site% == 2 (
  rem "site=2 pigreco 本家（旧版）"
  set QGIS_ver=3.16.161
  set QGIS_http=
  set QGIS_File=OSGeo4W64_316161-ltr_grass78.7z
  rem "解凍フォルダ"
  set QGIS_extract_folder=OSGeo4W64
  set QGIS_core_plugin_folder=qgis\apps\qgis-ltr\python\plugins
) else (
  rem "デフォルト"
  rem "site=1 pigreco 本家（最新版）"
  set QGIS_ver=3.22.10
  set QGIS_http=https://drive.google.com/file/d/1-g_GH-JqsPqPRd-7mpn0NxmbF_nSy5z5/view
  set QGIS_File=OSGeo4W64_3.22.10-ltr_grass-saga.7z
  rem "解凍フォルダ"
  set QGIS_extract_folder=OSGeo4W64
  set QGIS_core_plugin_folder=qgis\apps\qgis-ltr\python\plugins
)
exit /b

:Start_download
rem "=============================================================="
rem "====================配信用QGISのダウンロード===================="
rem "=============================================================="

SET QGIS_Folder=QGIS_%QGIS_ver%

rem "=====初期フォルダの作成"
md %QGIS_delivery%
md %QGIS_delivery%\plugin\

rem "==========配信用ファイルをインターネットからダウンロード=========="
rem "サーバーとして動作"
if exist "QGIS_delivery_server.cfg" (
    rem "インターネット接続によるダウンロード"
    if exist "QGIS_internet.cfg" (

        :QGIS_download
        rem "配信ファイルがない場合は，配信ファイルのダウンロード"
        rem "QGIS本体のダウンロード"
        rem "「for」コマンドを使った無限ループ"
        rem "ダウンロード状態のファイルがない場合ダウンロード"
        if not exist %QGIS_delivery%\%QGIS_File% (
            rem "配信用ファイルがない場合ダウンロード"
            if not exist %QGIS_delivery%\%QGIS_Folder%.7z (
                rem "配信用フォルダを設定"
                explorer %QGIS_delivery%
                start "" %QGIS_http%
                rem "powershell で %ERRORLEVEL% を参照すると 0 または 1 の値しか取得することができません。（ 0 以外の値は全て 1 として返されます。)"
                powershell -Command "Add-Type -AssemblyName System.Windows.Forms;[System.Windows.Forms.MessageBox]::Show(\"1-自動で開かれたサイトからダウンロードをしてください。`n2-ダウンロードが終了したら，%QGIS_delivery% フォルダに移動してください`n3-1.2の作業が終わったら「ＯＫ」を押してください。`n`n`※次の作業である，解凍の途中で失敗すると起動しません。気長に待ってください。\", 'ダウンロード', 'OK', 'Asterisk')"
            )
        )

        rem "ダウンロード状態のファイルは、配信用ファイルに変更"
        if exist %QGIS_delivery%\%QGIS_File% (
            rem "QGISダウンロードファイルを配信用QGISフォルダに名前変更"
            rename %QGIS_delivery%\%QGIS_File% %QGIS_Folder%.7z
            rem "7z内のフォルダ名変更"
            rem "*****************************　動作怪しいので再確認　***********************************"
            call 7zr.exe rn %QGIS_delivery%\%QGIS_Folder%.7z %QGIS_extract_folder% %QGIS_Folder%
        )

        rem ダウンロードが正しく終了したかの確認
        if not exist %QGIS_delivery%\%QGIS_Folder%.7z (
            powershell -Command "Add-Type -AssemblyName System.Windows.Forms;[System.Windows.Forms.MessageBox]::Show(\"正しくダウンロード及びファイルの移動ができませんでした。`n一度終了します。`n再起動してください。\", 'ダウンロード', 'OK', 'Asterisk')"
            exit
        )

        :Plugin_download
        rem "追加コアプラグインのダウンロード"
        rem "tokens=1,2 を使って、スペース区切りの文字列"
        for /f "tokens=1,2" %%a in (QGIS_plugin.txt) do (
            set QGIS_plugin_http=%%a
            set QGIS_plugin_File=%%b
            if not exist %QGIS_delivery%\plugin\!QGIS_plugin_File! (
                rem "=====ファイルダウンロード"
                rem "bitsadmin /transfer ＜ジョブ名＞ ＜URL＞ ＜保存先ファイル名＞"
                echo プラグインのダウンロード：!QGIS_plugin_http!!QGIS_plugin_File!
                bitsadmin /transfer download_QGIS_plugin_!QGIS_plugin_http! !QGIS_plugin_http!!QGIS_plugin_File! %QGIS_delivery%\plugin\!QGIS_plugin_File!
            )
        )
    )
)

rem "=============================================================="
rem "====================配信用QGISのインストール===================="
rem "=============================================================="

rem "==========クライアントモード=========="
rem "if分の中での変数の演算はできないかったので外に出した！注意！"
set OSGEO4W_ROOT=%QGIS_Install%\%QGIS_Folder%\qgis

rem "==========64ビット環境の確認=========="
rem "%変数:~開始位置,-長さ%	開始位置から右端から長さ分を除いた文字列"
if not %PROCESSOR_ARCHITECTURE:~-2% == 64 (
    msg %username% 64ビット環境でのみ動作します。
    exit
)
rem "インストール済みかどうかを確認"
rem "インストール先のフォルダ名の設定"
if not exist %QGIS_Install%\%QGIS_Folder% (
    rem "7z解凍"
    msg %username% 7z解凍
    call 7zr.exe x -y %QGIS_delivery%\%QGIS_Folder%.7z -o%QGIS_Install%
)

rem "qgisconfig配信元のフォルダ内にsystem_verを設置"
if not exist %QGIS_delivery%\qgisconfig\system_ver (
    msg %username% system_verを配布
    rem "解凍の前にいったん削除"
    rem "/s サブディレクトリ含む /q メッセージなし"
    rmdir /s /q %QGIS_delivery%\qgisconfig\system_ver
    call powershell -command "copy-item system_ver %QGIS_delivery%\qgisconfig\system_ver -Recurse -force
)
    
rem "profiles等のqgisconfigを配布"
rem ２つのファイルを比較して更新処理
fc /L %QGIS_delivery%\qgisconfig\system_ver\qgisconfig_ver.txt %USERPROFILE%\Documents\qgisconfig\system_ver\qgisconfig_ver.txt
rem "遅延環境変数の記述方法を「%変数名%」から「!変数名!」に変更"
if !errorlevel!==0 (
    rem "ファイル内容が等しい"
) else (
    rem "ファイル内容が違う、ファイルがない等"
    rem "コマンドプロンプトはネットワークフォルダ非対応のためpowershellで実行"
    rem "フォルダ以下すべて -Recurse"
    rem "既存フォルダがあっても強制 -force" 
    msg %username% qgisconfigを配布
    rem "call powershell -command "copy-item %QGIS_delivery%\qgisconfig %QGIS_Install%\qgisconfig -Recurse -force"
    rem "/s サブディレクトリ含む /q メッセージなし"
    rmdir /s /q %USERPROFILE%\Documents\qgisconfig
    call powershell -command "copy-item %QGIS_delivery%\qgisconfig %USERPROFILE%\Documents\qgisconfig -Recurse -force
)

rem "コアプラグイン　インストール済みかどうかを確認"
rem "追加コアプラグインのインストール"
rem "tokens=1,2 を使って、スペース区切りの文字列"
rem "遅延環境変数の記述方法を「%変数名%」から「!変数名!」に変更"
for /f "tokens=1,2,3" %%a in (QGIS_plugin.txt) do (
    rem "httpアドレス"
    set QGIS_plugin_http=%%a
    rem "ZIPファイル名"
    set QGIS_plugin_File=%%b
    rem "解凍後のフォルダ名"
    set QGIS_plugin_folder=%%c
    rem "実際にインストールされているかどうかのチェック"
    if not exist %QGIS_Install%\%QGIS_Folder%\%QGIS_core_plugin_folder%\!QGIS_plugin_folder! (
        rem "=====Zipファイルの解凍 PowerShellコマンド"
        rem "Expand-Archive -Path ＜ZIPファイル＞　＜展開先フォルダ＞"
        echo プラグインのインストール：!QGIS_plugin_http!!QGIS_plugin_File!
        powershell Expand-Archive -Path  %QGIS_delivery%\plugin\!QGIS_plugin_File! %QGIS_Install%\%QGIS_Folder%\%QGIS_core_plugin_folder%
    ) else (
        rem "バージョンチェック"
        fc /L system_ver\!QGIS_plugin_folder!_ver.txt %USERPROFILE%\Documents\qgisconfig\system_ver\!QGIS_plugin_folder!_ver.txt
            if %errorlevel%==0 (
            rem "ファイル内容が等しい"
            rem msg %username% !QGIS_plugin_folder!バージョンアップはありません
        ) else (
            rem "ファイル内容が違う、ファイルがない等"
            rem "コマンドプロンプトはネットワークフォルダ非対応のためpowershellで実行"
            rem "フォルダ以下すべて -Recurse"
            rem "既存フォルダがあっても強制 -force" 
            msg %username% !QGIS_plugin_folder!バージョンアップによる再配布
            rem "解凍の前にいったん削除"
            rem "/s サブディレクトリ含む /q メッセージなし"
            rmdir /s /q %QGIS_Install%\%QGIS_Folder%\!QGIS_core_plugin_folder!
            powershell Expand-Archive -Path  %QGIS_delivery%\plugin\!QGIS_plugin_File! %QGIS_Install%\%QGIS_Folder%\!QGIS_core_plugin_folder!
            call powershell -command "copy-item system_ver\!QGIS_plugin_folder!_ver.txt %USERPROFILE%\Documents\qgisconfig\system_ver\!QGIS_plugin_folder!_ver.txt -Recurse -force
        ) 
    )
 )

rem "QGISの起動"
rem "起動用フォルダに移動"
rem "cd %QGIS_Install%\%QGIS_Folder%"
cd %USERPROFILE%\Desktop
rem "QGISのBATファイルに「cd /d %~dp0」がありネットワークドライブからの起動は出来ないので注意"
set OSGEO4W_ROOT=%QGIS_Install%\%QGIS_Folder%
path %PATH%;%OSGEO4W_ROOT%\apps\qgis-ltr\bin;%OSGEO4W_ROOT%\apps;%OSGEO4W_ROOT%\bin;%OSGEO4W_ROOT%\apps\grass
rem  "powershell -command "%OSGEO4W_ROOT%\qgis\bin\qgis-ltr.bat --profiles-path %QGIS_Install%\qgisconfig"""
powershell -command "%OSGEO4W_ROOT%\qgis\bin\qgis-ltr.bat --profiles-path %USERPROFILE%\Documents\qgisconfig" 
rem start %OSGEO4W_ROOT%\qgis\bin\qgis-ltr.bat --profiles-path %QGIS_Install%\qgisconfig

rem "コマンドプロンプト終了"
exit /b
