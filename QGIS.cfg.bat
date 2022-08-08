rem "ダウンロードサイトの選択"
rem "site="1" pigreco 本家"
rem "site="2" kouapp　喜多さんのサイト"
set site=1

rem "ダウンロードサイト"
if %site% == 1 (
    rem バージョンは空白が入らないように””で囲むこと！
    set QGIS_ver="3.22.9"
    set QGIS_http=https://doc-00-1o-docs.googleusercontent.com/docs/securesc/60v1atgd7bougp4s2j4ke6u93vpnueb3/27ik8ft755983s5l1pvj7p9djcnkkj51/1659876900000/02571389660706551936/06654353961832540270/1-S272QXknZdWDbYcI2R9QBWo9pSNlUGI?e=download&ax=AI9vYm6eLelZJ6YdPAvdmzltQr7SwGdxM9SL0nhZjLZf2LEEMQhF3lqdMfHHcRtPZGKCR0Ye9WdHpCOOn3HcX680zXBEYFn2-nOoFv5jf3P_MzeyZLNSxhzBHikzfZvZHH65nW0u6Dh6V1ppR9_9RC6v92-UDa4VuZ6kN-HeEg2aDV4mjbUpYJzYXypK7tb50F840NnZBN3TEw6n2-gUEz27PgI7aAfJmvQZ47rnBAih4vXzJcTo4Xfe78z0GYvaSdeVTnCUY6rCRWQX-rze09Ba7RtHAw90ltkf8VY1VfFv8Ewyq_svMf2iq6x7Gn7nEK_-rt5J0tMlzqv17XhvqzGl2YBaHmgYm0wMXhUqG31E5FiLpDMCcX-Rb_69p3C4AEjuT-DRVwMu0alivg6gDqmI5ZYmpf88EDO2jVDXvUT_cX5Ed7rzlLDU7BbkW7Qn14gsdbuW8ZpGlAswuecvBeEZAllP8x5g1CmGBqRDimJr3QM3CU4Mb1IxJODwrG7MzT8iB6adAdKYOPOmqDjbLT7Cr2vgzghIbG58nNBlespynihpjP6uEVuZHbzdV3rAOWy4UDeWT-0X8Durm_-iRrmHKW2HYmw68dxTTjKxem8TQSetFaui-72sBxKaTUBtuuW8NZeKFfA4dVP9VjWymDnIYPBKiP4BQaj2W0GbvQbfXv4xgvI7Wj-YwnrClkpZ-tGtdsT8e-k2OQsMvb2g&uuid=1ced175a-0f9a-49d5-a1b1-f98e79b6a36b&authuser=0&nonce=f06nit0ppti08&user=06654353961832540270&hash=i24s02a221sfqoi1dacaa2d5699ktkjg
    set QGIS_File=OSGeo4W64_3.22.9-ltr_grass-saga.7z
    rem "解凍フォルダ"
    set QGIS_extract_folder=OSGeo4W64
) else (
    rem バージョンは空白が入らないように””で囲むこと！
    set QGIS_ver="3.22.6"
    set QGIS_http=http://kouapp.main.jp/qgisp/QGIS322_portable.zip
    set QGIS_File=QGIS322_portable.zip
    rem "解凍フォルダ"
    set QGIS_extract_folder=QGIS322_portable
)

rem "下記フォルダにはアクセス権必要"
rem "配信用フォルダ"
set QGIS_delivery=c:\QGIS_portable

rem "インストール・フォルダ"
set QGIS_Install=c:\QGIS_portable
rem "set QGIS_delivery=%USERPROFILE%\Downloads"