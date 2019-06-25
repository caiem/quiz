<?php

use Phalcon\Cli\Task;

class QuestionTask extends Task
{
    public function reRankAction()
    {
        InfoLogic::getInstance()->initRank();
    }

    public function importAction()
    {

        $fileName = 'C:\Users\Administrator\Desktop\金榜题名题库5-8.txt';
        $con = file_get_contents($fileName);
        $con = GbkToUtf8($con);
        $arr = explode("\n", $con);
        foreach ($arr as $lll => $item) {
            if (empty($lll)) {
                continue;
            }
            $row = explode("\t", $item);
            $q = $row[1];

            $op1 = trim($row[2]);

            $op2 = trim($row[3]);

            $ans = strpos(strtoupper($row[4]), 'B') !== false ? $op2 : $op1;

            if (empty($ans) || empty($q) || empty($op1) || empty($op2)) {
                echo $item . PHP_EOL;
                continue;
            }
            $model = new \Question();
            $model->q = $q;
            $model->op1 = $op1;
            $model->op2 = $op2;
            $model->ans = $ans;
            try {
                $model->create();
            } catch (\Exception $e) {
                echo $e->getMessage() . PHP_EOL;
            }
        }
    }

    public function createAction()
    {
        $page = 0;
        $redis = $this->di->getShared('redis');
        $redis->del(RedisKey::$queAllTmp);
        while (1) {
            echo $page . PHP_EOL;
            $condition = array(
                'order' => 'id ASC',
                'limit' => ['number' => 50, 'offset' => $page * 50],
            );
            $data = Question::find($condition)->toArray();
            if (empty($data)) {
                break;
            }
            $page++;

            foreach ($data as $v) {
                if (empty($v['id'])) {
                    continue;
                }
                $res = $redis->set(RedisKey::$queInfo . $v['id'], jsonEncode(['q' => $v['q'], 'op1' => $v['op1'], 'op2' => $v['op2'], 'ans' => $v['ans']]));
                if ($res) {
                    $redis->SADD(RedisKey::$queAllTmp, $v['id']);
                }
            }
        }
        if ($redis->SCARD(RedisKey::$queAllTmp)) {
            $res = $redis->rename(RedisKey::$queAllTmp, RedisKey::$queAll);
            echo 'rename ' . $res;
        }
    }

    public function checkAction()
    {
        $redis = $this->di->getShared('redis');

        if (!$redis->exists(RedisKey::$queAll)) {
            echo RedisKey::$queAll . ' key not exists' . PHP_EOL;
            $this->createAction();
        }

        echo 'done ' . PHP_EOL;
    }

    public function rankAction()
    {
        InfoLogic::getInstance()->initRank();
        echo 'reRank over' . PHP_EOL;
    }

    public function clearAction()
    {
        $sql = "update question set op1='2000年7月1日',op2='2000年10月1日',ans='2000年10月1日' where id=600";
        $res = $this->di->getDb()->execute($sql);
        echo $res;
    }
}