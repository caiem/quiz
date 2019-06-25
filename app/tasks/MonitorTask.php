<?php

use Phalcon\Cli\Task;

class MonitorTask extends Task
{
    /*
     * //            $redis->subscribe(array(RedisKey::INTER_API),
     * $cli = new Swoole\Coroutine\Http2\Client($domain, 80);
                       $cli->set([
                           'timeout' => 5,
                           'package_max_length' => 10000000,
                       ]);
                       $cli->connect();
                       $req = new swoole_http2_request;
                       $req->method = 'POST';
                       $req->path = '/api/manager/external/user/login';
                       $req->headers = [
                           'host' => $domain,
                           "user-agent" => 'Chrome/60.0.2587.3',
                           'accept' => 'application/json',
                       ];

                       $req->data = jsonEncode($msg);
                       $cli->send($req);
                       $response = $cli->recv();
                       var_dump($response);
                       echo $response->data;*/
    /*$cli = new Swoole\Coroutine\Http\Client($domain, 80);
                          $cli->setHeaders([
                              'Host' => $domain,
                              "User-Agent" => 'Chrome/49.0.2587.3',
                              'Accept' => 'text/html,application/xhtml+xml,application/xml',
                              'Content-Type: application/json; charset=utf-8',
                          ]);
                          $cli->set(['timeout' => 1]);
                          $cli->post('/api/manager/external/user/login',$msg);
                          echo $cli->body;
                          $cli->close();*/
    public function subAction()
    {
        try {
            $redis = $this->di->get('redis');

            while (1) {
                $message = $redis->lPop(RedisKey::INTER_API);
                if (empty($message)) {
                    exit();
                }
//                go(function () use ($message) {
                $domain = IS_TEST ? Config::ALLOW_ORIGIN_TEST : 'openisv.ybj.com';
                $reqtime = mSectime();

                $msg = json_decode($message, 1);
                $msg['appId'] = '2001';
                $msg['timestamp'] = $reqtime;
                $msg['sign'] = strtoupper(md5((IS_TEST ? '2001hgw77v8qjcv56m81' : "2001udkl403lj_6p9hfk") . $reqtime));
                $msg['gameId'] = 5001;
                $msg = jsonEncode($msg);

                $res = Common::curl_http($domain . '/api/manager/external/user/login', $msg, 10, 1, 1);
                if ($res['code'] != 200) {
                    $this->di->getShared('logger')->info(jsonEncode($res));
                }
                usleep(4);
//                });
            }
        } catch (Exception $e) {
            $this->di->getShared('logger')->error('CLI Error[' . $e->getFile() . ':' . $e->getLine() . ']: ' . $e->getMessage());
        }

    }

    public function tmpAction()
    {
        $sql = "CREATE TABLE `retain` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `date` int(8) unsigned NOT NULL DEFAULT '0',
  `yesterday` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `threeday` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `sevenday` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `thrityday` decimal(10,2) unsigned NOT NULL DEFAULT '0.00',
  `loginuser` int(11) unsigned NOT NULL DEFAULT '0' COMMENT '登录用户数',
  `adduser` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `d` (`date`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
";
        $res = $this->di->getDb()->execute($sql);
        echo $res;

        $sql = '      ALTER TABLE `user`
ADD INDEX `c` (`createTime`) USING BTREE ,
ADD INDEX `l` (`loginTime`) USING BTREE ;
';
        $res = $this->di->getDb()->execute($sql);
        echo $res;
    }

    public function ansAction()
    {
        try {
            $today = date('Ymd');
            $todayTime = strtotime($today);
            $yesterdate = date('Ymd', strtotime("-1 day"));
            $yesterdateTime = strtotime($yesterdate);
            $condition = array(
                'conditions' => 'date =:uid:',
                'bind' => array('uid' => $yesterdate,)
            );
            $exist = Retain::findFirst($condition);
            if (!empty($exist)) {
                echo 'exist ' . $yesterdate;
                return false;
            }
//            $login = $this->redis->pfcount(\RedisKey::LOGIN_UNIQUE_USERS . $yesterdate);
            $sql = "SELECT COUNT(*) as cc from `user` where loginTime>={$yesterdateTime}";
            $data = $this->getDI()->getDb()->fetchOne($sql);
            $add = new Retain();
            $add->date = $yesterdate;
            $add->loginuser = (int)$data['cc'];

            $sql = "SELECT COUNT(*) as cc from `user` where createTime>={$yesterdateTime}";
            $data = $this->getDI()->getDb()->fetchOne($sql);
            $add->adduser = (int)$data['cc'];

            foreach ([2 => 'yesterday', 3 => 'threeday', 7 => 'sevenday', 30 => 'thrityday'] as $dayKey => $dayType) {
                $time = $yesterdateTime - 86400 * ($dayKey - 1);
                $timeTmp = $time + 86399;
                $sql = "SELECT COUNT(*) as cc from `user` where createTime between {$time} and {$timeTmp} and loginTime between {$yesterdateTime} and " . ($todayTime - 1);
                $mo = $this->getDI()->getDb()->fetchOne($sql);
                $mo = (int)$mo['cc'];

                $sql = "SELECT COUNT(*) as cc from `user` where createTime between {$time} and {$timeTmp} ";
                $de = $this->getDI()->getDb()->fetchOne($sql);
                $de = (int)$de['cc'];

                $add->{$dayType} = !empty($de) ? round($mo / $de, 2) : 0;
            }

            $add->save();
            echo 'done ';
        } catch (Exception $e) {
            echo $e->getMessage();
            $this->di->getShared('logger')->error('CLI Error[' . $e->getFile() . ':' . $e->getLine() . ']: ' . $e->getMessage());
        }
    }
}