#!/bin/bash

#term-sd初始化部分
function term_sd_init()
{
    term_sd_modules_number=$(( $(ls ./term-sd/modules/*.sh |wc -w) - 1 ))
    term_sd_modules_number_=1
    for term_sd_modules in ./term-sd/modules/*.sh ;do
        [ $term_sd_modules = "./term-sd/modules/init.sh" ] && continue
        term_sd_init_bar_1="$term_sd_modules_number_/$term_sd_modules_number"
        term_sd_init_bar_2=$(echo $term_sd_modules | awk -F'/' '{print $NF}')
        printf "[$term_sd_init_bar_1] 加载 ${term_sd_init_bar_2}                               \r"
        term_sd_modules_number_=$(( "$term_sd_modules_number_" + 1 ))
        source $term_sd_modules
    done
    printf "初始化Term-SD完成                               \n"
    echo "启动Term-SD中"
    term_sd_version
}

#设置启动时脚本路径
export start_path=$(pwd)

#设置虚拟环境
if [ -f ./term-sd/term-sd-venv-disable.lock ];then #找到term-sd-venv-disable.lock文件,禁用虚拟环境
    venv_active="1"
    venv_info="禁用"
else
    venv_active="0"
    venv_info="启用"
fi

term_sd_version_="0.4.0"

#初始化功能
term_sd_init