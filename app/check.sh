#!/usr/bin/env bash
count=`netstat -nutl | grep ":9501" | grep "LISTEN" | wc -l`
echo $count
if [ $count -lt 1 ];then
    /usr/local/php/bin/php /data/wwwroot/quiz/current/app/quizSwoole.php   >> /data/logs/quizserver.log 2>&1 &
    echo "down restart".$(date +%Y-%m-%d_%H:%M:%S) >> /data/logs/quizserver.log
fi