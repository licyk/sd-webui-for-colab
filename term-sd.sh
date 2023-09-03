#!/bin/bash
echo "######## ######## ########  ##     ##     ######  ########  "
echo "   ##    ##       ##     ## ###   ###    ##    ## ##     ## "
echo "   ##    ##       ##     ## #### ####    ##       ##     ## "
echo "   ##    ######   ########  ## ### ##     ######  ##     ## "
echo "   ##    ##       ##   ##   ##     ##          ## ##     ## "
echo "   ##    ##       ##    ##  ##     ##    ##    ## ##     ## "
echo "   ##    ######## ##     ## ##     ##     ######  ########  "
#使用figlet制作

echo "Term-SD初始化中......"
###############################################################################

#主界面部分

#term-sd分支设置
term_sd_branch=main
#设置启动时脚本路径
start_path=$(pwd)
#设置虚拟环境
if [ -f ./term-sd-venv-disable.lock ];then #找到term-sd-venv-disable.lock文件,禁用虚拟环境
    venv_active="1"
    venv_info="禁用"
else
    venv_active="0"
    venv_info="启用"
fi

#主界面
function mainmenu()
{
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    mainmenu_select=$(
        dialog --clear --title "Term-SD" --backtitle "主界面" --ok-label "确认" --cancel-label "取消" --menu "请选择Term-SD的功能\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')\n当前虚拟环境状态:"$venv_info"" 20 60 10 \
        "0" "venv虚拟环境" \
        "1" "AUTOMATIC1111-stable-diffusion-webui" \
        "2" "ComfyUI" \
        "3" "InvokeAI" \
        "4" "lora-scripts" \
        "5" "更新脚本" \
        "6" "扩展脚本" \
        "7" "pip镜像源" \
        "8" "pip缓存清理" \
        "9" "帮助" \
        "10" "退出" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0  ];then #选择确认
        if [ "${mainmenu_select}" == '0' ]; then #选择venv虚拟环境
            venv_option
        elif [ "${mainmenu_select}" == '1' ]; then #选择AUTOMATIC1111-stable-diffusion-webui
            a1111_sd_webui_option
        elif [ "${mainmenu_select}" == '2' ]; then #选择ComfyUI
            comfyui_option
        elif [ "${mainmenu_select}" == '3' ]; then #选择InvokeAI
            invokeai_option
        elif [ "${mainmenu_select}" == '4' ]; then #选择lora-scripts
            lora_scripts_option
        elif [ "${mainmenu_select}" == '5' ]; then #选择更新脚本
            update_option
        elif [ "${mainmenu_select}" == '6' ]; then #选择扩展脚本
            term_sd_extension
        elif [ "${mainmenu_select}" == '7' ]; then #选择pip镜像源
            set_proxy_option
        elif [ "${mainmenu_select}" == '8' ]; then #选择pip缓存清理
            pip_cache_clean
        elif [ "${mainmenu_select}" == '9' ]; then #选择帮助
            info_option
        elif [ "${mainmenu_select}" == '10' ]; then #选择退出
            echo "退出Term-SD"
            exit 1
        fi
    else #选择取消
        echo "退出Term-SD"
        exit 1
    fi
}

#a1111_sd_webui_option选项
function a1111_sd_webui_option()
{
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "stable-diffusion-webui" ];then #找到stable-diffusion-webui目录
        cd stable-diffusion-webui
        final_a1111_sd_webui_option=$(
            dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择A1111-SD-Webui管理选项的功能\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "管理插件" \
            "5" "切换版本" \
            "6" "启动" \
            "7" "重新安装" \
            "8" "重新安装pytorch" \
            "9" "重新生成venv虚拟环境" \
            "10" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ "${final_a1111_sd_webui_option}" == '1' ]; then
                echo "更新A1111-Stable-Diffusion-Webui中"
                test_num=1
                git pull
                if [ $? = 0 ];then
                    test_num=0
                fi
                if [ $test_num = "0" ];then
                    dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui更新结果" --msgbox "A1111-SD-Webui更新成功" 20 60
                else
                    dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui更新结果" --msgbox "A1111-SD-Webui更新失败" 20 60
                fi
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '2' ]; then
                if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui删除选项" --yesno "是否删除A1111-Stable-Diffusion-Webui?" 20 60) then
                    echo "删除A1111-Stable-Diffusion-Webui中"
                    exit_venv
                    cd ..
                    rm -rfv ./stable-diffusion-webui
                else
                    a1111_sd_webui_option
                fi
            elif [ "${final_a1111_sd_webui_option}" == '3' ]; then
                echo "修复更新中"
                git checkout master
                git reset --hard HEAD
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '4' ]; then
                cd extensions
                extension_methon
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '5' ]; then
                git_checkout_manager
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '6' ]; then
                if [ -f "./term-sd-launch.conf" ]; then #找到启动脚本
                    if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui启动选项" --yes-label "启动" --no-label "修改参数" --yesno "请选择启动A1111-SD-Webui/修改A1111-SD-Webui启动参数\n当前启动参数:\npython $(cat ./term-sd-launch.conf)" 20 60) then
                        term_sd_launch
                        a1111_sd_webui_option
                    else #修改启动脚本
                        generate_a1111_sd_webui_launch
                        term_sd_launch
                        a1111_sd_webui_option
                    fi
                else #找不到启动脚本,并启动脚本生成界面
                generate_a1111_sd_webui_launch
                term_sd_launch
                a1111_sd_webui_option
                fi
            elif [ "${final_a1111_sd_webui_option}" == '7' ]; then
                if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui重新安装选项" --yesno "是否重新安装A1111-Stable-Diffusion-Webui?" 20 60) then
                cd "$start_path"
                exit_venv
                process_install_a1111_sd_webui
                a1111_sd_webui_option
                fi
            elif [ "${final_a1111_sd_webui_option}" == '8' ]; then
                pytorch_reinstall
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '9' ]; then
                venv_generate
                a1111_sd_webui_option
            elif [ "${final_a1111_sd_webui_option}" == '10' ]; then
                mainmenu #回到主界面
            fi
        fi
    else #找不到stable-diffusion-webui目录
        if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui安装选项" --yesno "检测到当前未安装A1111-Stable-Diffusion-Webui,是否进行安装?" 20 60) then
            process_install_a1111_sd_webui
            a1111_sd_webui_option
        fi
    fi
    mainmenu #处理完后返回主界面
}


#comfyui选项
function comfyui_option()
{
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "ComfyUI" ];then
        cd ComfyUI
        final_comfyui_option=$(
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI管理选项的功能\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "自定义节点管理" \
            "5" "插件管理" \
            "6" "切换版本" \
            "7" "启动" \
            "8" "重新安装" \
            "9" "重新安装pytorch" \
            "10" "重新生成venv虚拟环境" \
            "11" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ "${final_comfyui_option}" == '1' ]; then
                echo "更新ComfyUI中"
                git pull
                if [ $? = "0" ];then
                    dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI更新结果" --msgbox "ComfyUI更新成功" 20 60
                else
                    dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI更新结果" --msgbox "ComfyUI更新失败" 20 60
                fi
                comfyui_option
            elif [ "${final_comfyui_option}" == '2' ]; then
                if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI删除选项" --yes-label "是" --no-label "否" --yesno "是否删除ComfyUI?" 20 60) then
                    echo "删除ComfyUI中"
                    exit_venv
                    cd ..
                    rm -rfv ./ComfyUI
                else
                    comfyui_option
                fi
            elif [ "${final_comfyui_option}" == '3' ]; then
                echo "修复更新中"
                git checkout master
                git reset --hard HEAD
                comfyui_option
            elif [ "${final_comfyui_option}" == '4' ]; then
                cd custom_nodes
                comfyui_custom_node_methon
                comfyui_option
            elif [ "${final_comfyui_option}" == '5' ]; then
                cd web/extensions
                comfyui_extension_methon
                comfyui_option
            elif [ "${final_comfyui_option}" == '6' ]; then
                git_checkout_manager
                comfyui_option
            elif [ "${final_comfyui_option}" == '7' ]; then
                if [ -f "./term-sd-launch.conf" ]; then #找到启动脚本
                    if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI启动选项" --yes-label "启动" --no-label "修改参数" --yesno "请选择启动ComfyUI/修改ComfyUI启动参数\n当前启动参数:\npython $(cat ./term-sd-launch.conf)" 20 60) then
                        term_sd_launch
                        comfyui_option
                    else
                        generate_comfyui_launch
                        term_sd_launch
                        comfyui_option
                    fi
                else #找不到启动脚本,并启动脚本生成界面
                    generate_comfyui_launch
                    term_sd_launch
                    comfyui_option
                fi    
            elif [ "${final_comfyui_option}" == '8' ]; then
                if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI重新安装选项" --yesno "是否重新安装ComfyUI?" 20 60) then
                    cd "$start_path"
                    exit_venv
                    process_install_comfyui
                    comfyui_option
                fi
            elif [ "${final_comfyui_option}" == '9' ]; then
                pytorch_reinstall
                comfyui_option
            elif [ "${final_comfyui_option}" == '10' ]; then
                venv_generate
                comfyui_option
            elif [ "${final_comfyui_option}" == '11' ]; then
                mainmenu #回到主界面
            fi
        fi
    else
        if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI安装选项" --yesno "检测到当前未安装ComfyUI,是否进行安装?" 20 60) then
            process_install_comfyui
            comfyui_option
        fi
    fi
    mainmenu #处理完后返回主界面界面
}

#InvokeAI选项
function invokeai_option()
{
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "InvokeAI" ];then #找到invokeai文件夹
        cd InvokeAI
        venv_generate #尝试重新生成虚拟环境,解决因为路径移动导致虚拟环境无法进入,然后检测不到invokeai
        enter_venv #进入环境
        if which invokeai 2> /dev/null ;then #查找环境中有没有invokeai
            final_invokeai_option=$(
                dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI管理选项的功能\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
                "1" "更新" \
                "2" "卸载" \
                "3" "启动" \
                "4" "重新安装" \
                "5" "重新安装pytorch" \
                "6" "返回" \
                3>&1 1>&2 2>&3)

            if [ $? = 0 ];then
                if [ "${final_invokeai_option}" == '1' ]; then
                    proxy_option #代理选择
                    pip_install_methon #安装方式选择
                    final_install_check #安装前确认
                    echo "更新InvokeAI中"
                    pip install $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --upgrade invokeai --default-timeout=100 --retries 5
                    if [ $? = "0" ];then
                        dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI更新结果" --msgbox "InvokeAI更新成功" 20 60
                    else
                        dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI更新结果" --msgbox "InvokeAI更新失败" 20 60
                    fi
                    invokeai_option
                elif [ "${final_invokeai_option}" == '2' ]; then
                    if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI删除选项" --yes-label "是" --no-label "否" --yesno "是否删除InvokeAI?" 20 60) then
                        echo "删除InvokeAI中"
                        exit_venv
                        cd ..
                        rm -rfv ./InvokeAI
                    else
                        invokeai_option
                    fi
                elif [ "${final_invokeai_option}" == '3' ]; then
                    generate_invokeai_launch
                    invokeai_option
                elif [ "${final_invokeai_option}" == '4' ]; then
                    if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI重新安装选项" --yesno "是否重新安装InvokeAI?" 20 60) then
                        cd "$start_path"
                        exit_venv
                        process_install_invokeai
                        invokeai_option
                    fi
                elif [ "${final_invokeai_option}" == '5' ]; then
                    pytorch_reinstall
                    invokeai_option
                elif [ "${final_invokeai_option}" == '6' ]; then
                    mainmenu #回到主界面
                fi
            fi
        else 
            if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI安装选项" --yesno "检测到当前未安装InvokeAI,是否进行安装?" 20 60) then
                cd "$start_path"
                process_install_invokeai
                invokeai_option
            fi
        fi
    else
        if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI安装选项" --yesno "检测到当前未安装InvokeAI,是否进行安装?" 20 60) then
          process_install_invokeai
          invokeai_option
        fi
    fi
    mainmenu #处理完后返回主界面界面
}

#lora-scripts选项
function lora_scripts_option()
{
    cd "$start_path" #回到最初路径
    exit_venv #确保进行下一步操作前已退出其他虚拟环境
    if [ -d "./lora-scripts" ];then
        cd lora-scripts
        final_lora_scripts_option=$(
            dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择lora-scripts管理选项的功能\n当前目录可用空间:$(df ./ -h |awk 'NR==2'|awk -F ' ' ' {print $4} ')" 20 60 10 \
            "1" "更新" \
            "2" "卸载" \
            "3" "修复更新" \
            "4" "版本切换" \
            "5" "启动" \
            "6" "重新安装" \
            "7" "重新安装pytorch" \
            "8" "重新生成venv虚拟环境" \
            "9" "返回" \
            3>&1 1>&2 2>&3)

        if [ $? = 0 ];then
            if [ "${final_lora_scripts_option}" == '1' ]; then
                echo "更新lora-scripts中"
                test_num=1
                git pull
                if [ $? = 0 ];then
                    test_num=0
                fi
                git pull ./sd-scripts
                git pull ./frontend
                git submodule init
                git submodule update #版本不对应,有时会出现各种奇怪的报错
                git submodule
                if [ $test_num = "0" ];then
                    dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --msgbox "lora-scripts更新成功" 20 60
                else
                    dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts更新结果" --msgbox "lora-scripts更新失败" 20 60
                fi
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '2' ]; then
                if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts删除选项" --yes-label "是" --no-label "否" --yesno "是否删除lora-scripts?" 20 60) then
                    echo "删除lora-scripts中"
                    exit_venv
                    cd ..
                    rm -rfv ./lora-scripts
                else
                    lora_scripts_option
                fi
            elif [ "${final_lora_scripts_option}" == '3' ]; then
                echo "修复更新中"
                git checkout main
                git reset --hard HEAD #修复lora-scripts
                cd ./sd-scripts
                git checkout main
                git reset --hard HEAD #修复kohya-ss训练模块
                cd ./../frontend
                git checkout master
                git reset --hard HEAD #修复lora-gui-dist
                cd ..
                git submodule init
                git submodule update
                git submodule
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '4' ]; then
                git_checkout_manager
                cd "$start_path/lora-scripts"
                git submodule init
                git submodule update
                git submodule
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '5' ]; then
                enter_venv
                export HF_HOME=huggingface
                export PYTHONUTF8=1
                if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
                    python ./gui.py
                else
                    python3 ./gui.py
                fi
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '6' ]; then
                if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts重新安装选项" --yesno "是否重新安装lora_scripts?" 20 60) then
                    cd "$start_path"
                    exit_venv
                    process_install_lora_scripts
                    lora_scripts_option
                fi
            elif [ "${final_lora_scripts_option}" == '7' ]; then
                pytorch_reinstall
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '8' ]; then
                venv_generate
                lora_scripts_option
            elif [ "${final_lora_scripts_option}" == '9' ]; then
                mainmenu #回到主界面
            fi
        fi
    else
        if (dialog --clear --title "lora-scripts管理" --backtitle "lora-scripts安装选项" --yesno "检测到当前未安装lora_scripts,是否进行安装?" 20 60) then
            process_install_lora_scripts
            lora_scripts_option
        fi
    fi
    mainmenu #处理完后返回主界面界面
}

