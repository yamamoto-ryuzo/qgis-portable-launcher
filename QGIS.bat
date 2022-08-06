rem ====================環境設定====================
rem 起動フォルダをカレントフォルダに設定
cd /d %~dp0

rem 文字コードの指定　UTF-8＝65001
chcp 65001

rem ====================配信用QGISのインストール====================
rem ==========環境変数の設定==========
rem 外部環境変数の読込
rem "QGIS.cfg"の読み込み
for /f "tokens=1,* delims==" %%a in (QGIS.cfg) do (
    set %%a=%%b
)

rem ダウンロードサーバーの設定
set QGIS_download=%USERPROFILE%\Downloads\%QGIS_ver%

rem 保存先ホルダ名の設定
rem 部分参照は %str:~-m,-n% 後ろからm文字目から、最後のn文字分を除いたもの
SET QGIS_Folder=%QGIS_ver:~-0,-4%

rem ==========ファイルダウンロード==========
rem インストール済みかどうかを確認
if exist %QGIS_Install%\QGIS_portable\%QGIS_Folder% (
    goto Launch_QGIS
)

rem =====ファイルダウンロード
rem bitsadmin /transfer ＜ジョブ名＞ ＜URL＞ ＜保存先ファイル名＞
bitsadmin /transfer download-%QGIS_Folder% %QGIS_http%%QGIS_ver%   %QGIS_download%

rem =====Zipファイルの解凍 PowerShellコマンド
rem Expand-Archive -Path ＜ZIPファイル＞　＜展開先フォルダ＞
powershell Expand-Archive -Path %QGIS_download% %QGIS_Install%\QGIS_portable


rem ==========QGIS起動==========
:Launch_QGIS

rem  rem QGIS_http=http://kouapp.main.jp/qgisp/
%QGIS_Install%\QGIS_portable\%QGIS_Folder%\qgis_p起動.bat

rem　バッチ終了
exit /b


rem ====================関数設定====================
rem 関数STRLEN設定
:STRLEN
set str=%1
set len=0
rem ループの先頭
:LOOP
rem 文字列「str」が空じゃなければ
if not "%str%"=="" (
    rem 文字列「str」から1文字削る
    set str=%str:~1%
    rem 文字数「Len」を1カウントアップ
    set /a len=%len%+1
    rem ループの先頭に戻る
    goto :LOOP
)
rem　バッチ終了
exit /b

