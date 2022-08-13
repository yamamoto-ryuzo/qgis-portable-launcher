rem @echo off
chcp 65001
rem "↑　文字コードの指定　UTF-8＝65001"
rem "見本後は必ず「””」で囲む"
rem "====================環境設定===================="
rem "起動フォルダをカレントフォルダに設定"
cd /d %~dp0

rem 遅延展開する変数の記述方法を「%変数名%」から「!変数名!」に変更
rem for を利用時には必ず必要
setlocal enabledelayedexpansion

rem "====================配信用QGISのダウンロード===================="

rem "==========環境変数の設定=========="
rem "QGIS.cfg.bat"の読み込み"
REM 設定ファイルの読み込み（結合）
CALL QGIS.cfg.bat

SET QGIS_Folder=QGIS_%QGIS_ver%

rem "初期フォルダの作成"
md %QGIS_delivery%
md %QGIS_delivery%\plugin\

rem "==========サーバーモード=========="
if exist "QGIS_delivery_server.cfg" (
    if exist "QGIS_internet.cfg" (
        rem "配信ファイルがない場合は，配信ファイルのダウンロード"
        rem "QGIS本体のダウンロード"
        if not exist %QGIS_delivery%\%QGIS_File% (
            rem "=====ファイルダウンロード"
            rem "bitsadmin /transfer ＜ジョブ名＞ ＜URL＞ ＜保存先ファイル名＞"
            bitsadmin /transfer download_QGIS_%QGIS_ver% %QGIS_http% %QGIS_delivery%\%QGIS_File%
        )
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
    for /f "tokens=1,2" %%a in (QGIS_plugin.txt) do (
        set QGIS_plugin_http=%%a
        set QGIS_plugin_File=%%b
        rem "%変数:~開始位置,-長さ%	開始位置から右端から長さ分を除いた文字列"
        set QGIS_plugin_folder=!QGIS_plugin_File:~0,-4!
        if not exist %QGIS_Install%\%QGIS_Folder%\%QGIS_core_plugin_folder%\!QGIS_plugin_folder! (
            rem "=====Zipファイルの解凍 PowerShellコマンド"
            rem "Expand-Archive -Path ＜ZIPファイル＞　＜展開先フォルダ＞"
            echo プラグインのインストール：!QGIS_plugin_http!!QGIS_plugin_File!
            powershell Expand-Archive -Path  %QGIS_delivery%\plugin\!QGIS_plugin_File! %QGIS_Install%\%QGIS_Folder%\%QGIS_core_plugin_folder%
        )
    )

    rem "QGISの起動"
    rem "起動用フォルダに移動"
    cd %QGIS_Install%\%QGIS_Folder%
    if %site% == 1 (
        %QGIS_Install%\%QGIS_Folder%\qgis-ltr-grass.bat
    ) else (
        %QGIS_Install%\%QGIS_Folder%\qgis_p起動.bat
    )
)

rem "コマンドプロンプト終了"
exit