###############################################################################

#启动脚本生成部分

#a1111-sd-webui启动脚本生成部分
function generate_a1111_sd_webui_launch()
{
    #清空启动参数
    a1111_launch_option=""

    #展示启动参数选项
    a1111_launch_option_select=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui启动参数选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择A1111-Stable-Diffusion-Webui启动参数" 20 60 10 \
        "1" "skip-torch-cuda-test" OFF \
        "2" "no-half" OFF \
        "3" "no-half-vae" OFF \
        "4" "medvram" OFF \
        "5" "lowvram" OFF \
        "6" "lowram" OFF \
        "7" "enable-insecure-extension-access" OFF \
        "8" "theme dark" ON \
        "9" "autolaunch" ON \
        "10" "xformers" ON \
        "11" "listen" OFF \
        "12" "precision full" OFF \
        "13" "force-enable-xformers" OFF \
        "14" "xformers-flash-attention" OFF \
        "15" "api" OFF \
        "16" "ui-debug-mode" OFF \
        "17" "share" OFF \
        "18" "opt-split-attention-invokeai" OFF \
        "19" "opt-split-attention-v1" OFF \
        "20" "opt-sdp-attention" OFF \
        "21" "opt-sdp-no-mem-attention" OFF \
        "22" "disable-opt-split-attention" OFF \
        "23" "use-cpu all" OFF \
        "24" "opt-channelslast" OFF \
        "25" "no-gradio-queue" OFF \
        "26" "no-hashing" OFF \
        "27" "backend directml" OFF \
        "28" "opt-sub-quad-attention" OFF \
        3>&1 1>&2 2>&3)

    #根据菜单得到的数据设置变量
    if [ $? = 0 ];then
        if [ ! -z "$a1111_launch_option_select" ]; then
            for a1111_launch_option_select_ in $a1111_launch_option_select; do
            case "$a1111_launch_option_select_" in
            "1")
            a1111_launch_option="--skip-torch-cuda-test $a1111_launch_option"
            ;;
            "2")
            a1111_launch_option="--no-half $a1111_launch_option"
            ;;
            "3")
            a1111_launch_option="--no-half-vae $a1111_launch_option"
            ;;
            "4")
            a1111_launch_option="--medvram $a1111_launch_option"
            ;;
            "5")
            a1111_launch_option="--lowvram $a1111_launch_option"
            ;;
            "6")
            a1111_launch_option="--lowram $a1111_launch_option"
            ;;
            "7")
            a1111_launch_option="--enable-insecure-extension-access $a1111_launch_option"
            ;;
            "8")
            a1111_launch_option="--theme dark $a1111_launch_option"
            ;;
            "9")
            a1111_launch_option="--autolaunch $a1111_launch_option"
            ;;
            "10")
            a1111_launch_option="--xformers $a1111_launch_option"
            ;;
            "11")
            a1111_launch_option="--listen $a1111_launch_option"
            ;;
            "12")
            a1111_launch_option="--precision full $a1111_launch_option"
            ;;
            "13")
            a1111_launch_option="--force-enable-xformers $a1111_launch_option"
            ;;
            "14")
            a1111_launch_option="--xformers-flash-attention $a1111_launch_option"
            ;;
            "15")
            a1111_launch_option="--api $a1111_launch_option"
            ;;
            "16")
            a1111_launch_option="--ui-debug-mode $a1111_launch_option"
            ;;
            "17")
            a1111_launch_option="--share $a1111_launch_option"
            ;;
            "18")
            a1111_launch_option="--opt-split-attention-invokeai $a1111_launch_option"
            ;;
            "19")
            a1111_launch_option="--opt-split-attention-v1 $a1111_launch_option"
            ;;
            "20")
            a1111_launch_option="--opt-sdp-attention $a1111_launch_option"
            ;;
            "21")
            a1111_launch_option="--opt-sdp-no-mem-attention $a1111_launch_option"
            ;;
            "22")
            a1111_launch_option="--disable-opt-split-attention $a1111_launch_option"
            ;;
            "23")
            a1111_launch_option="--use-cpu all $a1111_launch_option"
            ;;
            "24")
            a1111_launch_option="--opt-channelslast $a1111_launch_option"
            ;;
            "25")
            a1111_launch_option="--no-gradio-queue $a1111_launch_option"
            ;;
            "26")
            a1111_launch_option="--no-hashing $a1111_launch_option"
            ;;
            "27")
            a1111_launch_option="--backend directml $a1111_launch_option"
            ;;
            "28")
            a1111_launch_option="--opt-sub-quad-attention $a1111_launch_option"
            ;;
            *)
            exit 1
            ;;    
            esac
            done
        fi
    
        #生成启动脚本
        if [ -f "./term-sd-launch.conf" ];then
            rm -v ./term-sd-launch.conf
        fi
        echo "设置启动参数 $a1111_launch_option"
        echo "launch.py $a1111_launch_option" >term-sd-launch.conf
    fi
}

#comfyui启动脚本生成部分
function generate_comfyui_launch()
{
    comfyui_launch_option=""

    comfyui_launch_option_select=$(
        dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI启动参数选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择ComfyUI启动参数" 20 60 10 \
        "1" "listen" OFF \
        "2" "auto-launch" OFF \
        "3" "dont-upcast-attention" OFF \
        "4" "force-fp32" OFF\
        "5" "use-split-cross-attention" OFF \
        "6" "use-pytorch-cross-attention" OFF \
        "7" "disable-xformers" OFF \
        "8" "gpu-only" OFF \
        "9" "highvram" OFF \
        "10" "normalvram" OFF \
        "11" "lowvram" OFF \
        "12" "novram" OFF \
        "13" "cpu" OFF \
        "14" "quick-test-for-ci" OFF \
        "15" "directml" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ ! -z "$comfyui_launch_option_select" ]; then
            for comfyui_launch_option_select_ in $comfyui_launch_option_select; do
            case "$comfyui_launch_option_select_" in
            "1")
            comfyui_launch_option="--listen"
            ;;
            "2")    
            comfyui_launch_option="--auto-launch"
            ;;
            "3")
            comfyui_launch_option="--dont-upcast-attention"
            ;;
            "4")
            comfyui_launch_option="--force-fp32"
            ;;
            "5")
            comfyui_launch_option="--use-split-cross-attention"
            ;;
            "6")
            comfyui_launch_option="--use-pytorch-cross-attention"
            ;;
            "7")
            comfyui_launch_option="--disable-xformers"
            ;;
            "8")
            comfyui_launch_option="--gpu-only"
            ;;
            "9")
            comfyui_launch_option="--highvram"
            ;;
            "10")
            comfyui_launch_option="--normalvram"
            ;;
            "11")
            comfyui_launch_option="--lowvram"
            ;;
            "12")
            comfyui_launch_option="--novram"
            ;;
            "13")
            comfyui_launch_option="--cpu"
            ;;
            "14")
            comfyui_launch_option="--quick-test-for-ci"
            ;;
            "15")
            comfyui_launch_option="--directml"
            ;;
            *)
            exit 1
            ;;    
            esac
            done
        fi

        if [ -f "./term-sd-launch.conf" ];then
            rm -v ./term-sd-launch.conf
        fi
        echo "设置启动参数 $comfyui_launch_option"
        echo "main.py $comfyui_launch_option" > term-sd-launch.conf
    fi
}

#invokeai启动脚本生成部分
function generate_invokeai_launch()
{
    invokeai_launch_option=$(
        dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI启动参数选项" --ok-label "确认" --cancel-label "取消" --menu "请选择InvokeAI启动参数" 20 60 10 \
        "1" "invokeai-configure" \
        "2" "invokeai" \
        "3" "invokeai --web" \
        "4" "invokeai-ti --gui" \
        "5" "invokeai-merge --gui" \
        "6" "自定义启动参数" \
        "7" "返回" \
        3>&1 1>&2 2>&3 )
    if [ $? = 0 ];then
        if [ "${invokeai_launch_option}" == '1' ]; then 
            invokeai-configure --root ./invokeai
        elif [ "${invokeai_launch_option}" == '2' ]; then 
            invokeai --root ./invokeai
        elif [ "${invokeai_launch_option}" == '3' ]; then 
            invokeai --web --root ./invokeai
        elif [ "${invokeai_launch_option}" == '4' ]; then 
            invokeai-ti --gui --root ./invokeai
        elif [ "${invokeai_launch_option}" == '5' ]; then 
            invokeai-merge --gui --root ./invokeai
        elif [ "${invokeai_launch_option}" == '6' ]; then 
            if [ -f "./term-sd-launch.conf" ];then
                if (dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI启动选项" --yes-label "启动" --no-label "修改参数" --yesno "请选择启动ComfyUI/修改ComfyUI启动参数\n当前启动参数:\ninvokeai $(cat ./term-sd-launch.conf)" 20 60) then
                    invokeai $(cat ./term-sd-launch.conf)
                else
                    generate_invokeai_launch_cust
                    invokeai $(cat ./term-sd-launch.conf)
                fi
            else #找不到启动配置
                generate_invokeai_launch_cust
                invokeai $(cat ./term-sd-launch.conf)
            fi
        elif [ "${invokeai_launch_option}" == '7' ]; then 
            echo
        fi
    fi
}

#invokeai自定义启动参数生成
function generate_invokeai_launch_cust()
{
    cust_invokeai_launch_option=""

    cust_invokeai_launch_option_select=$(
        dialog --clear --title "InvokeAI管理" --backtitle "InvokeAI自定义启动参数选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择InvokeAI启动参数" 20 60 10 \
        "1" "web" ON \
        "2" "free_gpu_mem" OFF \
        "3" "precision auto" ON \
        "4" "precision fp32" OFF\
        "5" "precision fp16" OFF \
        "6" "no-xformers_enabled" OFF \
        "7" "xformers_enabled" ON \
        "8" "no-patchmatch" OFF \
        "9" "always_use_cpu" OFF \
        "10" "no-esrgan" OFF \
        "11" "no-internet_available" OFF \
        "12" "host" OFF \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ ! -z "$cust_invokeai_launch_option_select" ]; then
            for cust_invokeai_launch_option_select_ in $cust_invokeai_launch_option_select; do
            case "$cust_invokeai_launch_option_select_" in
            "1")
            cust_invokeai_launch_option="--web $cust_invokeai_launch_option"
            ;;
            "2")
            cust_invokeai_launch_option="--free_gpu_mem $cust_invokeai_launch_option"
            ;;
            "3")
            cust_invokeai_launch_option="--precision auto $cust_invokeai_launch_option"
            ;;
            "4")
            cust_invokeai_launch_option="--precision fp32 $cust_invokeai_launch_option"
            ;;
            "5")
            cust_invokeai_launch_option="--precision fp16 $cust_invokeai_launch_option"
            ;;
            "6")
            cust_invokeai_launch_option="--no-xformers_enabled $cust_invokeai_launch_option"
            ;;
            "7")
            cust_invokeai_launch_option="--xformers_enabled $cust_invokeai_launch_option"
            ;;
            "8")
            cust_invokeai_launch_option="--no-patchmatch $cust_invokeai_launch_option"
            ;;
            "9")
            cust_invokeai_launch_option="--always_use_cpu $cust_invokeai_launch_option"
            ;;
            "10")
            cust_invokeai_launch_option="--no-esrgan $cust_invokeai_launch_option"
            ;;
            "11")
            cust_invokeai_launch_option="--no-internet_available $cust_invokeai_launch_option"
            ;;
            "12")
            cust_invokeai_launch_option="--host 0.0.0.0 $cust_invokeai_launch_option"
            ;;
            *)
            exit 1
            ;;    
            esac
            done

            #生成启动脚本
            if [ -f "./term-sd-launch.conf" ];then
                rm -v ./term-sd-launch.conf
            fi
            echo "设置启动参数 $cust_invokeai_launch_option"
            echo "--root ./invokeai $cust_invokeai_launch_option" > term-sd-launch.conf
        fi
    fi
}

function term_sd_launch()
{
    enter_venv
    if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
        python $(cat ./term-sd-launch.conf)
    else
        python3 $(cat ./term-sd-launch.conf)
    fi
}

###############################################################################

#term-sd其他选项

#term-sd更新选项
function update_option()
{
    if (dialog --clear --title "Term-SD" --backtitle "Term-SD更新选项" --yes-label "是" --no-label "否" --yesno "更新Term-SD时是否使用代理" 20 60) then
        aria2c https://ghproxy.com/https://raw.githubusercontent.com/licyk/sd-webui-script/$term_sd_branch/term-sd.sh -d ./term-sd-update-tmp/
        if [ "$?"="0" ];then
            cp -fv ./term-sd-update-tmp/term-sd.sh ./
            rm -rfv ./term-sd-update-tmp
            chmod u+x term-sd.sh
            if (dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --msgbox "Term-SD更新成功" 20 60);then
                source ./term-sd.sh
            fi
        else
            dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --msgbox "Term-SD更新失败,请重试" 20 60
        fi
    else
        aria2c https://raw.githubusercontent.com/licyk/sd-webui-script/$term_sd_branch/term-sd.sh -d ./term-sd-update-tmp/
        if [ "$?"="0" ];then
            cp -fv ./term-sd-update-tmp/term-sd.sh ./
            rm -rfv ./term-sd-update-tmp
            chmod u+x term-sd.sh
            if (dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --msgbox "Term-SD更新成功" 20 60);then
                source ./term-sd.sh
            fi
        else
            dialog --clear --title "Term-SD" --backtitle "Term-SD更新结果" --msgbox "Term-SD更新失败,请重试" 20 60
        fi
    fi
    mainmenu
}

