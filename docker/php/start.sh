#!/bin/bash

# cronをバックグラウンドで実行
service cron start

# php-fpmをフォアグラウンドで実行
php-fpm -F
