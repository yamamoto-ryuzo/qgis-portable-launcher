rem 引数　%1 QGIS_custum.ini　の代替えファイルを指定
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

"初期変数の読込"

rem 2023-12-03 qgisconfig = \AppData\Roaming\QGIS\QGIS3　とし、通常版インストールと統合
set QGIS_qgisconfig=%USERPROFILE%\AppData\Roaming\QGIS\QGIS3

if "%1%"=="" (
  set QGIS_ini=QGIS_custum.ini
) else (
  set QGIS_ini=%1
)

for /f "tokens=1,2 delims==" %%a in (%QGIS_ini%) do (
  set %%a=%%b
  rem "なぜか最初の１行は；をコメント認識してくれないので注意！"
  rem msg %username%  %%a,%%b
)
  rem msg %username%  %QGIS_delivery%,%QGIS_Install%,%QGIS_delivery_client%

rem "=====モードセレクト"
rem "c:クライアントモード　　ﾃﾞﾌｫﾙﾄ設定"
rem "s:サーバーモード"
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
rem "-----------------------------------------------------"
rem "ダウンロードサイト"
rem "-----------------------------------------------------"
set QGIS_ver=3.28.9
set QGIS_http=https://drive.google.com/file/d/1wwvgiMAeqiw3pDRCRNT3OlMu_-zWWb7L/view?usp=sharing
set QGIS_File=OSGeo4W64_3.28.9-ltr_grass-saga.7z
rem "解凍フォルダ"
set QGIS_extract_folder=OSGeo4W64
set QGIS_core_plugin_folder=qgis\apps\qgis-ltr\python\plugins
exit /b

:Start_download
rem "=============================================================="
rem "====================配信用QGISのダウンロード===================="
rem "=============================================================="