#扩展脚本选项
function term_sd_extension()
{
    term_sd_extension_proxy=""
    term_sd_extension_option_1="1"
    term_sd_extension_option_2="1"
    term_sd_extension_option_3="1"

    if [ -f "./sd-webui-extension.sh" ];then
        term_sd_extension_1="ON"
    else
        term_sd_extension_1="OFF"
    fi

    if [ -f "./comfyui-extension.sh" ];then
        term_sd_extension_2="ON"
    else
        term_sd_extension_2="OFF"
    fi

    if [ -f "./venv-rebuild.sh" ];then
        term_sd_extension_3="ON"
    else
        term_sd_extension_3="OFF"
    fi

    term_sd_extension_select_=$(
        dialog --clear --title "Term-SD" --backtitle "Term-SD扩展脚本选项" --separate-output --ok-label "确认" --notags --checklist "Term-SD扩展脚本列表\n勾选以下载,如果脚本已下载,则会执行更新；取消勾选以删除\n下载的脚本将会放在term-sd脚本所在目录下\n推荐勾选\"下载代理\"" 20 60 10 \
            "1" "下载代理" ON \
            "2" "sd-webui-extension" "$term_sd_extension_1" \
            "3" "comfyui-extension" "$term_sd_extension_2" \
            "4" "venv-rebuild" "$term_sd_extension_3" \
            3>&1 1>&2 2>&3)
        
    if [ $? = 0 ];then
        for term_sd_extension_select in $term_sd_extension_select_;do
        case "$term_sd_extension_select" in
        "1")
        term_sd_extension_proxy="https://ghproxy.com"
        ;;
        "2")
        term_sd_extension_option_1="0"
        ;;
        "3")
        term_sd_extension_option_2="0"
        ;;
        "4")
        term_sd_extension_option_3="0"
        ;;
        *)
        exit 1
        ;;
        esac
        done

        if [ $term_sd_extension_option_1 = "0" ];then
            aria2c $term_sd_extension_proxy/https://raw.githubusercontent.com/licyk/sd-webui-script/$term_sd_branch/other/sd-webui-extension.sh -d ./term-sd-update-tmp/ -o sd-webui-extension.sh
            
            if [ $? = 0 ];then
                term_sd_extension_info_1="下载成功"
                cp -fv ./term-sd-update-tmp/sd-webui-extension.sh ./
                chmod +x ./sd-webui-extension.sh
                rm -rfv ./term-sd-update-tmp/
            else
                term_sd_extension_info_1="下载失败"
            fi
        else
            rm -rfv ./sd-webui-extension.sh
            term_sd_extension_info_1="已删除"
        fi

        if [ $term_sd_extension_option_2 = "0" ];then
            aria2c $term_sd_extension_proxy/https://raw.githubusercontent.com/licyk/sd-webui-script/$term_sd_branch/other/comfyui-extension.sh -d ./term-sd-update-tmp/ -o comfyui-extension.sh
            if [ $? = 0 ];then
                term_sd_extension_info_2="下载成功"
                cp -fv ./term-sd-update-tmp/comfyui-extension.sh ./
                chmod +x ./comfyui-extension.sh
                rm -rfv ./term-sd-update-tmp/
            else
                term_sd_extension_info_2="下载失败"
            fi
        else
            rm -rfv ./comfyui-extension.sh
            term_sd_extension_info_2="已删除"
        fi

        if [ $term_sd_extension_option_3 = "0" ];then
            aria2c $term_sd_extension_proxy/https://raw.githubusercontent.com/licyk/sd-webui-script/$term_sd_branch/other/venv-rebuild.sh -d ./term-sd-update-tmp/ -o venv-rebuild.sh
            if [ $? = 0 ];then
                term_sd_extension_info_3="下载成功"
                cp -fv ./term-sd-update-tmp/venv-rebuild.sh ./
                chmod +x ./venv-rebuild.sh
                rm -rfv ./term-sd-update-tmp/
            else
                term_sd_extension_info_3="下载失败"
            fi
        else
            rm -rfv ./venv-rebuild.sh
            term_sd_extension_info_3="已删除"
        fi

        dialog --clear --title "Term-SD" --backtitle "Term-SD扩展脚本选项" --msgbox "扩展脚本状态:\nsd-webui-extension:$term_sd_extension_info_1\ncomfyui-extension:$term_sd_extension_info_2\nvenv-rebuild:$term_sd_extension_info_3" 20 60
        term_sd_extension
    else
        mainmenu
    fi
}

#pip镜像源选项
function set_proxy_option()
{
    echo "获取pip全局配置"
    if (dialog --clear --title "Term-SD" --backtitle "pip镜像源选项" --yes-label "是" --no-label "否" --yesno "pip全局配置:\n$(pip config list)\n是否启用pip镜像源?" 20 60) then
        #pip config set global.index-url "https://mirror.sjtu.edu.cn/pypi/web/simple"
        pip config set global.index-url "https://mirrors.bfsu.edu.cn/pypi/web/simple"
        #pip config set global.extra-index-url "https://mirror.sjtu.edu.cn/pytorch-wheels"
        #pip config set global.extra-index-url "https://mirrors.aliyun.com/pytorch-wheels"
        pip config set global.find-links "https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html"
    else
        pip config unset global.index-url
        pip config unset global.find-links
    fi
    mainmenu
}

#pip缓存清理功能
function pip_cache_clean()
{
    echo "统计pip缓存信息中"
    if (dialog --clear --title "Term-SD" --backtitle "pip缓存清理选项" --yes-label "是" --no-label "否" --yesno "pip缓存信息:\npip缓存路径:$(pip cache dir)\n包索引页面缓存大小:$(pip cache info |awk NR==2 | awk -F ':'  '{print $2 $3 $4}')\n本地构建的wheel包大小:$(pip cache info |awk NR==5 | awk -F ':'  '{print $2 $3 $4}')\n是否删除pip缓存?" 20 60);then
        pip cache purge
    fi
    mainmenu
}

###############################################################################

#term-sd帮助功能

#帮助选择
function info_option()
{
    info_option_select=$(dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --cancel-label "取消" --menu "请选择帮助" 20 60 10 \
        "1" "关于term-sd" \
        "2" "使用说明" \
        "3" "启动参数说明" \
        "4" "目录说明" \
        "5" "扩展脚本说明" \
        "6" "sd-webui插件说明" \
        "7" "ComfyUI插件/自定义节点说明" \
        "8" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ $info_option_select = 1 ];then
            info_option_1
            info_option
        elif [ $info_option_select = 2 ];then
            info_option_2
            info_option
        elif [ $info_option_select = 3 ];then
            info_option_3
            info_option
        elif [ $info_option_select = 4 ];then
            info_option_4
            info_option
        elif [ $info_option_select = 5 ];then
            info_option_5
            info_option
        elif [ $info_option_select = 6 ];then
            info_option_6
            info_option
        elif [ $info_option_select = 7 ];then
            info_option_7
            info_option
        elif [ $info_option_select = 8 ];then
            mainmenu
        fi
    else
        mainmenu
    fi
}

#关于term-sd
function info_option_1()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --msgbox "关于Term-SD:\n
Term-SD是基于终端显示的管理器,可以对项目进行简单的管理  \n
支持的项目如下: \n
1、AUTOMATIC1111-stable-diffusion-webui \n
2、ComfyUI \n
3、InvokeAI \n
4、lora-scripts \n
(项目都基于stable-diffusion)\n
\n
\n
该脚本的编写参考了https://gitee.com/skymysky/linux \n
脚本支持Windows,Linux,MacOS(Windows平台需安装msys2,MacOS需要安装homebrew)\n
\n
stable-diffusion相关链接:\n
https://huggingface.co/\n
https://civitai.com/\n
https://www.bilibili.com/read/cv22159609\n
\n
学习stable-diffusion-webui的教程:\n
https://licyk.netlify.app/2023/08/01/stable-diffusion-tutorial/\n
\n
\n
" 20 60
}

#使用说明
function info_option_2()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --msgbox "Term-SD使用说明:\n
1、使用方向键、Tab键移动光标,Enter进行选择,Space键勾选或取消勾选,(已勾选显示[*]),Ctrl+C可中断指令的运行 \n
2、初次使用时,如果之前没有使用过python的pip模块,建议在主界面先选择"pip镜像源",设置pip的国内镜像源,加快安装时下载python软件包的速度。主界面显示的"虚拟环境"保持启用就行,无需禁用\n
3、主界面总共有四个ai项目可选(AUTOMATIC1111-stable-diffusion-webui,ComfyUI,InvokeAI,lora-scripts),回车选中后,如果在脚本的当前目录未找选中的项目,term-sd会提示你进行安装。\n
4、安装前将会提示你进行安装准备,首先是"代理选择",有三个选项可选(启用pip镜像源,启用github代理,强制使用pip),前两个选项默认勾选,如果没有质量较好的科学上网工具,不建议勾选。"强制使用pip"只有禁用了虚拟环境时才建议勾选(在Linux中,如果不在虚拟环境中安装python软件包,pip模块会警告\"error: externally-managed-environment\",只有使用"--break-system-packages"才能进行安装)\n
5、然后是"pytorch安装",pytorch版本的选择:nvidia显卡选择cuda(Windows,linux平台),amd显卡在linux平台选择rocm,amd显卡和intel显卡在windows平台选择directml,macos选择不带cuda,rocm,directml的版本,如果想要在cpu上进行跑图,选择cpu版本\n
6、AUTOMATIC1111-stable-diffusion-webui,ComfyUI会有额外的插件/自定义节点选择,默认勾选一些比较实用的,可根据需要勾选额外,插件/自定义节点的介绍在帮助中查询。(项目在安装好后,如果在插件安装列表有想要安装的,可使用"扩展脚本"中的"extension"脚本进行安装)\n
7、安装前的准备完成后,将会弹出安装确认界面,选择"是"开始安装\n
8、安装结束后,会自动进入盖项目的管理界面,在该界面中可以对项目进行更新,卸载,启动等操作\n
9、在安装之后,pip模块会产生大量的缓存,可使用主界面的"pip缓存清理"进行删除\n
注意事项:\n
1、安装项目的路径和Term-SD脚本所在路径相同,方便管理\n
2、若项目使用了venv虚拟环境,移动项目到新的路径后需要使用Term-SD的“重新生成venv虚拟环境”功能,才能使venv虚拟环境正常工作\n
3、在更新或者切换版本失败时可以使用“更新修复”解决,然后再点一次“更新”\n
4、Term-SD只有简单的安装,管理功能,若要导入模型等操作需手动在文件管理器上操作\n
5、如果没有质量较好的科学上网工具,建议在安装时使用git代理和python镜像源\n
6、建议保持启用虚拟环境,因为不同项目对软件包的版本要求不同,关闭后易导致不同的项目出现依赖问题\n
7、若没有设置过python镜像源,推荐在\"python镜像源\"为系统设置python镜像源,加快python软件包的下载速度\n
8、AUTOMATIC1111-stable-diffusion-webui安装好后,可以使用秋叶aaaki制作的启动器来启动sd-webui。将秋叶的启动器放入stable-diffusion-webui文件夹中,双击启动(仅限windows,因为秋叶的启动器只有windows的版本)\n
9、ComfyUI目前并没有自动为插件或者自定义节点安装依赖的功能,所以安装插件或者自定义节点后后,推荐运行一次“安装依赖”功能,有些依赖下载源是在github上的,无法下载时请使用科学上网(已知问题:因为一些插件/自定义节点的安装依赖方式并不统一,term-sd的依赖安装功能可能没有用,需要手动进行安装依赖)\n
10、InvokeAI在安装好后,要运行一次invokeai-configure,到\"install stable diffusion models\"界面时,可以把所有的模型取消勾选,因为有的模型是从civitai下载的,如果没有科学上网会导致下载失败\n
11、在插件/自定义节点的管理功能中没有"更新","切换版本","修复更新"这些按钮,是因为这些插件/自定义节点的文件夹内没有".git"文件夹,如果是从github上直接下载压缩包再解压安装的就会有这种情况\n
\n
\n
" 20 60
}

#启动参数说明
function info_option_3()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --msgbox "A1111-SD-Webui启动参数说明:\n
stable diffusion webui的启动参数:\n
skip-torch-cuda-test:不检查CUDA是否正常工作\n
no-half:不将模型切换为16位浮点数\n
no-half-vae:不将VAE模型切换为16位浮点数\n
medvram:启用稳定扩散模型优化,以牺牲速度换取低VRAM使用\n
lowvram:启用稳定扩散模型优化,大幅牺牲速度换取极低VRAM使用\n
lowram:将稳定扩散检查点权重加载到VRAM而不是RAM中\n
enable-insecure-extension-access:启用不安全的扩展访问\n
theme dark:启用黑色主题\n
autolaunch:自动启动浏览器打开webui界面\n
xformers:使用的xFormers加速\n
listen:允许局域网的设备访问\n
precision-full:全精度\n
force-enable-xformers:强制启用xformers加速\n
xformers-flash-attention:启用具有Flash Attention的xformer以提高再现性\n
api:启动API服务器\n
ui-debug-mode:不加载模型而快速启动ui界面\n
share:为gradio使用share=True,并通过其网站使UI可访问\n
opt-split-attention-invokeai:在自动选择优化时优先使用InvokeAI的交叉注意力层优化\n
opt-split-attention-v1:在自动选择优化时优先使用较旧版本的分裂注意力优化\n
opt-sdp-attention:在自动选择优化时优先使用缩放点积交叉注意力层优化;需要PyTorch 2\n
opt-sdp-no-mem-attention:在自动选择优化时优先使用不带内存高效注意力的缩放点积交叉注意力层优化,使图像生成确定性;需要PyTorch 2\n
disable-opt-split-attention:在自动选择优化时优先不使用交叉注意力层优化\n
use-cpu-all:使用cpu进行图像生成\n
opt-channelslast:将稳定扩散的内存类型更改为channels last\n
no-gradio-queue:禁用gradio队列;导致网页使用http请求而不是websocket\n
no-hashing:禁用检查点的sha256哈希运算,以帮助提高加载性能\n
backend directml:使用directml运行torch,解决amd显卡和intel显卡无法使用ai画图的问题\n
opt-sub-quad-attention:优先考虑内存高效的次二次复杂度交叉注意力层优化,用于自动选择\n
\n
ComfyUI启动参数:\n
listen:允许局域网的设备访问\n
auto-launch:自动在默认浏览器中启动 ComfyUI\n
dont-upcast-attention:禁用对注意力机制的提升转换。可提升速度,但增加图片变黑的概率\n
force-fp32:强制使用 fp32\n
use-split-cross-attention:使用分割交叉注意力优化。使用 xformers 时忽略此选项\n
use-pytorch-cross-attention:使用新的 pytorch 2.0 交叉注意力功能\n
disable-xformers:禁用 xformers加速\n
gpu-only:将所有内容(文本编码器/CLIP 模型等)存储和运行在 GPU 上\n
highvram:默认情况下,模型使用后会被卸载到 CPU内存。此选项使它们保留在 GPU 内存中\n
normalvram:当 lowvram 被自动启用时,强制使用普通vram用法\n
lowvram:拆分unet以使用更少的显存\n
novram:当 lowvram 不足时使用\n
cpu:对所有内容使用 CPU(缓慢)\n
quick-test-for-ci:为 CI 快速测试\n
directml:使用directml运行torch,解决amd显卡和intel显卡无法使用ai画图的问题\n
\n
InvokeAI启动参数:\n
invokeai-configure:参数配置\n
invokeai:无参数启动\n
invokeai --web:启用webui界面\n
invokeai-ti --gui:使用终端界面\n
invokeai-merge --gui:启动模型合并\n
其他的自定义参数:\n
web:启用webui界面\n
free_gpu_mem:每次操作后积极释放 GPU 内存;这将允许您在低VRAM环境中运行,但会降低一些性能\n
precision auto:自动选择浮点精度\n
precision fp32:使用fp32浮点精度\n
precision fp16:使用fp16浮点精度\n
no-xformers_enabled:禁用xformers加速\n
xformers_enabled:启用xformers加速\n
no-patchmatch:禁用“补丁匹配”算法\n
always_use_cpu:使用cpu进行图片生成\n
no-esrgan:不使用esrgan进行图片高清修复\n
no-internet_available:禁用联网下载资源\n
host:允许局域网的设备访问\n
\n
\n
" 20 60
}

