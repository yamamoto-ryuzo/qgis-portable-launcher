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

rem "ダウンロードサーバーの設定"
set QGIS_download=%QGIS_delivery%\%QGIS_ver%

rem "インストール先のフォルダ名の設定"
rem "部分参照は %str:~-m,-n% 後ろからm文字目から、最後のn文字分を除いたもの"
SET QGIS_Folder=%QGIS_ver:~-0,-4%

rem "==========サーバーモード=========="
if exist "QGIS_delivery_server.cfg" (
    if exist "QGIS_internet.cfg" (
        rem "配信ファイルがない場合は，配信ファイルのダウンロード"
        if not exist %QGIS_download% (
            rem "=====ファイルダウンロード"
            rem "bitsadmin /transfer ＜ジョブ名＞ ＜URL＞ ＜保存先ファイル名＞"
            bitsadmin /transfer download-%QGIS_Folder% %QGIS_http%%QGIS_ver%   %QGIS_download%
        )
    )
)

rem "==========クライアントモード=========="
if exist "QGIS_client.cfg" (
    rem "=====QGIS起動"
    rem "インストール済みかどうかを確認"
    if not exist %QGIS_Install%\%QGIS_Folder% (
        rem "=====Zipファイルの解凍 PowerShellコマンド"
        rem "Expand-Archive -Path ＜ZIPファイル＞　＜展開先フォルダ＞"
        powershell Expand-Archive -Path %QGIS_download% %QGIS_delivery%
    )
    rem "QGIS_http=http://kouapp.main.jp/qgisp/"
    %QGIS_Install%\%QGIS_Folder%\qgis_p起動.bat
)
rem "バッチ終了"
exit /b


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