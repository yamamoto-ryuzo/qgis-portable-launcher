#@echo off
chcp 65001
rem "↑　文字コードの指定　UTF-8＝65001"
rem "見本後は必ず「””」で囲む"
rem "====================環境設定===================="
rem "注意事項"
rem "変数の代入の=の前後に空白を入れないこと！"
rem "起動フォルダをカレントフォルダに設定"
cd /d %~dp0

rem 遅延展開する変数の記述方法を「%変数名%」から「!変数名!」に変更
rem for を利用時には必ず必要
setlocal enabledelayedexpansion

rem "==========環境変数の設定=========="

rem "=====モードセレクト"
rem "c:クライアントモード　　ﾃﾞﾌｫﾙﾄ設定"
rem "s:サーバーモード"
rem "p:site=1 pigreco 本家　ﾃﾞﾌｫﾙﾄ設定"
rem "k:site=2 kouapp　喜多さんのサイト"
rem "/t 1秒"
rem "/D c ﾃﾞﾌｫﾙﾄ設定"
choice /c cspk /t 1 /D c /n
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
    msg %username% QGISポータブル版をpigreco（本家）に設定しました。
    goto :client_mode
) else if  %errorlevel% equ 4 (
    rem site=2　を選択
    echo 2 > QGIS_site.txt
    msg %username% QGISポータブル版をkouapp（喜多さん）に設定しました。
    goto :client_mode
) else (
    goto :client_mode
)

:server_mode
call :config_setup
rem "サーバーへクライアントのインストール"
rem "その後，サーバー環境としてクライアントを起動"
rem "ここで，設定したプロファイルがクライアントに配信される"
set QGIS_Install=%QGIS_delivery%
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
CALL QGIS.cfg.bat
rem "QGIS.custum_cfg.batが優先的に適用されます。"
if exist QGIS.custum_cfg.bat (
    CALL QGIS.custum_cfg.bat
)
exit /b

:Start_download
rem "====================配信用QGISのダウンロード===================="

SET QGIS_Folder=QGIS_%QGIS_ver%

rem "=====初期フォルダの作成"
md %QGIS_delivery%
md %QGIS_delivery%\plugin\

rem "==========サーバーモード=========="
if exist "QGIS_delivery_server.cfg" (
    if exist "QGIS_internet.cfg" (

        :QGIS_download
        rem "配信ファイルがない場合は，配信ファイルのダウンロード"
        rem "QGIS本体のダウンロード"
        rem 「for」コマンドを使った無限ループ
        if not exist %QGIS_delivery%\%QGIS_File% (
            if %site% == 1 (
                explorer %QGIS_delivery%
                start "" %QGIS_http%
                rem "powershell で %ERRORLEVEL% を参照すると 0 または 1 の値しか取得することができません。（ 0 以外の値は全て 1 として返されます。)"
                powershell -Command "Add-Type -AssemblyName System.Windows.Forms;[System.Windows.Forms.MessageBox]::Show(\"1-自動で開かれたサイトからダウンロードをしてください。`n2-ダウンロードが終了したら，%QGIS_delivery% フォルダに移動してください`n3-1.2の作業が終わったら「ＯＫ」を押してください。`n`n`※次の作業である，解凍の途中で失敗すると起動しません。気長に待ってください。\", 'ダウンロード', 'OK', 'Asterisk')"
            ) else (
                rem "=====ファイルダウンロード"
                rem "bitsadmin /transfer ＜ジョブ名＞ ＜URL＞ ＜保存先ファイル名＞"
                bitsadmin /transfer download_QGIS_%QGIS_ver% %QGIS_http% %QGIS_delivery%\%QGIS_File%
            )
        )

        rem ダウンロードが正しく終了したかの確認
        if not exist %QGIS_delivery%\%QGIS_File% (
            powershell -Command "Add-Type -AssemblyName System.Windows.Forms;[System.Windows.Forms.MessageBox]::Show(\"正しくダウンロード及びファイルの移動ができませんでした。`n一度終了します。`n再起動してください。`n`n※よくわからない場合は起動後1秒位以内に「k」を押してください\", 'ダウンロード', 'OK', 'Asterisk')"
            exit /b
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

rem "====================配信用QGISのインストール===================="
rem "==========クライアントモード=========="
if exist "QGIS_client.cfg" (
    rem "==========64ビット環境の確認=========="
    rem "%変数:~開始位置,-長さ%	開始位置から右端から長さ分を除いた文字列"
    if not %PROCESSOR_ARCHITECTURE:~-2% == 64 (
        msg %username% 64ビット環境でのみ動作します。
        exit /b
    )
    rem "インストール済みかどうかを確認"
    rem "インストール先のフォルダ名の設定"
    if not exist %QGIS_Install%\%QGIS_Folder% (
        if %site% == 1 (
            rem "7z解凍"
            7z.exe x -y %QGIS_delivery%\%QGIS_File% -o%QGIS_Install%
        ) else (
            rem "=====Zipファイルの解凍 PowerShellコマンド"
            rem "Expand-Archive -Path ＜ZIPファイル＞　＜展開先フォルダ＞"
            powershell Expand-Archive -Path  %QGIS_delivery%\%QGIS_File% %QGIS_Install%
        )
        cd %QGIS_Install%
        rename %QGIS_extract_folder% %QGIS_Folder% 
        rem "起動フォルダをカレントフォルダに設定"
        cd /d %~dp0
    )
    
    rem "コアプラグイン　インストール済みかどうかを確認"
    rem "追加コアプラグインのインストール"
    rem "tokens=1,2 を使って、スペース区切りの文字列"
    for /f "tokens=1,2,3" %%a in (QGIS_plugin.txt) do (
        rem "httpアドレス"
        set QGIS_plugin_http=%%a
        rem "ZIPファイル名"
        set QGIS_plugin_File=%%b
        rem "解凍後のフォルダ名"
        set QGIS_plugin_folder=%%c
        if not exist %QGIS_Install%\%QGIS_Folder%\%QGIS_core_plugin_folder%\!QGIS_plugin_folder! (
            rem "=====Zipファイルの解凍 PowerShellコマンド"
            rem "Expand-Archive -Path ＜ZIPファイル＞　＜展開先フォルダ＞"
            echo プラグインのインストール：!QGIS_plugin_http!!QGIS_plugin_File!
            powershell Expand-Archive -Path  %QGIS_delivery%\plugin\!QGIS_plugin_File! %QGIS_Install%\%QGIS_Folder%\%QGIS_core_plugin_folder%
        )
    )

    rem "profiles等のqgisconfigを配布"
    if exist %QGIS_delivery%\qgisconfig (
        robocopy %QGIS_delivery%\qgisconfig %QGIS_Install%\qgisconfig /MIR
    )

    rem "QGISの起動"
    rem "起動用フォルダに移動"
    cd %QGIS_Install%\%QGIS_Folder%
    if %site% == 1 (
        rem start %QGIS_Install%\%QGIS_Folder%\qgis-ltr-grass.bat
        call %QGIS_Install%\%QGIS_Folder%\qgis\bin\qgis-ltr.bat --profiles-path %QGIS_Install%\qgisconfig
    ) else (
        call %QGIS_Install%\%QGIS_Folder%\bin\qgis-ltr.bat --profiles-path %QGIS_Install%\qgisconfig
    )
)

rem "コマンドプロンプト終了"
exit /b
