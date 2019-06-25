#! /bin/bash
datename='/data/logs/nohup/'$(date +%Y_%m_%d)_quizeserver'.log'
if [ ! -d "/data/logs/nohup/" ]; then
  mkdir -p -m 755 /data/logs/nohup/
  echo "sudo mkdir -p -m 755 ${static_dir} done"
fi
cp -f /data/logs/quizserver.log $datename
echo "" > /data/logs/quizserver.log
find /data/logs/nohup/ -mtime +30 -name "*.log" -exec rm -rf {} \
