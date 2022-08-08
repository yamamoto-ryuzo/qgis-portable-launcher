chcp 65001
rem "↑　文字コードの指定　UTF-8＝65001"
rem "見本後は必ず「””」で囲む"
rem "====================環境設定===================="
rem "起動フォルダをカレントフォルダに設定"
cd /d %~dp0

rem "====================配信用QGISのインストール===================="
rem "==========環境変数の設定=========="
rem "QGIS.cfg.bat"の読み込み"
REM 設定ファイルの読み込み（結合）
CALL QGIS.cfg.bat

SET QGIS_Folder=QGIS_%QGIS_ver%

rem "==========サーバーモード=========="
if exist "QGIS_delivery_server.cfg" (
    if exist "QGIS_internet.cfg" (
        rem "配信ファイルがない場合は，配信ファイルのダウンロード"
        if not exist %QGIS_delivery%\%QGIS_File% (
            rem "=====ファイルダウンロード"
            rem "bitsadmin /transfer ＜ジョブ名＞ ＜URL＞ ＜保存先ファイル名＞"
            bitsadmin /transfer download_QGIS_%QGIS_ver% %QGIS_http% %QGIS_delivery%
        )
    )
)

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

rem "====================関数設定===================="
rem "関数STRLEN設定"
:STRLEN
set str=%1
set len=0
rem "ループの先頭"
:LOOP
rem "文字列「str」が空じゃなければ"
if not "%str%"=="" (
    rem "文字列「str」から1文字削る"
    set str=%str:~1%
    rem "文字数「Len」を1カウントアップ"
    set /a len=%len%+1
    rem "ループの先頭に戻る"
    goto :LOOP
)
rem "バッチ終了"
exit /b