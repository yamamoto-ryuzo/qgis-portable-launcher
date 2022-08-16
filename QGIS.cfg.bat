rem "ダウンロードサイトの選択"
rem "site=1 pigreco 本家"
rem "site=2 kouapp　喜多さんのサイト"
set site=1

rem "ダウンロードサイト"
if %site% == 1 (
    set QGIS_ver=3.22.10
    set QGIS_http=http://lizmap.yamakun.net:8080/OSGeo4W64_3.22.10-ltr_grass-saga.7z
    set QGIS_File=OSGeo4W64_3.22.10-ltr_grass-saga.7z
    rem "解凍フォルダ"
    set QGIS_extract_folder=OSGeo4W64
    set QGIS_core_plugin_folder=qgis\apps\qgis-ltr\python\plugins
) else (
    set QGIS_ver=3.22.6
    set QGIS_http=http://kouapp.main.jp/qgisp/QGIS322_portable.zip
    set QGIS_File=QGIS322_portable.zip
    rem "解凍フォルダ"
    set QGIS_extract_folder=QGIS322_portable
    set QGIS_core_plugin_folder=apps\qgis-ltr\python\plugins
)

rem "下記フォルダにはアクセス権必要"
rem "配信用フォルダ"
set QGIS_delivery=c:\QGIS_portable

rem "インストール・フォルダ"
set QGIS_Install=c:\QGIS_portable_client
rem "set QGIS_delivery=%USERPROFILE%\Downloads"