#目录说明
function info_option_4()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --msgbox "项目的目录说明:\n
在启用venv虚拟环境后,在安装时项目的目录下会产生venv文件夹,这个是python软件包安装的目录,更换cudnn可在该文件夹中操作\n
\n
\n
stable diffusion webui目录的说明(只列举比较重要的):\n
stable-diffusion-webui   \n
├── embeddings   embeddings模型存放位置   \n
├── extensions   插件存放位置   \n
├── launch.py    term-sd启动sd-webui的方法   \n
├── outputs   生成图片的保存位置   \n
└── models    模型存放目录   \n
    ├── ESRGAN    放大模型存放位置   \n
    ├── GFPGAN    放大模型存放位置   \n
    ├── hypernetworks    hypernetworks模型存放位置   \n
    ├── Lora    Lora模型存放位置   \n
    ├── RealESRGAN    放大模型存放位置   \n
    ├── Stable-diffusion    大模型存放位置   \n
    └── VAE    VAE模型存放位置   \n
\n
\n
ComfyUI目录的部分说明(只列举比较重要的):\n
ComfyUI   \n
├── custom_nodes   自定义节点存放位置   \n
├── main.py        term-sd启动ComfyUI的方法   \n
├── models         模型存放位置   \n
│   ├── checkpoints    大模型存放位置   \n
│   ├── controlnet   controlnet模型存放位置   \n
│   ├── embeddings   embeddings模型存放位置   \n
│   ├── hypernetworks   hypernetworks模型存放位置   \n
│   ├── loras   Lora模型存放位置   \n
│   ├── upscale_models   放大模型存放位置   \n
│   └── vae   VAE模型存放位置   \n
├── output   生成图片的保存位置   \n
└── web   \n
    └── extensions   插件存放位置   \n
\n
\n
InvokeAI目录的部分说明(只列举比较重要的):\n
├── configs   配置文件存放目录   \n
├── invokeai.yaml   主要配置文件   \n
├── models   模型存放位置   \n
│   ├── core   \n
│   │   └── upscaling   \n
│   │       └── realesrgan   放大模型存放位置   \n
│   ├── sd-1   sd1.5模型的存放位置   \n
│   │   ├── controlnet   controlnet模型存放位置   \n
│   │   ├── embedding   embeddings模型存放位置   \n
│   │   ├── lora   Lora模型存放位置   \n
│   │   ├── main   \n
│   │   ├── onnx   \n
│   │   └── vae   VAE模型存放位置   \n
│   ├── sd-2   \n
│   │   ├── controlnet   \n
│   │   ├── embedding   \n
│   │   ├── lora   \n
│   │   ├── main   \n
│   │   ├── onnx   \n
│   │   └── vae   \n
│   ├── sdxl   \n
│   │   ├── controlnet   \n
│   │   ├── embedding   \n
│   │   ├── lora   \n
│   │   ├── main   \n
│   │   ├── onnx   \n
│   │   └── vae   \n
│   └── sdxl-refiner   \n
│       ├── controlnet   \n
│       ├── embedding   \n
│       ├── lora   \n
│       ├── main   \n
│       ├── onnx   \n
│       └── vae   \n
└── outputs   生成图片的存放位置   \n
\n
\n
lora-scripts目录的部分说明(只列举比较重要的):\n
lora-scripts   \n
├── gui.py   term-sd启动lora-scripts的方法   \n
├── logs   日志存放位置   \n
├── output   训练得到的模型存放位置   \n
├── sd-models   训练所用的底模存放位置   \n
└── toml   保存的训练参数存放位置   \n
\n
\n
" 20 60
}

#扩展脚本说明
function info_option_5()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --msgbox "Term-SD扩展脚本说明:\n
扩展脚本可从主界面的"扩展脚本"下载和更新,启动方式和term-sd相同\n
sd-webui-extension:安装sd-webui的插件\n
comfyui-extension:安装ComfyUI的插件\n
venv-rebuild:重建项目的venv虚拟环境,当启动项目时出现大量的报错,使用脚本重建虚拟环境,大概率解决这种问题(如果解决不了,可能是插件不兼容,模型损坏,WEBUI设置的参数有误等)\n
\n
\n
" 20 60
}

#AUTOMATIC1111-stable-diffusion-webui插件说明
function info_option_6()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --msgbox "AUTOMATIC1111-stable-diffusion-webui插件说明:\n
注:有些插件因为年久失修,可能会出现兼容性问题。具体介绍请在github上搜索项目\n
\n
kohya-config-webui: 一个用于生成kohya-ss训练脚本使用的toml配置文件的WebUI   \n
sd-webui-additional-networks:将 LoRA 等模型添加到stable diffusion以生成图像的扩展   \n
a1111-sd-webui-tagcomplete:输入Tag时提供booru风格(如Danbooru)的TAG自动补全   \n
multidiffusion-upscaler-for-automatic1111:在有限的显存中进行大型图像绘制,提供图片区域控制   \n
sd-dynamic-thresholding:解决使用更高的 CFG Scale 而出现颜色问题   \n
sd-webui-cutoff:解决tag污染   \n
sd-webui-model-converter:模型转换扩展   \n
sd-webui-supermerger:模型合并扩展   \n
stable-diffusion-webui-localization-zh_Hans:WEBUI中文扩展   \n
stable-diffusion-webui-wd14-tagger:图片tag反推   \n
sd-webui-regional-prompter:图片区域分割   \n
stable-diffusion-webui-baidu-netdisk:强大的图像管理器   \n
stable-diffusion-webui-anti-burn:通过跳过最后几个步骤并将它们之前的一些图像平均在一起来平滑生成的图像,加快点击停止生成图像后WEBUI的响应速度   \n
loopback_scaler:使用迭代过程增强图像分辨率和质量   \n
latentcoupleregionmapper:控制绘制和定义区域   \n
ultimate-upscale-for-automatic1111:图片放大工具   \n
deforum-for-automatic1111:视频生成插件   \n
stable-diffusion-webui-images-browser:图像管理器   \n
stable-diffusion-webui-huggingface:huggingface模型下载扩展   \n
sd-civitai-browser:civitai模型下载扩展   \n
a1111-stable-diffusion-webui-vram-estimator:显存占用评估   \n
openpose-editor:openpose姿势编辑   \n
sd-webui-depth-lib:深度图库,用于Automatic1111/stable-diffusion-webui的controlnet扩展   \n
posex:openpose姿势编辑   \n
sd-webui-tunnels:WEBUI端口映射扩展   \n
batchlinks-webui:批处理链接下载器   \n
stable-diffusion-webui-catppuccin:WEBUI主题   \n
a1111-sd-webui-lycoris:添加lycoris模型支持   \n
stable-diffusion-webui-rembg:人物背景去除   \n
stable-diffusion-webui-two-shot:图片区域分割和控制   \n
sd-webui-lora-block-weight:lora分层扩展   \n
sd-face-editor:面部编辑器   \n
sd-webui-segment-anything:图片语义分割   \n
sd-webui-controlnet:图片生成控制   \n
sd-webui-prompt-all-in-one:tag翻译和管理插件   \n
sd-webui-comfyui:在WEBUI添加ComfyUI界面   \n
sd-webui-animatediff:GIF生成扩展   \n
sd-webui-photopea-embed:在WEBUI界面添加ps功能   \n
sd-webui-openpose-editor:ControlNet的pose编辑器   \n
sd-webui-llul:给图片的选定区域增加细节   \n
sd-webui-bilingual-localization:WEBUI双语对照翻译插件   \n
adetailer:图片细节修复扩展   \n
sd-webui-mov2mov:视频逐帧处理插件   \n
sd-webui-IS-NET-pro:人物抠图   \n
ebsynth_utility:视频处理扩展   \n
sd_dreambooth_extension:dreambooth模型训练   \n
sd-webui-memory-release:显存释放扩展   \n
stable-diffusion-webui-dataset-tag-editor:训练集打标和处理扩展   \n
\n
\n
" 20 60
}

#ComfyUI插件/自定义节点说明
function info_option_7()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --msgbox "ComfyUI插件/自定义节点说明:\n
注:具体介绍请在github上搜索项目\n
\n
插件:\n
ComfyUI-extensions:ComfyUI插件扩展   \n
graphNavigator:节点辅助插件   \n
\n
节点:\n
was-node-suite-comfyui:适用于 ComfyUI 的广泛节点套件，包含 190 多个新节点   \n
ComfyUI_Cutoff:解决tag污染   \n
ComfyUI_TiledKSampler:ComfyUI 的平铺采样器   \n
ComfyUI_ADV_CLIP_emb:高级剪辑文本编码,可让您选择解释提示权重的方式   \n
ComfyUI_Noise:噪声控制   \n
ComfyUI_Dave_CustomNode:图片区域控制   \n
ComfyUI-Impact-Pack:通过检测器、细节器、升频器、管道等方便地增强图像   \n
ComfyUI-Manager:用户界面管理器   \n
ComfyUI-Custom-Nodes:ComfyUI的自定义节点   \n
ComfyUI-Custom-Scripts:ComfyUI的增强功能   \n
NodeGPT:使用GPT辅助生图   \n
Derfuu_ComfyUI_ModdedNodes:方程式节点   \n
efficiency-nodes-comfyui:ComfyUI 的效率节点   \n
ComfyUI_node_Lilly:通配符文本工具   \n
ComfyUI-nodes-hnmr:包含X/Y/Z-plot X/Y/Z,合并,潜在可视化,采样等节点   \n
ComfyUI-Vextra-Nodes:包含像素排序,交换颜色模式,拼合颜色等节点   \n
ComfyUI-QualityOfLifeSuit_Omar92:包含GPT辅助标签生成,字符串操作,latentTools等节点   \n
FN16-ComfyUI-nodes:ComfyUI自定义节点集合   \n
masquerade-nodes-comfyui:ComfyUI 掩码相关节点   \n
ComfyUI-post-processing-nodes:ComfyUI的后处理节点集合,可实现各种酷炫的图像效果   \n
images-grid-comfy-plugin:XYZPlot图生成   \n
ComfyUI-CLIPSeg:利用 CLIPSeg 模型根据文本提示为图像修复任务生成蒙版   \n
rembg-comfyui-node:背景去除   \n
ComfyUI_tinyterraNodes:ComfyUI的自定义节点   \n
yk-node-suite-comfyui:ComfyUI的自定义节点   \n
ComfyUI_experiments:ComfyUI 的一些实验性自定义节点   \n
ComfyUI_tagger:图片tag反推   \n
MergeBlockWeighted_fo_ComfyUI:权重合并   \n
ComfyUI-Saveaswebp:将生成的图片保存为webp格式   \n
trNodes:通过蒙版混合两个图像   \n
ComfyUI_NetDist:在多个本地 GPU/联网机器上运行 ComfyUI 工作流程   \n
ComfyUI-Image-Selector:从批处理中选择一个或多个图像   \n
ComfyUI-Strimmlarns-Aesthetic-Score:图片美学评分   \n
ComfyUI_UltimateSDUpscale:图片放大   \n
ComfyUI-Disco-Diffusion:Disco Diffusion模块   \n
ComfyUI-Waveform-Extensions:一些额外的音频工具,用于示例扩散ComfyUI扩展   \n
ComfyUI_Custom_Nodes_AlekPet:包括姿势,翻译等节点   \n
comfy_controlnet_preprocessors:ComfyUI的ControlNet辅助预处理器   \n
AIGODLIKE-COMFYUI-TRANSLATION:ComfyUI的翻译扩展   \n
\n
\n
" 20 60
}

###############################################################################

#venv虚拟环境处理

function venv_option()
{
    if (dialog --clear --title "Term-SD" --backtitle "venv虚拟环境选项" --yes-label "启用" --no-label "禁用" --yesno "是否启用venv虚拟环境?(推荐启用)" 20 60) then
        venv_active="0"
        venv_info="启用"
        rm -rfv ./term-sd-venv-disable.lock
    else
        venv_active="1"
        venv_info="禁用"
        touch ./term-sd-venv-disable.lock
    fi
    mainmenu
}

function venv_generate()
{
    if [ "$venv_active" = "0" ];then
        if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
            echo "创建venv虚拟环境"
            python -m venv venv
        else
            echo "创建venv虚拟环境"
            python3 -m venv venv
        fi
    fi
}

function enter_venv()
{
    if [ "$venv_active" = "0" ];then
        if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
            echo "进入venv虚拟环境"
            source ./venv/Scripts/activate
        else
            echo "进入venv虚拟环境"
            source ./venv/bin/activate
        fi
    fi
}

function exit_venv()
{
    if which deactivate 2> /dev/null ;then #检测到未退出虚拟环境
        echo "退出venv虚拟环境"
        deactivate
    fi
}

###############################################################################

#安装部分

#安装前代理选择
function proxy_option()
{
    python_proxy="-i https://pypi.python.org/simple"
    extra_python_proxy="-f https://download.pytorch.org/whl/torch_stable.html"
    #extra_python_proxy="--extra-index-url https://download.pytorch.org/whl"
    github_proxy=""
    force_pip=""
    final_install_check_python="禁用"
    final_install_check_github="禁用"
    final_install_check_force_pip="禁用"

    final_proxy_options=$(
        dialog --clear --title "Term-SD" --backtitle "安装代理选项" --separate-output --notags --title "代理选择" --ok-label "确认" --no-cancel --checklist "请选择代理(强制使用pip一般情况下不选)" 20 60 10 \
        "1" "启用pip镜像源" ON \
        "2" "启用github代理" ON \
        "3" "强制使用pip" OFF 3>&1 1>&2 2>&3)

    if [ ! -z "$final_proxy_options" ]; then
        for final_proxy_option in $final_proxy_options; do
        case "$final_proxy_option" in
        "1")
        #python_proxy="-i https://mirror.sjtu.edu.cn/pypi/web/simple" #上海交大的镜像源有点问题,在安装invokeai时会报错,可能是软件包版本的问题
        python_proxy="-i https://mirrors.bfsu.edu.cn/pypi/web/simple"
        #extra_python_proxy="-f https://mirror.sjtu.edu.cn/pytorch-wheels/torch_stable.html"
        extra_python_proxy="-f https://mirrors.aliyun.com/pytorch-wheels/torch_stable.html"
        final_install_check_python="启用"
        ;;
        "2")
        github_proxy="https://ghproxy.com/"
        final_install_check_github="启用"
        ;;
        "3")
        force_pip="--break-system-packages"
        final_install_check_force_pip="启用"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
}

