#!/bin/bash

# monitor
linenumber=$(ps -ef | grep 'cli.php monitor sub' | grep -v 'grep cli.php monitor sub' | wc -l)
if [ $linenumber -eq 0 ]; then
        nohup /usr/local/php/bin/php /data/wwwroot/quiz/current/app/cli.php monitor sub >/dev/null 2>&1
fi