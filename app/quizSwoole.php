<?php

class  quizSwoole
{
    private $cli, $webapp;

    private $appPath, $isTestEnv;

    public function __construct()
    {
        $this->appPath = '/data/wwwroot/quiz/current';
        $_env = $this->appPath . '/.env';
        $this->isTestEnv = false;
        if (file_exists($_env)) {
            $env = file_get_contents($_env);
            if (strpos($env, 'ENV=DEV') !== false) {
                $this->isTestEnv = true;
            }
        }
    }

    /*发送通知*/
    public function msgData($status = 0, $type = '', $msg = '', $data = [])
    {
        $re_msg = [];
        $re_msg['code'] = $status;
        $re_msg['cmd'] = $type;
        $re_msg['msg'] = $msg;
        $re_msg['data'] = $data;
        return jsonEncode($re_msg);
    }

    public function checkToken($msgData)
    {
        if (empty($msgData) || !is_array($msgData) || empty($msgData['accessToken']) || empty($msgData['cmd']) || empty($msgData['uid'])) {
            return false;
        }

  

        if ($msgData['accessToken'] != md5(\Config::$authKey . (int)$msgData['uid'] . (int)$msgData['expireTime'])) {
            return false;
        }
        return true;
    }


    public function wsAction()
    {
        ini_set('memory_limit', 0);
        set_time_limit(0);
        echo "This is swoole websocket server" . PHP_EOL;
        swoole_set_process_name("quiz server");
        $server = new swoole_websocket_server("0.0.0.0", 9501, SWOOLE_PROCESS, SWOOLE_SOCK_TCP | SWOOLE_SSL);
        $server->set(array(
//            'worker_num' =>swoole_cpu_num(),   //工作进程数量
            'daemonize' => true, //是否作为守护进程
            'heartbeat_idle_time' => 660,
            'heartbeat_check_interval' => 60,
            'max_request' => 50000,//tmp
            'backlog' => 8000,
            'reload_async' => true,
            'max_wait_time' => 100,
            'log_level' => 2,
            'log_file' => '/data/logs/quizserver.log',
            'ssl_cert_file' => '',
            'ssl_key_file' => '',//tmp
        ));

        $server->on('WorkerStart', function ($serv, $workerId) {
            try {
                opcache_reset();
            } catch (Exception $e) {

            }
//            print_r(get_included_files()); //此数组中的文件表示进程启动前就加载了，所以无法reload

            echo date('Y-m-d H:i:s') . PHP_EOL;
            echo $this->appPath . PHP_EOL;
            $this->cli = require_once($this->appPath . "/app/quizConsole.php");
//            $this->webapp = require_once($this->appPath . "/app/quizConsole.php");
        });

        $server->on('Request', function (\Swoole\Http\Request $request, \Swoole\Http\Response $response) use ($server) {
            if ($request->server['request_uri'] == '/favicon.ico') {
                $response->end();
                return;
            }

            echo '    URL: ' . ($request->server['request_uri'] ?? '') . PHP_EOL . PHP_EOL;
            $msg = '';
            // 通过链接参数热重载 worker 进程观察触发事件
            $act = $request->get['actdodododo'] ?? '';
            if ($act == 'reload') {
                echo '    ... Swoole Reloading ! ... ' . PHP_EOL . PHP_EOL;
                // 触发 reload 之后, 貌似后面的代码也还是会执行的
                $server->reload();
//                echo 'new hzy reload' . PHP_EOL;
                echo '    ... Under Reload ! ... ' . PHP_EOL . PHP_EOL; // 看看 reload 时是否会执行后续的代码
            } elseif ($act == 'count') {
                $msg = count($server->connections);
            }

            /* elseif ($act == 'exit') {
                // 直接立即终止当前 worker 进程, 和 reload 的效果比较相似, 新的 worker 进程的 ID 和原来的一样
                // 所以程序内部应该尽量避免使用 exit 而应该抛出异常在外部 catch
                echo '    ... Swoole Exit ! ... ' . PHP_EOL . PHP_EOL;
                exit;
            } elseif ($act == 'shutdown') {
                // 直接立即终止当前 worker 进程, 和 reload 的效果比较相似, 新的 worker 进程的 ID 和原来的一样
                // 所以程序内部应该尽量避免使用 exit 而应该抛出异常在外部 catch
                echo '    ... Swoole Shutdown ! ... ' . PHP_EOL . PHP_EOL;
                $server->shutdown();
                echo '    ... After Swoole Shutdown ! ... ' . PHP_EOL . PHP_EOL;
            }*/
//            $response->header("X-Server", "Swoole");

            $response->end($msg);
        });

        $server->on('connect', function ($server, $frame) {
            echo $frame . "Client:Connect.\n";
        });

        $server->on('WorkerExit', function (swoole_server $server, $worker_id) {
            echo 'workerExit ' . $worker_id . PHP_EOL;
        });
        $server->on('Start', function ($server) {
            cli_set_process_title("quiz_reload_master");
        });

        $server->on("open", function ($server, $request) {
//            var_dump($request->fd, $request->get, $request->server);
//            $server->push($request->fd, "hello, welcome\n");
        });

        $server->on("message", function (swoole_websocket_server $server, swoole_websocket_frame $frame) {
            $this->cli->handle(array(
                'task' => 'Swooletime',
                'action' => 'ws',
                'params' => ['frame' => $frame, 'server' => $server]
            ));
        });
        $server->on('close', function ($server, $fd) {
            $this->cli->handle(array(
                'task' => 'Swooletime',
                'action' => 'close',
                'params' => ['fd' => $fd]
            ));
//            echo "client-{$fd} is closed\n";
        });

        $server->start();
        $this->server = $server;
    }

}

$s = new quizSwoole();
$s->wsAction();