#pytorch安装选择
function python_dep_install()
{
    ins_pytorch=""

    final_python_dep_install=$(
        dialog --clear --title "Term-SD" --backtitle "pytorch安装版本选项" --ok-label "确认" --no-cancel --menu "请选择要安装的pytorch版本" 20 60 10 \
        "1" "Torch 2.0.1" \
        "2" "Torch 2.0.1+CPU" \
        "3" "Torch 2.0.0+Torch-Directml" \
        "4" "Torch 2.0.1+RoCM 5.4.2" \
        "5" "Torch 1.12.1(CUDA11.3)+xFormers 0.014" \
        "6" "Torch 1.13.1(CUDA11.7)+xFormers 0.016" \
        "7" "Torch 2.0.0(CUDA11.8)+xFormers 0.018" \
        "8" "Torch 2.0.1(CUDA11.8)+xFormers 0.020" \
        "9" "Torch 2.0.1(CUDA11.8)+xFormers 0.021" \
        "0" "跳过安装" \
        3>&1 1>&2 2>&3)

    if [ "${final_python_dep_install}" == '0' ]; then
        ins_pytorch=""
    elif [ "${final_python_dep_install}" == '1' ]; then
        ins_pytorch="torch==2.0.1 torchvision==0.15.2"
    elif [ "${final_python_dep_install}" == '2' ]; then
        ins_pytorch="torch==2.0.1+cpu torchvision==0.15.2+cpu"
    elif [ "${final_python_dep_install}" == '3' ]; then
        ins_pytorch="torch==2.0.0 torchvision==0.15.1 torch-directml"
    elif [ "${final_python_dep_install}" == '4' ]; then
        ins_pytorch="torch==2.0.1+rocm5.4.2 torchvision==0.15.2+rocm5.4.2"
    elif [ "${final_python_dep_install}" == '5' ]; then
        ins_pytorch="torch==1.12.1+cu113 torchvision==0.13.1+cu113 xformers==0.0.14"
    elif [ "${final_python_dep_install}" == '6' ]; then
        ins_pytorch="torch==1.13.1+cu117 torchvision==0.14.1+cu117 xformers==0.0.16"
    elif [ "${final_python_dep_install}" == '7' ]; then
        ins_pytorch="torch==2.0.0+cu118 torchvision==0.15.1+cu118 xformers==0.0.18"
    elif [ "${final_python_dep_install}" == '8' ]; then
        ins_pytorch="torch==2.0.1+cu118 torchvision==0.15.2+cu118 xformers==0.0.20"
    elif [ "${final_python_dep_install}" == '9' ]; then
        ins_pytorch="torch==2.0.1+cu118 torchvision==0.15.2+cu118 xformers==0.0.21"
    fi
}

#pip安装模式选择
function pip_install_methon()
{
    pip_install_methon_select=""
    final_install_check_pip_methon="常规安装(setup.py)"

    final_pip_install_methon=$(
        dialog --clear --title "Term-SD" --backtitle "pip安装模式选项" --ok-label "确认" --no-cancel --menu "请选择pip安装方式\n1、常规安装可能会有问题,但速度较快\n2、标准构建安装可解决一些报错问题,但速度较慢" 20 60 10 \
        "1" "常规安装(setup.py)" \
        "2" "标准构建安装(--use-pep517)" \
        3>&1 1>&2 2>&3 )

    if [ $final_pip_install_methon = "1" ];then
        pip_install_methon_select=""
        final_install_check_pip_methon="常规安装(setup.py)"
    elif [ $final_pip_install_methon = "2" ];then
        pip_install_methon_select="--use-pep517"
        final_install_check_pip_methon="标准构建安装(--use-pep517)"
    fi
}
    
#automatic1111-webui插件选择
function a1111_sd_webui_extension_option()
{
    #清空插件选择
    extension_install_list=""
    extension_model_1="1"
    extension_model_2="1"
    extension_model_3="1"

    #插件选择,并输出插件对应的数字
    extension_list=$(
        dialog --clear --title "Term-SD" --backtitle "A1111-SD-Webui插件安装选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择要安装的A1111-Stable-Diffusion-Webui插件" 20 60 10 \
        "1" "kohya-config-webui" OFF \
        "2" "sd-webui-additional-networks" ON \
        "3" "a1111-sd-webui-tagcomplete" ON \
        "4" "multidiffusion-upscaler-for-automatic1111" ON \
        "5" "sd-dynamic-thresholding" ON \
        "6" "sd-webui-cutoff" ON \
        "7" "sd-webui-model-converter" OFF \
        "8" "sd-webui-supermerger" OFF \
        "9" "stable-diffusion-webui-localization-zh_Hans" ON \
        "10" "stable-diffusion-webui-wd14-tagger" ON \
        "11" "sd-webui-regional-prompter" ON \
        "12" "sd-webui-infinite-image-browsing" ON \
        "13" "stable-diffusion-webui-anti-burn" ON \
        "14" "loopback_scaler" OFF \
        "15" "latentcoupleregionmapper" ON \
        "16" "ultimate-upscale-for-automatic1111" ON \
        "17" "deforum-for-automatic1111" OFF \
        "18" "stable-diffusion-webui-images-browser" ON \
        "19" "stable-diffusion-webui-huggingface" OFF \
        "20" "sd-civitai-browser" OFF \
        "21" "a1111-stable-diffusion-webui-vram-estimator" OFF \
        "22" "openpose-editor" ON \
        "23" "sd-webui-depth-lib" OFF \
        "24" "posex" OFF \
        "25" "sd-webui-tunnels" OFF \
        "26" "batchlinks-webui" OFF \
        "27" "stable-diffusion-webui-catppuccin" ON \
        "28" "a1111-sd-webui-lycoris" OFF \
        "29" "stable-diffusion-webui-rembg" ON \
        "30" "stable-diffusion-webui-two-shot" ON \
        "31" "sd-webui-lora-block-weight" ON \
        "32" "sd-face-editor" OFF \
        "33" "sd-webui-segment-anything" OFF \
        "34" "sd-webui-controlnet" ON \
        "35" "sd-webui-prompt-all-in-one" ON \
        "36" "sd-webui-comfyui" OFF \
        "37" "sd-webui-animatediff" OFF \
        "38" "sd-webui-photopea-embed" ON \
        "39" "sd-webui-openpose-editor" ON \
        "40" "sd-webui-llul" ON \
        "41" "sd-webui-bilingual-localization" OFF \
        "42" "adetailer" ON \
        "43" "sd-webui-mov2mov" OFF \
        "44" "sd-webui-IS-NET-pro" ON \
        "45" "ebsynth_utility" OFF \
        "46" "sd_dreambooth_extension" OFF \
        "47" "sd-webui-memory-release" ON \
        "48" "stable-diffusion-webui-dataset-tag-editor" OFF \
        3>&1 1>&2 2>&3)

    if [ ! -z "$extension_list" ]; then
        for extension_list_ in $extension_list; do #从extension_list读取数字,通过数字对应插件链接,传递给extension_install_list
        case "$extension_list_" in
        "1")
        extension_install_list="https://github.com/WSH032/kohya-config-webui $extension_install_list"
        ;;
        "2")
        extension_install_list="https://github.com/kohya-ss/sd-webui-additional-networks $extension_install_list"
        ;;
        "3")
        extension_install_list="https://github.com/DominikDoom/a1111-sd-webui-tagcomplete $extension_install_list"
        ;;
        "4")
        extension_install_list="https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111 $extension_install_list"
        ;;
        "5")
        extension_install_list="https://github.com/mcmonkeyprojects/sd-dynamic-thresholding $extension_install_list"
        ;;
        "6")
        extension_install_list="https://github.com/hnmr293/sd-webui-cutoff $extension_install_list"
        ;;
        "7")
        extension_install_list="https://github.com/Akegarasu/sd-webui-model-converter $extension_install_list"
        ;;
        "8")
        extension_install_list="https://github.com/hako-mikan/sd-webui-supermerger $extension_install_list"
        ;;
        "9")
        extension_install_list="https://github.com/hanamizuki-ai/stable-diffusion-webui-localization-zh_Hans $extension_install_list"
        ;;
        "10")
        extension_install_list="https://github.com/picobyte/stable-diffusion-webui-wd14-tagger $extension_install_list"
        ;;
        "11")
        extension_install_list="https://github.com/hako-mikan/sd-webui-regional-prompter $extension_install_list"
        ;;
        "12")
        extension_install_list="https://github.com/zanllp/sd-webui-infinite-image-browsing $extension_install_list"
        ;;
        "13")
        extension_install_list="https://github.com/klimaleksus/stable-diffusion-webui-anti-burn $extension_install_list"
        ;;
        "14")
        extension_install_list="https://github.com/Elldreth/loopback_scaler $extension_install_list"
        ;;
        "15")
        extension_install_list="https://github.com/CodeZombie/latentcoupleregionmapper $extension_install_list"
        ;;
        "16")
        extension_install_list="https://github.com/Coyote-A/ultimate-upscale-for-automatic1111 $extension_install_list"
        ;;
        "17")
        extension_install_list="https://github.com/deforum-art/deforum-for-automatic1111-webui $extension_install_list"
        ;;
        "18")
        extension_install_list="https://github.com/AlUlkesh/stable-diffusion-webui-images-browser $extension_install_list"
        ;;
        "19")
        extension_install_list="https://github.com/camenduru/stable-diffusion-webui-huggingface $extension_install_list"
        ;;
        "20")
        extension_install_list="https://github.com/camenduru/sd-civitai-browser $extension_install_list"
        ;;
        "21")
        extension_install_list="https://github.com/space-nuko/a1111-stable-diffusion-webui-vram-estimator $extension_install_list"
        ;;
        "22")
        extension_install_list="https://github.com/fkunn1326/openpose-editor $extension_install_list"
        ;;
        "23")
        extension_install_list="https://github.com/jexom/sd-webui-depth-lib $extension_install_list"
        ;;
        "24")
        extension_install_list="https://github.com/hnmr293/posex $extension_install_list"
        ;;
        "25")
        extension_install_list="https://github.com/camenduru/sd-webui-tunnels $extension_install_list"
        ;;
        "26")
        extension_install_list="https://github.com/etherealxx/batchlinks-webui $extension_install_list"
        ;;
        "27")
        extension_install_list="https://github.com/camenduru/stable-diffusion-webui-catppuccin $extension_install_list"
        ;;
        "28")
        extension_install_list="https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris $extension_install_list"
        ;;
        "29")
        extension_install_list="https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg $extension_install_list"
        ;;
        "30")
        extension_install_list="https://github.com/ashen-sensored/stable-diffusion-webui-two-shot $extension_install_list"
        ;;
        "31")
        extension_install_list="https://github.com/hako-mikan/sd-webui-lora-block-weight $extension_install_list"
        ;;
        "32")
        extension_install_list="https://github.com/ototadana/sd-face-editor $extension_install_list"
        ;;
        "33")
        extension_install_list="https://github.com/continue-revolution/sd-webui-segment-anything $extension_install_list"
        ;;
        "34")
        extension_install_list="https://github.com/Mikubill/sd-webui-controlnet $extension_install_list"
        extension_model_1=0
        ;;
        "35")
        extension_install_list="https://github.com/Physton/sd-webui-prompt-all-in-one $extension_install_list"
        ;;
        "36")
        extension_install_list="https://github.com/ModelSurge/sd-webui-comfyui $extension_install_list"
        ;;
        "37")
        extension_install_list="https://github.com/continue-revolution/sd-webui-animatediff $extension_install_list"
        ;;
        "38")
        extension_install_list="https://github.com/yankooliveira/sd-webui-photopea-embed $extension_install_list"
        ;;
        "39")
        extension_install_list="https://github.com/huchenlei/sd-webui-openpose-editor $extension_install_list"
        ;;
        "40")
        extension_install_list="https://github.com/hnmr293/sd-webui-llul $extension_install_list"
        ;;
        "41")
        extension_install_list="https://github.com/journey-ad/sd-webui-bilingual-localization $extension_install_list"
        ;;
        "42")
        extension_install_list="https://github.com/Bing-su/adetailer $extension_install_list"
        extension_model_2=0
        ;;
        "43")
        extension_install_list="https://github.com/Scholar01/sd-webui-mov2mov $extension_install_list"
        ;;
        "44")
        extension_install_list="https://github.com/ClockZinc/sd-webui-IS-NET-pro $extension_install_list"
        extension_model_3=0
        ;;
        "45")
        extension_install_list="https://github.com/s9roll7/ebsynth_utility $extension_install_list"
        ;;
        "46")
        extension_install_list="https://github.com/d8ahazard/sd_dreambooth_extension $extension_install_list"
        ;;
        "47")
        extension_install_list="https://github.com/Haoming02/sd-webui-memory-release $extension_install_list"
        ;;
        "48")
        extension_install_list="https://github.com/toshiaki1729/stable-diffusion-webui-dataset-tag-editor $extension_install_list"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
}

#comfyui插件选择
function comfyui_extension_option()
{
    #清空插件选择
    extension_install_list=""

    extension_list=$(
        dialog --clear --title "Term-SD" --backtitle "ComfyUI插件安装选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择要安装的ComfyUI插件" 20 60 10 \
        "1" "ComfyUI-extensions" OFF \
        "2" "graphNavigator" OFF \
        3>&1 1>&2 2>&3)

    if [ ! -z "$extension_list" ]; then
        for extension_list_ in $extension_list; do
        case "$extension_list_" in
        "1")
        extension_install_list="https://github.com/diffus3/ComfyUI-extensions $extension_install_list"
        ;;
        "2")
        extension_install_list="https://github.com/rock-land/graphNavigator $extension_install_list"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
}

