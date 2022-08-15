rem "ダウンロードサイトの選択"
rem "site=1 pigreco 本家"
rem "site=2 kouapp　喜多さんのサイト"
set site=2

rem "ダウンロードサイト"
if %site% == 1 (
    set QGIS_ver=3.22.10
    set QGIS_http=https://doc-0k-bg-docs.googleusercontent.com/docs/securesc/60v1atgd7bougp4s2j4ke6u93vpnueb3/jnv1igju8vbv1l5r2bhkra0fu134tnj9/1660569000000/06654353961832540270/06654353961832540270/11yACZyPKqS5UK4HhnZXnUDA69sW7AFVq?e=download&ax=AI9vYm5XRLSnCp-ni0Yvyx0c-8wAemgp07TGnmB-JZW_LCf5LqisBZEnQrSWXYnk_YA3jOJzkGLLDj0U-b__SH1ZsfsqCuE8JJEl0cKSW_XJSCj3cM_zj4_Eapum1L5j2y10Ng2G75sH-hmt0dzbkVUsWU4MpwHUR_ZPzlPW_ouXfPDL2L_3cHxJWoTEXHvUZKHMSf92ENIMpWozxCVykeoZt2HjDYhSEN-1FKcsD-ErOTH3Uk8y5_Wea7vtkYSEaiW48oIKUdiUtlm0BSACrUqrvCG87FKHzaRQJLbSR3BPkhBjWKoeYAXbF7eerRe4jRtx3eX3BpVLG9HiV_GRqWjWpQ3FSmwpW3GepTKEM5FQ0S4xlw0M5MgpSSMGvchgHIeOTJasNXxuN-qfnzg4AmZMryFmC1gA3kh3vjJvXSJZfmirzCUiDV9QTR4fOSLvSfOxupkGlrx-OuVI_HhyDX5Gp3clIeZM7UA3SOXzoU4VOeljuogwz3gRoUTJaMhsckIOxPcSEDiQgJOY6J47r3ltmVUKh4sE6s6zQ5xlx_U5gCUKlegCL23c7uxH5cnq-BnVKTghEp95NCCBxfMKOHP3QARnvQRaMCaD8UHoKA3AIk0tXBH_Yl8KPtAy5IOkGXoz8h-6_QUBZqPcy2KtskN6y35M-fcYN2oB4dAyqU-KQB-QbHvhtgQMU3ns_nwzPfzawnH60L7_obDft1EV&uuid=b9f87101-1246-4835-8a08-7ac66352ce91&authuser=0&nonce=4hrvea4lhlbu4&user=06654353961832540270&hash=ai9um42mnnskf0q7d1k03d7t4uhdslmg
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
