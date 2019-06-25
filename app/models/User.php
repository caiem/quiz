<?php

use Phalcon\Mvc\Model;

class User extends Model
{

    public $uid, $phone, $createTime, $loginTime,
        $openid, $name, $img, $status, $ip, $appkey, $type;

    CONST DEFAULT_IMG = '/img/logo.png';

    public function initialize()
    {
        $this->useDynamicUpdate(true);
        $this->setSource($this->getSource());
    }

    public function getSource()
    {
        return 'user';
    }

    CONST RANK_TO_LEVEL = [
        '初入学堂' => 0,
        '升堂入室' => 1,
        '学富五车' => 2,
        '才高八斗' => 3,
        '博古通今' => 4,
        '超凡入圣' => 5,
        '文曲星' => 6,
        '智慧天尊' => 7,
    ];

    const CANT_REDUCE_RANK = 2;

    CONST AI_USERS = array(
        0 => [
            0 =>
                array(
                    0 => '猪猪侠',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/4907764cae7eb270!400x400_big.jpg',
                ),
            2 =>
                array(
                    0 => '炫炫',
                    1 => 2,
                    2 => 'https://images.vrm.cn/2019/04/23/ul132685643-3.jpg',
                ),
            1 =>
                array(
                    0 => '小狮子',
                    1 => 3,
                    2 => 'https://images.vrm.cn/2019/03/07/946349ab8ffa6ec1!400x400_big.jpg',
                ),
            15 =>
                array(
                    0 => '映芬',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/6f2ff9639e429614!400x400_big.jpg',
                ),
            16 =>
                array(
                    0 => '思雨',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=3986076527,3305701212&fm=26&gp=0.jpg',
                ),
            17 =>
                array(
                    0 => '怜梦',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=3959233909,1278736793&fm=26&gp=0.jpg',
                ),
            18 =>
                array(
                    0 => '忆琳',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=3855802134,7846286&fm=26&gp=0.jpg',
                ),
            19 =>
                array(
                    0 => '秋天的童话',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=2733493575,2659718431&fm=26&gp=0.jpg',
                ),
            20 =>
                array(
                    0 => '舒涵',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=2671618606,2439075475&fm=11&gp=0.jpg',
                ),
            21 =>
                array(
                    0 => '阿呆',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=1775106227,3980876030&fm=26&gp=0.jpg',
                ),
        ],
        1 =>
            array(
                0 =>
                    array(
                        0 => '造梦者',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/5b53485e9b8a8b70!400x400_big.jpg',
                    ),
                1 =>
                    array(
                        0 => '小太郎',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/4a337c403ec74d3181356dbe7eaf78e0!400x400.jpeg',
                    ),
                2 =>
                    array(
                        0 => '奔跑',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/3c97e817a6264430b7a4dc37482d8f48!400x400.jpeg',
                    ),
                3 =>
                    array(
                        0 => '蜗牛',
                        1 => 3,
                        2 => 'https://images.vrm.cn/2019/03/07/1e6f257757ad5d81!400x400_big.jpg',
                    ),
                4 =>
                    array(
                        0 => '左岸',
                        1 => 3,
                        2 => 'https://images.vrm.cn/2019/03/07/1a72191ff13b49e3!400x400_big.jpg',
                    ),
                5 =>
                    array(
                        0 => '李长财',
                        1 => 3,
                        2 => 'https://images.vrm.cn/2019/03/07/1a7c24ea34aa2b86!400x400_big.jpg',
                    ),
                6 =>
                    array(
                        0 => '李红良',
                        1 => 3,
                        2 => 'https://images.vrm.cn/2019/03/07/0f1380618bfc4f47ac0f56e86aa4daf4!400x400.jpeg',
                    ),
                7 =>
                    array(
                        0 => '糯糯',
                        1 => 3,
                        2 => 'https://images.vrm.cn/2019/03/07/0db275145b12516e!200x200.jpg',
                    ),
                8 =>
                    array(
                        0 => '犀利哥',
                        1 => 3,
                        2 => 'https://images.vrm.cn/2019/03/07/08181517808862.jpg',
                    ),
                9 =>
                    array(
                        0 => '咖啡豆',
                        1 => 3,
                        2 => 'https://images.vrm.cn/2019/03/07/02230801290232.jpg',
                    ),
                10 =>
                    array(
                        0 => '左孤鸿',
                        1 => 3,
                        2 => 'https://images.vrm.cn/2019/03/07/02230801290025.jpg',
                    ),


            ),
        2 =>
            array(
                0 =>
                    array(
                        0 => '墨小颜',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/62286b64856349f19698f60c2ddfe783!400x400.jpeg',
                    ),
                1 =>
                    array(
                        0 => '课代表',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/21071ed8e4fc83b0!400x400_big.jpg',
                    ),
                2 =>
                    array(
                        0 => '安良',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/7336f9b59b071144!200x200.jpg',
                    ),
                3 =>
                    array(
                        0 => '摩卡',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/4177a44418c745b89ae7d91d58be67f7!400x400.jpeg',
                    ),
                4 =>
                    array(
                        0 => '李昌睿',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/3327fe35c73daa44!200x200.jpg',
                    ),
                5 =>
                    array(
                        0 => '李泉龙',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/529c90284209cf7c!400x400_big.jpg',
                    ),
                6 =>
                    array(
                        0 => '卓臻',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/376a578c2cf44b9f!400x400_big.jpg',
                    ),
                7 =>
                    array(
                        0 => '张晓雨',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/374b8d13190a4178!400x400_big.jpg',
                    ),
                8 =>
                    array(
                        0 => '少菊',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/323a281a78e44dbabd78b61311bb1eab!400x400.jpeg',
                    ),
                9 =>
                    array(
                        0 => '雅舒',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/76a56256770fc8c0!400x400_big.jpg',
                    ),
                10 =>
                    array(
                        0 => '李昌逊',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/27ef021179a74bb4a4b5f4c51bdecb7d!400x400.jpeg',
                    ),
                11 =>
                    array(
                        0 => '李建利',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/9d68ae3544fd45aca4de71f2026ee85a!400x400.jpeg',
                    ),
                12 =>
                    array(
                        0 => '李泰福',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/9b5a478c8ffda841!400x400_big.jpg',
                    ),
                13 =>
                    array(
                        0 => '紫月',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/9a68831f24d2985b!360x360_big.jpg',
                    ),
                14 =>
                    array(
                        0 => '梦婵',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/9a3c786715c901ae!400x400_big.jpg',
                    ),


            ),
        3 =>
            array(
                0 =>
                    array(
                        0 => '王师傅',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/e1fc41069bb2ac7a!400x400_big.jpg',
                    ),
                1 =>
                    array(
                        0 => 'LLL',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/d3f6e22e88896a05!400x400_big.jpg',
                    ),
                2 =>
                    array(
                        0 => '柳叶',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/c886e62e83cc4ade!400x400_big.jpg',
                    ),
                3 =>
                    array(
                        0 => '雅静',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/a2366e2404401773!400x400_big.jpg',
                    ),
                4 =>
                    array(
                        0 => '张雨佩',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/a139daa0471f0e42!400x400_big.jpg',
                    ),
                5 =>
                    array(
                        0 => 'LDS',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/a38cbc4ab3514d43832813a356e564f2!400x400.jpeg',
                    ),
                6 =>
                    array(
                        0 => '刘乐熙',
                        1 => 1,
                        2 => 'https://images.vrm.cn/2019/03/07/2018031110595473854.jpg',
                    ),
                7 =>
                    array(
                        0 => '慕容',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/2018031110595465574.jpg',
                    ),
                8 =>
                    array(
                        0 => '李妍雅',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/2018031110595464369.jpg',
                    ),
                9 =>
                    array(
                        0 => '婧涵',
                        1 => 2,
                        2 => 'https://images.vrm.cn/2019/03/07/2018031110581294842.jpg',
                    ),
                10 =>
                    array(
                        0 => '刘阳',
                        1 => 3,
                        2 => 'https://images.vrm.cn/2019/03/07/2018031110581262923.jpg',
                    ),
                11 =>
                    array(
                        0 => '万万',
                        1 => 3,
                        2 => 'https://images.vrm.cn/2019/03/07/12091337894691.jpg',
                    ),
            ),
        4 => [
            11 =>
                array(
                    0 => '琉璃猫',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/2022162826295.jpg',
                ),
            12 =>
                array(
                    0 => '土豆',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/175936192580.jpg',
                ),
            13 =>
                array(
                    0 => '皮皮虾',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/132873283241.jpg',
                ),
        ],
        5 => [
            12 =>
                array(
                    0 => '芳华',
                    1 => 3,
                    2 => 'https://images.vrm.cn/2019/03/07/12091337892676.jpg',
                ),
            13 =>
                array(
                    0 => '芳芳',
                    1 => 3,
                    2 => 'https://images.vrm.cn/2019/03/07/10010909909740.jpg',
                ),
            14 =>
                array(
                    0 => '孙建军',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/08181517814044.jpg',
                ),
            15 =>
                array(
                    0 => '万水千山',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/08181517811362.jpg',
                ),
        ],
        6 => [
            29 =>
                array(
                    0 => '吉吉',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=342427603,42798673&fm=26&gp=0.jpg',
                ),
            30 =>
                array(
                    0 => '珊珊',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=146529870,1993977542&fm=26&gp=0.jpg',
                ),
            31 =>
                array(
                    0 => '萤火虫',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/f66896d4e2c06e96!200x200.jpg',
                ),
            32 =>
                array(
                    0 => '高蔷',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/f62422a06df24014b212c9460407a695!400x400.jpeg',
                ),
            33 =>
                array(
                    0 => '张雨静',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/f04726c5173d0eed!400x400_big.jpg',
                ),
            34 =>
                array(
                    0 => '大笑',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/e4a9803ff4a411bd!200x200.jpg',
                ),
            35 =>
                array(
                    0 => '闲人',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/e4a5eedffb4b470f84d9d5a54b762985!400x400.jpeg',
                ),
        ],
        7 => [
            22 =>
                array(
                    0 => '绮文',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=1748248976,1358628642&fm=11&gp=0.jpg',
                ),
            23 =>
                array(
                    0 => '智美',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=1611334098,281986248&fm=26&gp=0.jpg',
                ),
            24 =>
                array(
                    0 => '郑淑燕',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=824446400,2033670241&fm=11&gp=0.jpg',
                ),
            25 =>
                array(
                    0 => '林怡新',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=765107238,957846343&fm=26&gp=0.jpg',
                ),
            26 =>
                array(
                    0 => '王家云',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=521807949,3504935989&fm=26&gp=0.jpg',
                ),
            27 =>
                array(
                    0 => '旅行家',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=496436324,4124731271&fm=11&gp=0.jpg',
                ),
            28 =>
                array(
                    0 => '橘猫',
                    1 => 4,
                    2 => 'https://images.vrm.cn/2019/03/07/u=480717859,1531926143&fm=11&gp=0.jpg',
                ),
        ]
    );
}