#comfyui自定义节点选择
function comfyui_custom_node_option()
{
    #清空插件选择
    custom_node_install_list=""
    extension_model_1="1"

    extension_list=$(
        dialog --clear --title "Term-SD" --backtitle "ComfyUI自定义节点安装选项" --separate-output --notags --ok-label "确认" --no-cancel --checklist "请选择要安装的ComfyUI自定义节点" 20 60 10 \
        "1" "was-node-suite-comfyui" ON \
        "2" "ComfyUI_Cutoff" OFF \
        "3" "ComfyUI_TiledKSampler" OFF \
        "4" "ComfyUI_ADV_CLIP_emb" OFF \
        "5" "ComfyUI_Noise" OFF \
        "6" "ComfyUI_Dave_CustomNode" OFF \
        "7" "ComfyUI-Impact-Pack" OFF \
        "8" "ComfyUI-Manager" OFF \
        "9" "ComfyUI-Custom-Nodes" OFF \
        "10" "ComfyUI-Custom-Scripts" OFF \
        "11" "NodeGPT" OFF \
        "12" "Derfuu_ComfyUI_ModdedNodes" OFF \
        "13" "efficiency-nodes-comfyui" OFF \
        "14" "ComfyUI_node_Lilly" OFF \
        "15" "ComfyUI-nodes-hnmr" OFF \
        "16" "ComfyUI-Vextra-Nodes" OFF \
        "17" "ComfyUI-QualityOfLifeSuit_Omar92" OFF \
        "18" "FN16-ComfyUI-nodes" OFF \
        "19" "masquerade-nodes-comfyui" OFF \
        "20" "ComfyUI-post-processing-nodes" OFF \
        "21" "images-grid-comfy-plugin" OFF \
        "22" "ComfyUI-CLIPSeg" OFF \
        "23" "rembg-comfyui-node" OFF \
        "24" "ComfyUI_tinyterraNodes" OFF \
        "25" "yk-node-suite-comfyui" OFF \
        "26" "ComfyUI_experiments" OFF \
        "27" "ComfyUI_tagger" OFF \
        "28" "MergeBlockWeighted_fo_ComfyUI" OFF \
        "29" "ComfyUI-Saveaswebp" OFF \
        "30" "trNodes" OFF \
        "31" "ComfyUI_NetDist" OFF \
        "32" "ComfyUI-Image-Selector" OFF \
        "33" "ComfyUI-Strimmlarns-Aesthetic-Score" OFF \
        "34" "ComfyUI_UltimateSDUpscale" OFF \
        "35" "ComfyUI-Disco-Diffusion" OFF \
        "36" "ComfyUI-Waveform-Extensions" OFF \
        "37" "ComfyUI_Custom_Nodes_AlekPet" OFF \
        "38" "comfyui_controlnet_aux" ON \
        "39" "AIGODLIKE-COMFYUI-TRANSLATION" ON \
        3>&1 1>&2 2>&3)

    if [ ! -z "$extension_list" ]; then
        for extension_list_ in $extension_list; do
        case "$extension_list_" in
        "1")
        custom_node_install_list="https://github.com/WASasquatch/was-node-suite-comfyui $custom_node_install_list"
        ;;
        "2")
        custom_node_install_list="https://github.com/BlenderNeko/ComfyUI_Cutoff $custom_node_install_list"
        ;;
        "3")
        custom_node_install_list="https://github.com/BlenderNeko/ComfyUI_TiledKSampler $custom_node_install_list"
        ;;
        "4")
        custom_node_install_list="https://github.com/BlenderNeko/ComfyUI_ADV_CLIP_emb $custom_node_install_list"
        ;;
        "5")
        custom_node_install_list="https://github.com/BlenderNeko/ComfyUI_Noise $custom_node_install_list"
        ;;
        "6")
        custom_node_install_list="https://github.com/Davemane42/ComfyUI_Dave_CustomNode $custom_node_install_list"
        ;;
        "7")
        custom_node_install_list="https://github.com/ltdrdata/ComfyUI-Impact-Pack $custom_node_install_list"
        ;;
        "8")
        custom_node_install_list="https://github.com/ltdrdata/ComfyUI-Manager $custom_node_install_list"
        ;;
        "9")
        custom_node_install_list="https://github.com/Zuellni/ComfyUI-Custom-Nodes $custom_node_install_list"
        ;;
        "10")
        custom_node_install_list="https://github.com/pythongosssss/ComfyUI-Custom-Scripts $custom_node_install_list"
        ;;
        "11")
        custom_node_install_list="https://github.com/xXAdonesXx/NodeGPT $custom_node_install_list"
        ;;
        "12")
        custom_node_install_list="https://github.com/Derfuu/Derfuu_ComfyUI_ModdedNodes $custom_node_install_list"
        ;;
        "13")
        custom_node_install_list="https://github.com/LucianoCirino/efficiency-nodes-comfyui $custom_node_install_list"
        ;;
        "14")
        custom_node_install_list="https://github.com/lilly1987/ComfyUI_node_Lilly $custom_node_install_list"
        ;;
        "15")
        custom_node_install_list="https://github.com/hnmr293/ComfyUI-nodes-hnmr $custom_node_install_list"
        ;;
        "16")
        custom_node_install_list="https://github.com/diontimmer/ComfyUI-Vextra-Nodes $custom_node_install_list"
        ;;
        "17")
        custom_node_install_list="https://github.com/omar92/ComfyUI-QualityOfLifeSuit_Omar92 $custom_node_install_list"
        ;;
        "18")
        custom_node_install_list="https://github.com/Fannovel16/FN16-ComfyUI-nodes $custom_node_install_list"
        ;;
        "19")
        custom_node_install_list="https://github.com/BadCafeCode/masquerade-nodes-comfyui $custom_node_install_list"
        ;;
        "20")
        custom_node_install_list="https://github.com/EllangoK/ComfyUI-post-processing-nodes $custom_node_install_list"
        ;;
        "21")
        custom_node_install_list="https://github.com/LEv145/images-grid-comfy-plugin $custom_node_install_list"
        ;;
        "22")
        custom_node_install_list="https://github.com/biegert/ComfyUI-CLIPSeg $custom_node_install_list"
        ;;
        "23")
        custom_node_install_list="https://github.com/Jcd1230/rembg-comfyui-node $custom_node_install_list"
        ;;
        "24")
        custom_node_install_list="https://github.com/TinyTerra/ComfyUI_tinyterraNodes $custom_node_install_list"
        ;;
        "25")
        custom_node_install_list="https://github.com/guoyk93/yk-node-suite-comfyui $custom_node_install_list"
        ;;
        "26")
        custom_node_install_list="https://github.com/comfyanonymous/ComfyUI_experiments $custom_node_install_list"
        ;;
        "27")
        custom_node_install_list="https://github.com/gamert/ComfyUI_tagger $custom_node_install_list"
        ;;
        "28")
        custom_node_install_list="https://github.com/YinBailiang/MergeBlockWeighted_fo_ComfyUI $custom_node_install_list"
        ;;
        "29")
        custom_node_install_list="https://github.com/Kaharos94/ComfyUI-Saveaswebp $custom_node_install_list"
        ;;
        "30")
        custom_node_install_list="https://github.com/trojblue/trNodes $custom_node_install_list"
        ;;
        "31")
        custom_node_install_list="https://github.com/city96/ComfyUI_NetDist $custom_node_install_list"
        ;;
        "32")
        custom_node_install_list="https://github.com/SLAPaper/ComfyUI-Image-Selector $custom_node_install_list"
        ;;
        "33")
        custom_node_install_list="https://github.com/strimmlarn/ComfyUI-Strimmlarns-Aesthetic-Score $custom_node_install_list"
        ;;
        "34")
        custom_node_install_list="https://github.com/ssitu/ComfyUI_UltimateSDUpscale $custom_node_install_list"
        ;;
        "35")
        custom_node_install_list="https://github.com/space-nuko/ComfyUI-Disco-Diffusion $custom_node_install_list"
        ;;
        "36")
        custom_node_install_list="https://github.com/Bikecicle/ComfyUI-Waveform-Extensions $custom_node_install_list"
        ;;
        "37")
        custom_node_install_list="https://github.com/AlekPet/ComfyUI_Custom_Nodes_AlekPet $custom_node_install_list"
        ;;
        "38")
        custom_node_install_list="https://github.com/Fannovel16/comfyui_controlnet_aux $custom_node_install_list"
        extension_model_1=0
        ;;
        "39")
        custom_node_install_list="https://github.com/AIGODLIKE/AIGODLIKE-COMFYUI-TRANSLATION $custom_node_install_list"
        ;;
        *)
        exit 1
        ;;
        esac
        done
    fi
}

#安装前确认界面
function final_install_check()
{
    if (dialog --clear --title "Term-SD" --backtitle "安装确认选项" --yes-label "是" --no-label "否" --yesno "是否进行安装? \n
pip镜像源:$final_install_check_python \n
github代理:$final_install_check_github\n
强制使用pip:$final_install_check_force_pip\n
pytorch:$ins_pytorch\n
pip安装方式:$final_install_check_pip_methon\n
" 20 60);then
        echo "安装参数设置完成"
    else
        mainmenu
    fi
}

###############################################################################

#a1111-sd-webui安装处理部分
function process_install_a1111_sd_webui()
{
    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择
    a1111_sd_webui_extension_option #插件选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #开始安装
    echo "开始安装stable-diffusion-webui"
    git clone "$github_proxy"https://github.com/AUTOMATIC1111/stable-diffusion-webui.git

    cd ./stable-diffusion-webui
    venv_generate
    enter_venv
    cd ..

    #安装的依赖参考"stable-diffusion-webui/modules/launch_utils.py"
    if [ ! -d "./stable-diffusion-webui/repositories" ];then
        mkdir ./stable-diffusion-webui/repositories
    fi
    git clone "$github_proxy"https://github.com/sczhou/CodeFormer.git ./stable-diffusion-webui/repositories/CodeFormer
    git clone "$github_proxy"https://github.com/salesforce/BLIP.git ./stable-diffusion-webui/repositories/BLIP
    git clone "$github_proxy"https://github.com/Stability-AI/stablediffusion.git/ ./stable-diffusion-webui/repositories/stable-diffusion-stability-ai
    git clone "$github_proxy"https://github.com/Stability-AI/generative-models.git ./stable-diffusion-webui/repositories/generative-models
    git clone "$github_proxy"https://github.com/crowsonkb/k-diffusion.git ./stable-diffusion-webui/repositories/k-diffusion

    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5 #"--default-timeout=100 --retries 5"在网络差导致下载中断时重试下载
    pip install git+"$github_proxy"https://github.com/openai/CLIP.git --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

    pip install -r ./stable-diffusion-webui/repositories/CodeFormer/requirements.txt --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install -r ./stable-diffusion-webui/requirements.txt --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5 #安装stable-diffusion-webui的依赖

    echo "生成配置中"
    echo "{" > config-for-sd-webui.json
    echo "    \"quicksettings_list\": [" >> config-for-sd-webui.json
    echo "        \"sd_model_checkpoint\"," >> config-for-sd-webui.json
    echo "        \"sd_vae\"," >> config-for-sd-webui.json
    echo "        \"CLIP_stop_at_last_layers\"" >> config-for-sd-webui.json   
    echo "    ]," >> config-for-sd-webui.json
    echo "    \"save_to_dirs\": false," >> config-for-sd-webui.json
    echo "    \"grid_save_to_dirs\": false," >> config-for-sd-webui.json
    echo "    \"CLIP_stop_at_last_layers\": 2" >> config-for-sd-webui.json
    echo "}" >> config-for-sd-webui.json
    mv -fv config-for-sd-webui.json ./stable-diffusion-webui
    mv -fv ./stable-diffusion-webui/config-for-sd-webui.json ./stable-diffusion-webui/config.json

    if [ ! -z "$extension_install_list" ];then
        echo "安装插件中"
        for  extension_install_list_ in $extension_install_list ;do
            git clone "$github_proxy"$extension_install_list_ ./stable-diffusion-webui/extensions/$(echo $extension_install_list_ | awk -F'/' '{print $NF}')
        done
    fi

    echo "下载模型中"
    aria2c $aria2_multi_threaded https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -d ./stable-diffusion-webui/models/Stable-diffusion -o sd-v1-5.ckpt
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/4x-UltraSharp.pth -d ./stable-diffusion-webui/models/ESRGAN -o 4x-UltraSharp.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/BSRGAN.pth -d ./stable-diffusion-webui/models/ESRGAN -o BSRGAN.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/ESRGAN/ESRGAN_4x.pth -d ./stable-diffusion-webui/models/ESRGAN -o ESRGAN_4x.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/GFPGANv1.4.pth -d ./stable-diffusion-webui/models/ESRGAN -o GFPGANv1.4.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/detection_Resnet50_Final.pth -d ./stable-diffusion-webui/models/ESRGAN -o detection_Resnet50_Final.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_bisenet.pth -d ./stable-diffusion-webui/models/ESRGAN -o parsing_bisenet.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/GFPGAN/parsing_parsenet.pth -d ./stable-diffusion-webui/models/ESRGAN -o parsing_parsenet.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus.pth -d ./stable-diffusion-webui/models/ESRGAN -o RealESRGAN_x4plus.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/RealESRGAN/RealESRGAN_x4plus_anime_6B.pth -d ./stable-diffusion-webui/models/ESRGAN -o RealESRGAN_x4plus_anime_6B.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/EasyNegativeV2.safetensors -d ./stable-diffusion-webui/embeddings/negative -o EasyNegativeV2.safetensors
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/bad-artist-anime.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-artist-anime.pt
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/bad-artist.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-artist.pt
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/bad-hands-5.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-hands-5.pt
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/bad-image-v2-39000.pt -d ./stable-diffusion-webui/embeddings/negative -o bad-image-v2-39000.pt
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/bad_prompt_version2.pt -d ./stable-diffusion-webui/embeddings/negative -o bad_prompt_version2.pt
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/ng_deepnegative_v1_75t.pt -d ./stable-diffusion-webui/embeddings/negative -o ng_deepnegative_v1_75t.pt
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/verybadimagenegative_v1.3.pt -d ./stable-diffusion-webui/embeddings/negative -o verybadimagenegative_v1.3.pt
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-embeddings/resolve/main/yaguru%20magiku.pt -d ./stable-diffusion-webui/embeddings -o yaguru_magiku.pt

    if [ $extension_model_1 = 0 ];then #安装controlnet时再下载相关模型
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_ip2p_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11e_sd15_shuffle_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_canny_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1p_sd15_depth_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_inpaint_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_lineart_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_mlsd_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_normalbae_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_openpose_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_scribble_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_seg_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15_softedge_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11p_sd15s2_lineart_anime_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v11f1e_sd15_tile_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_style_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_seg_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_openpose_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_keypose_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_color_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_canny_sd15v2.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_depth_sd15v2.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_sketch_sd15v2.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o t2iadapter_zoedepth_sd15v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_brightness.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_brightness.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_illumination.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_illumination.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.safetensors -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_qrcode_monster.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.yaml -d ./stable-diffusion-webui/extensions/sd-webui-controlnet/models -o control_v1p_sd15_qrcode_monster.yaml
    fi

    if [ $extension_model_2 = 0 ];then #安装adetailer插件相关模型
        aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/deepfashion2_yolov8s-seg.pt -d ./stable-diffusion-webui/models/adetailer -o deepfashion2_yolov8s-seg.pt
        aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8m.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8m.pt
        aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8n.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8n.pt
        aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8n_v2.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8n_v2.pt
        aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov8s.pt -d ./stable-diffusion-webui/models/adetailer -o face_yolov8s.pt
        aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8n.pt -d ./stable-diffusion-webui/models/adetailer -o hand_yolov8n.pt
        aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov8s.pt -d ./stable-diffusion-webui/models/adetailer -o hand_yolov8s.pt
        aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8m-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8m-seg.pt
        aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8n-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8n-seg.pt
        aria2c $aria2_multi_threaded https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8s-seg.pt -d ./stable-diffusion-webui/models/adetailer -o person_yolov8s-seg.pt
    fi

    if [ $extension_model_3 = 0 ];then #安装sd-webui-IS-NET-pro插件相关模型
        aria2c $aria2_multi_threaded https://huggingface.co/ClockZinc/IS-NET_pth/resolve/main/isnet-general-use.pth -d ./stable-diffusion-webui/extensions/sd-webui-IS-NET-pro/saved_models/IS-Net -o isnet-general-use.pth
    fi

    echo "安装结束"
    exit_venv
}

#comfyui安装处理部分
function process_install_comfyui()
{
    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择
    comfyui_extension_option #comfyui插件选择
    comfyui_custom_node_option #comfyui自定义节点选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #开始安装comfyui
    echo "开始安装comfyui"
    git clone "$github_proxy"https://github.com/comfyanonymous/ComfyUI.git

    cd ./ComfyUI
    venv_generate
    enter_venv
    cd ..

    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    pip install -r ./ComfyUI/requirements.txt  --prefer-binary $python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5

    if [ ! -z "$extension_install_list" ];then
        echo "安装插件中"
        for extension_install_list_ in $extension_install_list ;do
            git clone "$github_proxy"$extension_install_list_ ./ComfyUI/web/extensions/$(echo $extension_install_list_ | awk -F'/' '{print $NF}')
        done
    fi

    if [ ! -z "$custom_node_install_list" ];then
        echo "安装自定义节点中"
        for custom_node_install_list_ in $custom_node_install_list ;do
            git clone "$github_proxy"$custom_node_install_list_ ./ComfyUI/custom_nodes/$(echo $custom_node_install_list_ | awk -F'/' '{print $NF}')
        done
    fi

    echo "下载模型中"
    aria2c https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -d ./ComfyUI/models/checkpoints/ -o sd-v1-5.ckpt

    if [ $extension_model_1 = 0 ];then
        echo "下载controlnet模型中"
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11e_sd15_ip2p_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11e_sd15_shuffle_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_canny_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11f1p_sd15_depth_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_inpaint_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_lineart_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_mlsd_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_normalbae_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_openpose_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_scribble_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_seg_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15_softedge_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11p_sd15s2_lineart_anime_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile_fp16.safetensors -d ./ComfyUI/models/controlnet -o control_v11f1e_sd15_tile_fp16.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_ip2p_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11e_sd15_ip2p_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11e_sd15_shuffle_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11e_sd15_shuffle_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_canny_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_canny_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1p_sd15_depth_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11f1p_sd15_depth_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_inpaint_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_inpaint_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_lineart_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_lineart_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_mlsd_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_mlsd_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_normalbae_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_normalbae_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_openpose_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_openpose_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_scribble_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_scribble_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_seg_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_seg_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15_softedge_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15_softedge_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11p_sd15s2_lineart_anime_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11p_sd15s2_lineart_anime_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/raw/main/control_v11f1e_sd15_tile_fp16.yaml -d ./ComfyUI/models/controlnet -o control_v11f1e_sd15_tile_fp16.yaml
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_style_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_style_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_sketch_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_seg_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_seg_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_openpose_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_openpose_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_keypose_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_keypose_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_depth_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_color_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_color_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd14v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_canny_sd14v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_canny_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_canny_sd15v2.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_depth_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_depth_sd15v2.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_sketch_sd15v2.pth -d ./ComfyUI/models/controlnet -o t2iadapter_sketch_sd15v2.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ckpt/ControlNet-v1-1/resolve/main/t2iadapter_zoedepth_sd15v1.pth -d ./ComfyUI/models/controlnet -o t2iadapter_zoedepth_sd15v1.pth
        aria2c $aria2_multi_threaded https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_brightness.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_brightness.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/ioclab/ioc-controlnet/resolve/main/models/control_v1p_sd15_illumination.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_illumination.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.safetensors -d ./ComfyUI/models/controlnet -o control_v1p_sd15_qrcode_monster.safetensors
        aria2c $aria2_multi_threaded https://huggingface.co/monster-labs/control_v1p_sd15_qrcode_monster/resolve/main/control_v1p_sd15_qrcode_monster.yaml -d ./ComfyUI/models/controlnet -o control_v1p_sd15_qrcode_monster.yaml
    fi
    echo "安装结束"
    exit_venv
}

#invokeai安装处理部分
function process_install_invokeai()
{
    #安装前准备
    proxy_option #代理选择
    python_dep_install #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #开始安装invokeai
    echo "开始安装invokeai"
    if [ ! -d "./InvokeAI" ];then
        mkdir InvokeAI
    fi
    cd ./InvokeAI
    venv_generate
    enter_venv
    if [ ! -d "./invokeai" ];then
        mkdir ./invokeai
    fi
    pip install invokeai $ins_pytorch $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x4plus.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x4plus.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x4plus_anime_6B.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x4plus_anime_6B.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/ESRGAN_SRx4_DF2KOST_official-ff704c30.pth -d ./invokeai/models/core/upscaling/realesrgan -o ESRGAN_SRx4_DF2KOST_official-ff704c30.pth
    aria2c $aria2_multi_threaded https://huggingface.co/licyk/sd-upscaler-models/resolve/main/invokeai/RealESRGAN_x2plus.pth -d ./invokeai/models/core/upscaling/realesrgan -o RealESRGAN_x2plus.pth
    echo "安装结束"
    exit_venv
}

#lora-scipts安装处理部分
function process_install_lora_scripts()
{
    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #参考lora-scripts里的install.bash写的
    echo "开始安装lora-scipts"
    git clone "$github_proxy"https://github.com/Akegarasu/lora-scripts.git #lora-scripts本体
    git clone "$github_proxy"https://github.com/kohya-ss/sd-scripts.git ./lora-scripts/sd-scripts #lora-scripts后端
    git clone "$github_proxy"https://github.com/hanamizuki-ai/lora-gui-dist ./lora-scripts/frontend #lora-scripts前端
    cd ./lora-scripts
    git submodule init
    git submodule update
    git submodule
    venv_generate
    enter_venv
    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --default-timeout=100 --retries 5
    cd ./sd-scripts
    pip install $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --upgrade -r requirements.txt --default-timeout=100 --retries 5 #sd-scripts目录下还有个_typos.toml,在安装requirements.txt里的依赖时会指向这个文件
    cd ..
    pip install $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --upgrade lion-pytorch dadaptation prodigyopt lycoris-lora fastapi uvicorn wandb scipy --default-timeout=100 --retries 5
    pip install $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --upgrade -r requirements.txt --default-timeout=100 --retries 5 #lora-scripts安装依赖
    cd ..
    aria2c $aria2_multi_threaded https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned-emaonly.ckpt -d ./lora-scripts/sd-models/ -o model.ckpt
    echo "安装结束"
    exit_venv
}

#选择重新安装pytorch
function pytorch_reinstall()
{
    #安装前的准备
    proxy_option #代理选择
    python_dep_install #pytorch选择
    pip_install_methon #安装方式选择
    final_install_check #安装前确认

    #开始安装pytorch
    venv_generate
    enter_venv
    pip install $ins_pytorch $python_proxy $extra_python_proxy $force_pip $pip_install_methon_select --force-reinstall --default-timeout=100 --retries 5
    exit_venv
}

###############################################################################

#插件管理部分

#a1111-sd-webui

#插件的安装或管理选项(该部分最先被调用)
function extension_methon()
{
    #功能选择界面
    final_extension_methon=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择A1111-SD-Webui插件管理选项的功能" 20 60 10 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部插件" \
        "4" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ "${final_extension_methon}" == '1' ]; then #选择安装
            extension_install
            extension_methon
        elif [ "${final_extension_methon}" == '2' ]; then #选择管理
            extension_manager
            extension_methon
        elif [ "${final_extension_methon}" == '3' ]; then #选择更新全部插件
            extension_all_update
            extension_methon
        elif [ "${final_extension_methon}" == '4' ]; then #选择返回
            echo
        fi
    fi
}

