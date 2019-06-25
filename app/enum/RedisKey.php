<?php

class RedisKey
{
    public static $mobileTimes = 'mobileTimes:';
    public static $mobileTern = 'mobileTern:';
    public static $mobileCode = 'mobileCode:';
    public static $mobileCodeTryTImes = 'mobileCodeTryTimes:';
    public static $userInfo = 'userInfo:';
    public static $dailyInfo = 'dailyInfo:';
    public static $signInfo = 'signInfo:';
    public static $todayIsLogin = 'todayIsLogin:';
    public static $checkIsSigned = 'checkIsSigned:';
    public static $packageInfo = 'packageInfo:';

    public static $addMoneyCard = 'addMoneyCard:';
    public static $addScoreCard = 'addScoreCard:';
    public static $FriendCardIsGet = 'friendCardIsGet:';
    public static $inviteFriendJoinList = 'inviteFriendJoin:';
    CONST INVITE_FRIEND_TODAY_LIST = 'inviteFriendToday:';//当日按邀请列表
    public static $isJoinRankGames = 'inJoinRank:';//今天是否参加排位赛

    public static $rankList = 'rankList:';
    const RANK_SORT = '{rankSort}:';
    const RANK_SORT_TMP = '{rankSort}Tmp:';
    public static $rankListAll = 'rankListAll:';

    public static $drawList = 'drawList:';

    public static $roleList = 'roleList:';

    public static $gameRankFd = 'gameRankFd:';
    public static $gameRankFdToUser = 'gameRankFdToUser:';
    public static $gameOnlineFd = 'gameOnline:';
    public static $gameIsPlay = 'gameOnisPlay:';
    public static $gameRoom = 'gameRoom:';
    Const GAME_ROOM_COUNT = 'gameRoomCount:';

    public static $queAll = '{queAll}';//hash cao
    public static $queAllTmp = '{queAll}Tmp';
    public static $queInfo = '{queAll}Info:';

    const USER_RIGHT_NUM = 'userRightNum:';//当前用户回答正确数
    //统计keys
    const LOGIN_UNIQUE_USERS = 'LoginUniqueUsers:';//当日登录人数
    const COUNT_UNIQUE_USERS = 'takeInUniqueUsers:';//当日参与人数
    const COUNT_RANK_UNIQUE_USERS = 'takeInRankUniqueUsers:';//当日参与人数
    const RANK_TAKE_TIMES = 'rankTakeTimes:';//排位参与次数

    const COUNT_FRIEND_UNIQUE_USERS = 'takeInFriendUniqueUsers:';//当日参与人数
    const FRIEND_TAKE_TIMES = 'FriendTakeTimes:';//好友赛参与次数
    public static $friendAbandonTimes = 'friendAbandonTimes';

    const DAILY_VISIT_TIMES = 'dailyVisitTimes';
    const DAILY_SIGN_TIMES = 'dailySignTimes';
    const TAKE_RANK_TIMES = 'take1RankTimes';
    const COST_300_TIMES = 'cost300Times';
    const SHARE_FRIEND_TIMES = 'shareFriendTimes';
    const INVITE_3_FRIEND_TIMES = 'invite3FriendTimes';
    const PLAY_FRIEND_TIMES = 'playFriendTimes';

    const PACKAGE_TIMES = 'packageTimes';
    const PACKAGE_TIMES_TYPE = 'packageTimesType';

    const RANK_OPEN_TIMES = 'rankOpenTimes';
    const DRAW_TIMES = 'drawTimes';
    const MERGE_ROLE_TIMES = 'mergeRoleTimes';

    const INTER_API = '{userLogin}';

    public static function getUserInfoKey($uid)
    {
        return RedisKey::$userInfo . $uid;
    }

}
