#!/usr/bin/env bash
echo "restart..."
ps -eaf |grep "quiz" | grep -v "grep"| awk '{print $2}'|xargs kill -9
sleep 2
/usr/local/php/bin/php /data/wwwroot/quiz/current/app/quizSwoole.php   >> /data/logs/quizserver.log 2>&1 &
echo "restarted"