#插件管理界面
function extension_manager()
{
    dir_list=$(ls -l --time-style=+"%Y-%m-%d"  | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    extension_selection=$(
        dialog --clear --ok-label "确认" --cancel-label "取消" --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件列表" \
        --menu "请选择A1111-SD-Webui插件" 20 60 10 \
        $dir_list \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [[ -d "$extension_selection" ]]; then  # 选择文件夹
            cd "$extension_selection"
            operate_extension #调用operate_extension函数处理插件
            extension_manager
        elif [[ -f "$extension_selection" ]]; then
            extension_manager #留在当前目录
        else
            extension_manager #留在当前目录
        fi
    fi
}

#插件安装模块
function extension_install()
{
    extension_address=$(dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件安装选项" --yes-label "确认" --no-label "取消" --inputbox "请输入插件的github地址或其他下载地址" 20 60 3>&1 1>&2 2>&3)

    if [ $? = 0 ]; then
        git clone $extension_address
        if [ $? = "0" ];then
            dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件安装结果" --msgbox "A1111-SD-Webui插件安装成功" 20 60
        else
            dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件安装结果" --msgbox "A1111-SD-Webui插件安装失败" 20 60
        fi
    fi
}

#插件处理模块
function operate_extension() 
{
    #当git在子文件夹中找不到.git文件夹时,将会自动在父文件夹中寻找,以此类推,直到找到.git文件夹。用户的安装方式可能是直接下载源码压缩包,导致安装后的文件夹没有.git文件夹,直接执行git会导致不良的后果
    dialog_button_1=""
    dialog_button_2=""
    dialog_button_3=""
    if [ -d "./.git" ];then #检测目录中是否有.git文件夹
        dialog_button_1=""1" "更新""
        dialog_button_2=""3" "修复更新""
        dialog_button_3=""4" "版本切换""    
    fi

    final_operate_extension=$(
        dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对"$extension_selection"插件的管理功能" 20 60 10 \
        $dialog_button_1 \
        "2" "卸载" \
        $dialog_button_2 \
        $dialog_button_3 \
        "5" "返回" \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [ "${final_operate_extension}" == '1' ]; then
            echo "更新"$extension_selection"中"
            git pull
            if [ $? = "0" ];then
                dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件更新结果" --msgbox ""$extension_selection"插件更新成功" 20 60
            else
                dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件更新结果" --msgbox ""$extension_selection"插件更新失败" 20 60
            fi
            cd ..
        elif [ "${final_operate_extension}" == '2' ]; then
            if (dialog --clear --title "A1111-SD-Webui管理" --backtitle "A1111-SD-Webui插件删除选项" --yes-label "是" --no-label "否" --yesno "是否删除"$extension_selection"插件?" 20 60) then
                echo "删除"$extension_selection"插件中"
                cd ..
                rm -rfv ./$extension_selection
            else
                cd ..
            fi
        elif [ "${final_operate_extension}" == '3' ]; then
            echo "修复更新中"
            git reset --hard HEAD
            cd ..
        elif [ "${final_operate_extension}" == '4' ]; then
            git_checkout_manager
        elif [ "${final_operate_extension}" == '5' ]; then
            cd ..
        fi
    else
        cd ..
    fi
}

#comfyui
#comfyui的扩展分为两种,一种是前端节点,另一种是后端扩展.详见:https://github.com/comfyanonymous/ComfyUI/discussions/631

#comfyui前端节点管理
#自定义节点的安装或管理选项(该部分最先被调用)
function comfyui_custom_node_methon()
{
    #功能选择界面
    final_comfyui_custom_node_methon=$(
        dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI自定义节点管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI自定义节点管理选项的功能" 20 60 10 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部自定义节点" \
        "4" "安装全部自定义节点依赖" \
        "5" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ "${final_comfyui_custom_node_methon}" == '1' ]; then #选择安装
            comfyui_custom_node_install
            comfyui_custom_node_methon
        elif [ "${final_comfyui_custom_node_methon}" == '2' ]; then #选择管理
            comfyui_custom_node_manager
            comfyui_custom_node_methon
        elif [ "${final_comfyui_custom_node_methon}" == '3' ]; then #选择更新全部自定义节点
            extension_all_update
            comfyui_custom_node_methon
        elif [ "${final_comfyui_custom_node_methon}" == '4' ]; then #选择安装全部插件依赖
            comfyui_extension_dep_install
            comfyui_custom_node_methon
        elif [ "${final_comfyui_custom_node_methon}" == '5' ]; then #选择返回
            echo
        fi
    fi
}

#自定义节点管理界面
function comfyui_custom_node_manager()
{
    dir_list=$(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    comfyui_custom_node_selection=$(
        dialog --clear --yes-label "确认" --no-label "取消" --title "ComfyUI管理" --backtitle "ComfyUI自定义节点列表" \
        --menu "使用上下键选择要操作的插件并回车确认" 20 60 10 \
        $dir_list \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [[ -d "$comfyui_custom_node_selection" ]]; then  # 选择文件夹
            cd "$comfyui_custom_node_selection"
            operate_comfyui_custom_node #调用operate_extension函数处理插件
            comfyui_custom_node_manager
        elif [[ -f "$extension_selection" ]]; then
            comfyui_custom_node_manager #留在当前目录
        else
            comfyui_custom_node_manager #留在当前目录
        fi
    fi
}

#自定义节点安装模块
function comfyui_custom_node_install()
{
    comfyui_custom_node_address=$(dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装选项" --yes-label "确认" --no-label "取消" --inputbox "输入自定义节点的github地址或其他下载地址" 20 60 3>&1 1>&2 2>&3)

    if [ $? = 0 ]; then
        git clone $comfyui_custom_node_address
        git_req=$?
        comfyui_custom_node_dep_notice=""
        if [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_custom_node_address")/requirements.txt" ];then
            comfyui_custom_node_dep_notice="检测到该自定义节点需要安装依赖,请进入自定义节点管理功能,选中该自定义节点,运行一次\"安装依赖\"功能"
        elif [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_custom_node_address")/install.py" ];then
            comfyui_custom_node_dep_notice="检测到该自定义节点需要安装依赖,请进入自定义节点管理功能,选中该自定义节点,运行一次\"安装依赖\"功能"
        fi

        if [ $git_req = "0" ];then
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装结果" --msgbox "ComfyUI自定义节点安装成功\n$comfyui_custom_node_dep_notice" 20 60
        else
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI自定义节点安装结果" --msgbox "ComfyUI自定义节点安装失败" 20 60
        fi
    fi
}

#自定义节点处理模块
function operate_comfyui_custom_node() 
{
    #当git在子文件夹中找不到.git文件夹时,将会自动在父文件夹中寻找,以此类推,直到找到.git文件夹。用户的安装方式可能是直接下载源码压缩包,导致安装后的文件夹没有.git文件夹,直接执行git会导致不良的后果   
    dialog_button_1=""
    dialog_button_2=""
    dialog_button_3=""
    if [ -d "./.git" ];then #检测目录中是否有.git文件夹
        dialog_button_1=""1" "更新""
        dialog_button_2=""4" "修复更新""
        dialog_button_3=""5" "版本切换""    
    fi

    final_operate_comfyui_custom_node=$(
        dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI自定义节点管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对"$comfyui_custom_node_selection"自定义节点的管理功能" 20 60 10 \
        $dialog_button_1 \
        "2" "安装依赖" \
        "3" "卸载" \
        $dialog_button_2 \
        $dialog_button_3 \
        "6" "返回" \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [ "${final_operate_comfyui_custom_node}" == '1' ]; then
            echo "更新"$comfyui_custom_node_selection"中"
            git pull
            if [ $? = "0" ];then
                dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI自定义节点更新结果" --msgbox ""$comfyui_custom_node_selection"自定义节点更新成功" 20 60
            else
                dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI自定义节点更新结果" --msgbox ""$comfyui_custom_node_selection"自定义节点更新失败" 20 60
            fi
            cd ..
        elif [ "${final_operate_comfyui_custom_node}" == '2' ]; then #comfyui并不像a1111-sd-webui自动为插件安装依赖,所以只能手动装
            cd "$start_path/ComfyUI"
            enter_venv
            cd -
            dep_info="" #清除上次运行结果

            if [ -f "./install.py" ];then
                echo "安装"$comfyui_custom_node_selection"依赖"
                dep_info="$dep_info\n "$comfyui_custom_node_selection"插件:\n" #作为显示安装结果信息
            elif [ -f "./requirements.txt" ];then
                echo "安装"$comfyui_custom_node_selection"依赖"
                dep_info="$dep_info\n "$comfyui_custom_node_selection"插件:\n" #作为显示安装结果信息
            fi

            if [ -f "./install.py" ];then #找到install.py文件
                if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
                    python install.py
                else
                    python3 install.py
                fi
                if [ $? = 0 ];then #记录退出状态
                    dep_info="$dep_info     run install.py:成功\n"
                else
                    dep_info="$dep_info     run install.py:失败\n"
                fi
            fi

            if [ -f "./requirements.txt" ];then #找到requirement.txt文件
                pip install -r requirements.txt
                if [ $? = 0 ];then #记录退出状态
                    dep_info="$dep_info     install requirements.txt:成功\n"
                else
                    dep_info="$dep_info     install requirements.txt:失败\n"
                fi
            fi

            exit_venv
            cd ..
            dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI自定义节点依赖安装结果" --msgbox "当前依赖的安装情况列表\n--------------------------------------------------------$dep_info\n--------------------------------------------------------" 20 60
        elif [ "${final_operate_comfyui_custom_node}" == '3' ]; then
            if (dialog --clear --title "ComfyUI选项" --backtitle "ComfyUI自定义节点删除选项" --yes-label "是" --no-label "否" --yesno "是否删除"$comfyui_custom_node_selection"自定义节点?" 20 60) then
                echo "删除"$comfyui_custom_node_selection"自定义节点中"
                cd ..
                rm -rfv ./$comfyui_custom_node_selection
            else
                cd ..
            fi
        elif [ "${final_operate_comfyui_custom_node}" == '4' ]; then
            echo "修复更新中"
            git reset --hard HEAD
            cd ..
        elif [ "${final_operate_comfyui_custom_node}" == '5' ]; then
            git_checkout_manager
        elif [ "${final_operate_comfyui_custom_node}" == '6' ]; then
            cd ..
        fi
    else
        cd ..
    fi
}

#comfyui后端插件管理
#插件的安装或管理选项(该部分最先被调用)
function comfyui_extension_methon()
{
    #功能选择界面
    final_comfyui_extension_methon=$(
        dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择ComfyUI插件管理选项的功能" 20 60 10 \
        "1" "安装" \
        "2" "管理" \
        "3" "更新全部插件" \
        "4" "安装全部插件依赖" \
        "5" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ "${final_comfyui_extension_methon}" == '1' ]; then #选择安装
            comfyui_extension_install
            comfyui_extension_methon
        elif [ "${final_comfyui_extension_methon}" == '2' ]; then #选择管理
            comfyui_extension_manager
            comfyui_extension_methon
        elif [ "${final_comfyui_extension_methon}" == '3' ]; then #选择更新全部插件
            extension_all_update
            comfyui_extension_methon
        elif [ "${final_comfyui_extension_methon}" == '4' ]; then #选择安装全部插件依赖
            comfyui_extension_dep_install
            comfyui_extension_methon
        elif [ "${final_comfyui_extension_methon}" == '5' ]; then #选择返回
            echo
        fi
    fi
}

#插件管理界面
function comfyui_extension_manager()
{
    dir_list=$(ls -l --time-style=+"%Y-%m-%d" | awk -F ' ' ' { print $7 " " $6 } ') #当前目录文件和文件夹信息

    comfyui_extension_selection=$(
        dialog --clear --ok-label "确认" --cancel-label "取消" --title "ComfyUI管理" --backtitle "ComfyUI插件列表" \
        --menu "使用上下键选择要操作的插件并回车确认" 20 60 10 \
        $dir_list \
        3>&1 1>&2 2>&3)
    if [ $? = 0 ];then
        if [[ -d "$comfyui_extension_selection" ]]; then  # 选择文件夹
            cd "$comfyui_extension_selection"
            operate_comfyui_extension #调用operate_extension函数处理插件
            comfyui_extension_manager
        elif [[ -f "$extension_selection" ]]; then
            comfyui_extension_manager #留在当前目录
        else
            comfyui_extension_manager #留在当前目录
        fi
    fi
}

#插件安装模块
function comfyui_extension_install()
{
    comfyui_extension_address=$(dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件安装选项" --yes-label "确认" --no-label "取消" --inputbox "输入插件的github地址或其他下载地址" 20 60 3>&1 1>&2 2>&3)

    if [ $? = 0 ]; then
        git clone $comfyui_extension_address
        git_req=$?
        comfyui_extension_dep_notice=""
        if [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_extension_address")/requirements.txt" ];then
            comfyui_extension_dep_notice="检测到该插件需要安装依赖,请进入插件管理功能,选中该插件,运行一次\"安装依赖\"功能"
        elif [ -f "./$(awk -F "/" '{print $NF}' <<< "$comfyui_extension_address")/install.py" ];then
            comfyui_extension_dep_notice="检测到该插件需要安装依赖,请进入插件管理功能,选中该插件,运行一次\"安装依赖\"功能"
        fi

        if [ $git_req = "0" ];then
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件安装结果" --msgbox "ComfyUI插件安装成功\n$comfyui_extension_dep_notice" 20 60
        else
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件安装结果" --msgbox "ComfyUI插件安装失败" 20 60
        fi
    fi
}

#插件处理模块
function operate_comfyui_extension() 
{
    #当git在子文件夹中找不到.git文件夹时,将会自动在父文件夹中寻找,以此类推,直到找到.git文件夹。用户的安装方式可能是直接下载源码压缩包,导致安装后的文件夹没有.git文件夹,直接执行git会导致不良的后果   
    dialog_button_1=""
    dialog_button_2=""
    dialog_button_3=""
    if [ -d "./.git" ];then #检测目录中是否有.git文件夹
        dialog_button_1=""1" "更新""
        dialog_button_2=""4" "修复更新""
        dialog_button_3=""5" "版本切换""    
    fi

    final_operate_comfyui_extension=$(
        dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件管理选项" --ok-label "确认" --cancel-label "取消" --menu "请选择对"$comfyui_extension_selection"自定义节点的管理功能" 20 60 10 \
        $dialog_button_1 \
        "2" "安装依赖" \
        "3" "卸载" \
        $dialog_button_2 \
        $dialog_button_3 \
        "6" "返回" \
        3>&1 1>&2 2>&3)

    if [ $? = 0 ];then
        if [ "${final_operate_comfyui_extension}" == '1' ]; then
            echo "更新"$comfyui_extension_selection"中"
            git pull
            if [ $? = "0" ];then
                dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件更新结果" --msgbox ""$comfyui_extension_selection"插件更新成功" 20 60
            else
                dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件更新结果" --msgbox ""$comfyui_extension_selection"插件更新失败" 20 60
            fi
            cd ..
        elif [ "${final_operate_comfyui_extension}" == '2' ]; then #comfyui并不像a1111-sd-webui自动为插件安装依赖,所以只能手动装
            cd "$start_path/ComfyUI"
            enter_venv
            cd -
            dep_info="" #清除上次运行结果

            if [ -f "./install.py" ];then
                echo "安装"$comfyui_extension_selection"依赖"
                dep_info="$dep_info\n "$comfyui_extension_selection"插件:\n" #作为显示安装结果信息
            elif [ -f "./requirements.txt" ];then
                echo "安装"$comfyui_extension_selection"依赖"
                dep_info="$dep_info\n "$comfyui_extension_selection"插件:\n" #作为显示安装结果信息
            fi

            if [ -f "./install.py" ];then #找到install.py文件
                if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
                    python install.py
                else
                    python3 install.py
                fi
                if [ $? = 0 ];then #记录退出状态
                    dep_info="$dep_info     run install.py:成功\n"
                else
                    dep_info="$dep_info     run install.py:失败\n"
                fi
            fi

            if [ -f "./requirements.txt" ];then #找到requirement.txt文件
                pip install -r requirements.txt
                if [ $? = 0 ];then #记录退出状态
                    dep_info="$dep_info     install requirements.txt:成功\n"
                else
                    dep_info="$dep_info     install requirements.txt:失败\n"
                fi
            fi

            exit_venv
            cd ..
            dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件依赖安装结果" --msgbox "当前依赖的安装情况列表\n--------------------------------------------------------$dep_info\n--------------------------------------------------------" 20 60
        elif [ "${final_operate_comfyui_extension}" == '3' ]; then
            if (dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件删除选项" --yes-label "是" --no-label "否" --yesno "是否删除"$comfyui_extension_selection"插件?" 20 60) then
                echo "删除"$comfyui_extension_selection"插件中"
                cd ..
                rm -rfv ./$comfyui_extension_selection
            else
                cd ..
            fi
        elif [ "${final_operate_comfyui_extension}" == '4' ]; then
            echo "修复更新中"
            git reset --hard HEAD
            cd ..
        elif [ "${final_operate_comfyui_extension}" == '5' ]; then
            git_checkout_manager
        elif [ "${final_operate_comfyui_extension}" == '6' ]; then
            cd ..
        fi
    else
        cd ..
    fi
}

#comfyui插件/自定义节点依赖一键安装部分
function comfyui_extension_dep_install()
{
    cd "$start_path/ComfyUI"
    enter_venv
    cd -
    extension_folder=""
    dep_info="" #清除上次运行结果
    for extension_folder in ./*
    do
        [ -f "$extension_folder" ] && continue #排除文件
        cd $extension_folder
        if [ -f "./install.py" ];then
            echo "安装"$extension_folder"依赖"
            dep_info="$dep_info\n "$extension_folder"插件:\n" #作为显示安装结果信息
        elif [ -f "./requirements.txt" ];then
            echo "安装"$extension_folder"依赖"
            dep_info="$dep_info\n "$extension_folder"插件:\n" #作为显示安装结果信息
        fi

        if [ -f "./install.py" ];then #找到install.py文件
            if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
                python install.py
            else
                python3 install.py
            fi
            if [ $? = 0 ];then #记录退出状态
                dep_info="$dep_info     run install.py:成功\n"
            else
                dep_info="$dep_info     run install.py:失败\n"
            fi
        fi

        if [ -f "./requirements.txt" ];then #找到requirement.txt文件
            pip install -r requirements.txt
            if [ $? = 0 ];then #记录退出状态
                dep_info="$dep_info     install requirements.txt:成功\n"
            else
                dep_info="$dep_info     install requirements.txt:失败\n"
            fi
        fi
        cd ..
    done
    exit_venv
    dialog --clear --title "ComfyUI管理" --backtitle "ComfyUI插件/自定义节点依赖安装结果" --msgbox "当前依赖的安装情况列表\n--------------------------------------------------------$dep_info\n--------------------------------------------------------" 20 60
}

###############################################################################

#这些功能在a1111-sd-webui,comfyui,lora-script中共用的

#版本切换模块
function git_checkout_manager()
{
    echo "获取版本信息"
    commit_lists=$(git log --date=short --pretty=format:"%H %cd" --date=format:"%Y-%m-%d|%H:%M:%S" | awk -F  ' ' ' {print $1 " " $2} ')

    commit_selection=$(
        dialog --clear --title "Term-SD" --backtitle "项目切换版本选项" --ok-label "确认" --cancel-label "取消" \
        --menu "请选择要切换的版本\n当前版本:\n$(git show -s --format="%H %cd" --date=format:"%Y-%m-%d %H:%M:%S")" 20 70 10 \
        $commit_lists \
        3>&1 1>&2 2>&3)

    if [ "$?" = "0" ];then
        git checkout $commit_selection
    fi
    cd ..
}

#一键更新全部插件功能
function extension_all_update()
{
    echo "更新插件中"
    extension_folder="" #清除上次运行结果
    update_info=""
    for extension_folder in ./*
    do
        [ -f "$extension_folder" ] && continue #排除文件
        cd "$extension_folder"
        if [ -d "./.git" ];then #检测到目录中包含.git文件夹再执行更新操作
            echo "更新"$extension_folder"插件中"
            update_info="$update_info"$extension_folder"插件:"
            git pull
        
            if [ $? = 0 ];then
                update_info="$update_info"更新成功"\n"
            else
                update_info="$update_info"更新失败"\n"
            fi
        fi
        cd ..
    done
    dialog --clear --title "Term-SD" --backtitle "插件/自定义节点更新结果" --msgbox "当前插件/自定义节点的更新情况列表\n--------------------------------------------------------$update_info\n--------------------------------------------------------" 20 60
}

###############################################################################

#启动程序部分

term_sd_version_="0.3.10"

if [ $(uname -o) = "Msys" ];then #为了兼容windows系统
    test_python="python"
else
    test_python="python3"
fi

#显示版本信息
function term_sd_version()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD开始界面" --msgbox "版本信息:\n\n
系统:$(uname -o) \n
Term-SD:"$term_sd_version_" \n
python:$($test_python --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
pip:$(pip --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
aria2:$(aria2c --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ') \n
git:$(git --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $3} ') \n
dialog:$(dialog --version | awk 'NR==1'| awk -F  ' ' ' {print  " " $2} ') \n
\n
提示: \n
使用方向键、Tab键移动光标,Enter进行选择,Space键勾选或取消勾选,(已勾选显示[*]),Ctrl+C可中断指令的运行 \n
第一次使用Term-SD时先在主界面选择“帮助”查看使用说明,参数说明和注意的地方,内容不定期更新" 20 60
    mainmenu
}

#判断系统是否安装必须使用的软件
echo "检测依赖软件是否安装"
missing_dep=""
test_num=0
if which dialog > /dev/null ;then
    test_num=$(( $test_num + 1 ))
else
    missing_dep="$missing_dep dialog,"
fi

if which aria2c > /dev/null ;then
    test_num=$(( $test_num + 1 ))
else
    missing_dep="$missing_dep aria2,"
fi

if which $test_python > /dev/null;then
    test_num=$(( $test_num + 1 ))
else
    missing_dep="$missing_dep python,"
fi

if which pip >/dev/null;then
    test_num=$(( $test_num + 1 ))
else
    missing_dep="$missing_dep pip,"
fi

if which git > /dev/null;then
    test_num=$(( $test_num + 1 ))
else
    missing_dep="$missing_dep git,"
fi


#启动term-sd

if [ $test_num -ge 5 ];then
    for term_sd_launch_input in $(echo "$1 $2 $3 $4 $5 $6 $7 $8 $9") ;do
    case $term_sd_launch_input in
    "--help")
    echo
    echo "启动参数使用方法:"
    echo "  term-sd.sh [--help] [--dev] [--multi-threaded-download]"
    echo "选项:"
    echo "  --help\n        显示启动参数帮助"
    echo "  --dev\n        将term-sd更新源切换到dev分支"
    echo "  --multi-threaded-download\n        安装过程中启用多线程下载模型"
    exit 1
    ;;
    "--dev")
    echo "将term-sd更新源切换到dev分支"
    term_sd_branch=dev
    ;;
    "--multi-threaded-download")
    echo "安装过程中启用多线程下载模型"
    aria2_multi_threaded="-x 8"
    ;;
    esac
    done

    echo "初始化Term-SD完成"
    echo "启动Term-SD中"
    term_sd_version
else
    echo "缺少以下依赖"
    echo "--------------------"
    echo $missing_dep
    echo "--------------------"
    echo "请安装后重试"
    exit
fi