SET QGIS_Folder=QGIS_%QGIS_ver%

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
        rem "追加プラグインのダウンロード"
        rem "tokens=1,2 を使って、スペース区切りの文字列"
        for /f "tokens=1,2" %%a in (QGIS_plugin.txt) do (
            set QGIS_plugin_http=%%a
            set QGIS_plugin_File=%%b
            if not exist plugin\!QGIS_plugin_File! (
                rem "=====ファイルダウンロード"
                rem "プラグイン保存先をランチャー内に変更"
                rem "bitsadmin /transfer ＜ジョブ名＞ ＜URL＞ ＜保存先ファイル名＞"
                echo プラグインのダウンロード：!QGIS_plugin_http!!QGIS_plugin_File!
                bitsadmin /transfer download_QGIS_plugin_!QGIS_plugin_http! !QGIS_plugin_http!!QGIS_plugin_File! %~dp0plugin\!QGIS_plugin_File!
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

rem "==========qgisconfig\profilesを配布=========="
rem ２つのファイルを比較して更新処理
fc /L %~dp0qgisconfig\system_ver\qgisconfig_ver.txt %QGIS_qgisconfig%\system_ver\qgisconfig_ver.txt
rem "遅延環境変数の記述方法を「%変数名%」から「!変数名!」に変更"
if %errorlevel%==0 (
    rem "ファイル内容が等しい"
) else (
    rem "qgisconfig_ver.txtの配布"
    md %QGIS_qgisconfig%\system_ver
    copy %~dp0qgisconfig\system_ver\qgisconfig_ver.txt %QGIS_qgisconfig%\system_ver\qgisconfig_ver.txt
    rem msg %username% qgisconfig_ver.txtを配布

    rem "ファイル内容が違う、ファイルがない等"
    rem "コマンドプロンプトはネットワークフォルダ非対応のためpowershellで実行"
    rem "フォルダ以下すべて -Recurse"
    rem "既存フォルダがあっても強制 -force"
    msg %username% qgisconfigを配布
    rem "/s サブディレクトリ含む /q メッセージなし"
    rmdir /s /q %QGIS_qgisconfig%\profiles
    call powershell -command "copy-item %~dp0qgisconfig\profiles %QGIS_qgisconfig%\profiles -Recurse -force
)

rem "==========プラグインを配布=========="
rem "プラグインが更新しているかどうかのフラグ"
set plugins_flag=0

rem "プラグイン　インストール済みかどうかを確認"
rem "追加プラグインのインストール"
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
    rem "とりあえずインストールのユーザープロファイルは yr_custom　として処理"
    if not exist %QGIS_qgisconfig%\profiles\yr_custom\python\plugins\!QGIS_plugin_folder! (
        rem "=====Zipファイルの解凍 PowerShellコマンド"
        rem "Expand-Archive -Path ＜ZIPファイル＞　＜展開先フォルダ＞"
        echo プラグインのインストール：!QGIS_plugin_http!!QGIS_plugin_File!
        powershell Expand-Archive -Path  %~dp0plugin\!QGIS_plugin_File! %QGIS_qgisconfig%\profiles\yr_custom\python\plugins

        rem "!QGIS_plugin_folder!_ver.txtの配布"
        md %QGIS_qgisconfig%\system_ver
        copy %~dp0qgisconfig\system_ver\!QGIS_plugin_folder!_ver.txt %QGIS_qgisconfig%\system_ver\!QGIS_plugin_folder!_ver.txt
    ) else (
        rem "バージョンチェック"
        fc /L %~dp0qgisconfig\system_ver\!QGIS_plugin_folder!_ver.txt %QGIS_qgisconfig%\system_ver\!QGIS_plugin_folder!_ver.txt
            if %errorlevel%==0 (
            rem "ファイル内容が等しい"
            rem msg %username% !QGIS_plugin_folder!バージョンアップはありません
        ) else (
            rem "!QGIS_plugin_folder!_ver.txtの配布"
            md %QGIS_qgisconfig%\system_ver
            copy %~dp0qgisconfig\system_ver\!QGIS_plugin_folder!_ver.txt %QGIS_qgisconfig%\system_ver\!QGIS_plugin_folder!_ver.txt

	    set plugins_flag=1
            rem "ファイル内容が違う、ファイルがない等"
            rem "コマンドプロンプトはネットワークフォルダ非対応のためpowershellで実行"
            rem "フォルダ以下すべて -Recurse"
            rem "既存フォルダがあっても強制 -force" 
            rem "解凍の前にいったん削除"
            rem "/s サブディレクトリ含む /q メッセージなし"
            rmdir /s /q %QGIS_qgisconfig%\profiles\yr_custom\python\plugins\!QGIS_plugin_folder!
            powershell Expand-Archive -Path  %~dp0plugin\!QGIS_plugin_File! %QGIS_qgisconfig%\profiles\yr_custom\python\plugins
            call 7zr.exe e x -y %QGIS_delivery%\plugin\!QGIS_plugin_File! -o %QGIS_qgisconfig%\profiles\yr_custom\python\plugins
            msg %username% !QGIS_plugin_folder!バージョンアップによる再配布
        ) 
    )
)

rem "==========プラグインのカスタマイズ=========="
rem "プラグイン更新有の場合は、必要なカスタムファイルの上書き"
rem if plugins_flag==1(
    xcopy %~dp0plugin\上書きファイル\qgisconfig %USERPROFILE%\AppData\Roaming\QGIS\QGIS3 /Y /E
rem )

rem "==========QGISの起動=========="
rem "起動用フォルダに移動"
rem "cd %QGIS_Install%\%QGIS_Folder%"
cd %USERPROFILE%\Desktop
rem "QGISのBATファイルに「cd /d %~dp0」がありネットワークドライブからの起動は出来ないので注意"
set OSGEO4W_ROOT=%QGIS_Install%\%QGIS_Folder%
path %PATH%;%OSGEO4W_ROOT%\apps\qgis-ltr\bin;%OSGEO4W_ROOT%\apps;%OSGEO4W_ROOT%\bin;%OSGEO4W_ROOT%\apps\grass
rem powershell -command "%OSGEO4W_ROOT%\qgis\bin\qgis-ltr.bat --profiles-path %QGIS_Install%\qgisconfig"""
powershell -command "%OSGEO4W_ROOT%\qgis\bin\qgis-ltr.bat --profile yr_custom" 
rem start %OSGEO4W_ROOT%\qgis\bin\qgis-ltr.bat --profiles-path %QGIS_Install%\qgisconfig

rem "コマンドプロンプト終了"
exit /b
