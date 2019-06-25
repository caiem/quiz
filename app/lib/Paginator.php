<?php

class Paginator
{
    private static $first_page = 1;     //第一页
    private static $previous_page = 1;   //上一页
    private static $next_page = 0;      //下一页
    private static $last_page;      //最后一页
    private static $total_page;     //总页数
    private static $bothnum = 2;

    public static $current_page;   //当前页
    public static $total_number = 0;   //总行数
    public static $limit = 20;         //每页行数
    public static $base_url = '';

    public static function getPaginate(){
        self::$total_page = ceil(self::$total_number/self::$limit);
        //处理当前页为负页的情况
        self::$current_page = intval(self::$current_page) < 1 ? 1 :self::$current_page;
        //处理当前页大于总页数的情况
        self::$current_page = self::$current_page > self::$total_page && self::$total_page !=0 ?self::$total_page:self::$current_page;
        //处理下一页
        self::$next_page = self::$current_page < self::$total_page?self::$current_page +1:self::$current_page;
        //处理最后一页
        self::$last_page = self::$total_page;
        //处理上一页
        self::$previous_page = self::$current_page >1 ? self::$current_page -1:1;

        return array(
            'total_page' => self::$total_page,
            'current_page' => self::$current_page,
            'limit' => self::$limit
        );
    }

    public static function getPaginateHtml(){
        //初始化分页
        self::getPaginate();
        if( self::$total_page ==0 ){
            return '<div style="text-align:center;margin:0 auto">NO Records Found</div>';
        }
        $op = ( strpos(self::$base_url, '?') == false )?'?':'&';
        $string = '<ul class="pagination pagination-sm no-margin pull-right">';
        if(self::$current_page == self::$first_page){
            $string .= '<li class="disabled"><a>&laquo;</a></li>';
        }else{
            $string .= '<li><a href="'. self::$base_url . "{$op}page=" . self::$previous_page .'">&laquo;</a></li>';
        }
        if (self::$current_page > self::$bothnum+1) {
            $string .= '<li><a href="'. self::$base_url . $op.'page=1">1</a></li>';
        }
        if(self::$current_page < 3){
            self::$bothnum = self::$bothnum =4;
        }

        for ($i=self::$bothnum;$i>=1;$i--) {
            $current_page = self::$current_page - $i;
            if ($current_page < 1) {
                continue;
            }
            $string .= '<li><a href="'. self::$base_url . $op.'page='.$current_page.'">'.$current_page.'</a></li>';
        }
        $string .= '<li class="active"><a>'.self::$current_page.'</a></li>';
        for ($i=1;$i<=self::$bothnum;$i++) {
            $current_page = self::$current_page+$i;
            if ($current_page > self::$total_page) {
                break;
            }
            $string .= '<li><a href="'. self::$base_url . $op.'page='.$current_page.'">'.$current_page.'</a></li>';
        }

        if (self::$total_page - self::$current_page > self::$bothnum) {
            $string .= '<li><a href="'. self::$base_url . $op.'page='.self::$total_page.'">'.self::$total_page.'</a></li>';
        }

            if(self::$current_page == self::$total_page){
            $string .= '<li class="disabled"><a>&raquo;</a></li>';
        }else{
            $string .= '<li><a href="'. self::$base_url . "{$op}page=" . self::$next_page .'">&raquo;</a></li>';
        }

        $string .= '</ul>';
        return $string;
    }
}
