#!/bin/bash

#term-sd帮助功能

#帮助选择
function help_option()
{
    help_option_select=$(dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --cancel-label "取消" --menu "请选择帮助" 23 70 12 \
        "1" "关于Term-SD" \
        "2" "使用说明" \
        "3" "Term-SD功能说明" \
        "4" "启动参数说明" \
        "5" "目录说明" \
        "6" "扩展脚本说明" \
        "7" "sd-webui插件说明" \
        "8" "ComfyUI插件/自定义节点说明" \
        "9" "返回" \
        3>&1 1>&2 2>&3 )

    if [ $? = 0 ];then
        if [ $help_option_select = 1 ];then
            help_option_1
            help_option
        elif [ $help_option_select = 2 ];then
            help_option_2
            help_option
        elif [ $help_option_select = 3 ];then
            help_option_3
            help_option
        elif [ $help_option_select = 4 ];then
            help_option_4
            help_option
        elif [ $help_option_select = 5 ];then
            help_option_5
            help_option
        elif [ $help_option_select = 6 ];then
            help_option_6
            help_option
        elif [ $help_option_select = 7 ];then
            help_option_7
            help_option
        elif [ $help_option_select = 8 ];then
            help_option_8
            help_option
        elif [ $help_option_select = 9 ];then
            mainmenu
        fi
    else
        mainmenu
    fi
}

#关于term-sd
function help_option_1()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "关于Term-SD:\n
Term-SD是基于终端显示的AI管理器,可以对AI软件进行简单的管理  \n
支持的AI软件如下: \n
1、AUTOMATIC1111-stable-diffusion-webui \n
2、ComfyUI \n
3、InvokeAI \n
4、lora-scripts \n
(AI软件都基于stable-diffusion)\n
\n
\n
该脚本的编写参考了https://gitee.com/skymysky/linux\n
脚本支持Windows,Linux,MacOS(Windows平台需安装msys2,MacOS需要安装homebrew)\n
\n
stable-diffusion相关链接:\n
https://huggingface.co/\n
https://civitai.com/\n
https://www.bilibili.com/read/cv22159609\n
\n
学习stable-diffusion-webui的教程:\n
https://licyk.netlify.app/2023/08/01/stable-diffusion-tutorial\n
\n
\n
" 23 70
}

#使用说明
function help_option_2()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "Term-SD使用说明:\n
1、使用方向键、Tab键移动光标,方向键翻页(鼠标滚轮无法翻页),Enter进行选择,Space键勾选或取消勾选,(已勾选时显示[*]),Ctrl+Shift+V粘贴文本,Ctrl+C可中断指令的运行,鼠标左键可点击按钮(右键无效)\n
2、初次使用时,建议在主界面先选择"pip镜像源",设置pip的镜像源为国内镜像源,加快安装时下载python软件包的速度。主界面显示的"虚拟环境"保持启用就行,无需禁用\n
3、主界面总共有四个AI软件可选(AUTOMATIC1111-stable-diffusion-webui,ComfyUI,InvokeAI,lora-scripts),回车选中后,如果在脚本的当前目录未找选中的AI软件,term-sd会提示你进行安装。\n
4、安装前将会提示你进行安装准备,首先是"代理选择",有4个选项可选(启用pip镜像源,启用github代理,强制使用pip,huggingface独占代理),前3个选项选项默认勾选(\"huggingface独占代理\"仅在设置代理参数后才会启动),如果没有质量较好的代理工具,不建议取消勾选。"强制使用pip"只有禁用了虚拟环境时才建议勾选(在Linux中,如果不在虚拟环境中安装python软件包,pip模块会警告\"error: externally-managed-environment\",只有使用"--break-system-packages"参数才能进行安装)\n
5、然后是"pytorch安装",pytorch版本的选择:nvidia显卡选择cuda(Windows,linux平台),amd显卡在linux平台选择rocm,amd显卡和intel显卡在windows平台选择directml,macos选择不带cuda,rocm,directml的版本,如果想要在cpu上进行跑图,选择cpu版本(不知道选版本号时,英伟达显卡直接选\"Torch+xformers\"(Windows平台,Linux平台),AMD显卡和Intel显卡直接选\"Torch\"(仅限Linux平台,在Windows平台上选\"Torch 2.0.0+Torch-Directml\"),pip包管理器应该会自动选择相应的版本)\n
6、AUTOMATIC1111-stable-diffusion-webui,ComfyUI会有额外的插件/自定义节点选择,默认勾选一些比较实用的,可根据需要勾选额外的,插件/自定义节点的介绍在帮助中查询。(AI软件在安装好后,如果在插件安装列表有想要安装的,可使用扩展脚本中带有"extension"名字的脚本进行安装)\n
7、安装前的准备完成后,将会弹出安装确认界面,选择"是"开始安装\n
8、安装结束后,会自动进入该AI软件的管理界面,在该界面中可以对AI软件进行更新,卸载,启动等操作\n
9、在安装之后,pip模块会产生大量的缓存,可使用主界面的"pip缓存清理"进行删除\n
10、使用quick-cmd启动参数安装快捷启动命令后,可使用\"termsd\"或者\"tsd\"命令启动Term-SD\n
11、使用\"./term-sd.sh\"命令启动时可在命令后面添加启动参数(使用quick-cmd启动参数安装快捷启动命令后可使用\"termsd\"或者\"tsd\"命令替换\"./term-sd.sh\"命令)\n
\n
注意事项:\n
1、安装AI软件的路径和Term-SD脚本所在路径相同,方便管理\n
2、若AI软件使用了venv虚拟环境,移动AI软件到新的路径后需要使用Term-SD的“重新生成venv虚拟环境”功能,才能使venv虚拟环境正常工作\n
3、在更新或者切换版本失败时可以使用“更新修复”解决,然后再点一次“更新”\n
4、Term-SD只有简单的安装,管理功能,若要导入模型等操作需手动在文件管理器上操作\n
5、如果没有质量较好的代理工具,建议在安装时使用git代理和python镜像源\n
6、建议保持启用虚拟环境,因为不同AI软件对软件包的版本要求不同,关闭后易导致不同的AI软件出现依赖问题\n
7、AUTOMATIC1111-stable-diffusion-webui安装好后,可以使用秋叶aaaki制作的启动器来启动sd-webui。将秋叶的启动器放入stable-diffusion-webui文件夹中,双击启动(仅限windows,因为秋叶的启动器只有windows的版本)\n
8、ComfyUI目前并没有自动为插件或者自定义节点安装依赖的功能,所以安装插件或者自定义节点后后,推荐运行一次\"安装依赖\"功能,有些依赖下载源是在github上的,无法下载时请使用代理工具(已知问题:因为一些插件/自定义节点的安装依赖方式并不统一,term-sd的依赖安装功能可能没有用,需要手动进行安装依赖)\n
9、启动ComfyUI时,在\"Import times for custom nodes:\"过程如果出现\"IMPORT FAILED\",则找到对应自定义节点,运行一次\"安装依赖\"功能,或者使用\"安装全部自定义节点依赖\"功能进行依赖安装\n
10、InvokeAI在安装好后,要运行一次invokeai-configure,到\"install stable diffusion models\"界面时,可以把所有的模型取消勾选,因为有的模型是从civitai下载的,如果没有开启代理会导致下载失败\n
11、在插件/自定义节点的管理功能中没有"更新","切换版本","修复更新"这些按钮,是因为这些插件/自定义节点的文件夹内没有".git"文件夹,如果是从github上直接下载压缩包再解压安装的就会有这种情况\n
12、A1111-SD-Webui设置界面语言:点击\"Settings\"-->\"User interface\"-->\"Localization\",点击右边的刷新按钮,再选择(防止不显示出来),在列表中选择zh-Hans(stable)(Term-SD在安装时默认下载了中文插件),再点击上面的\"Apply settings\",最后点击\"Reload UI\"生效\n
13、ComfyUI设置界面语言:点击右上角的齿轮图标,找到\"AGLTranslation-langualge\",选择\"中文\",ComfyUi将会自动切换中文\n
14、InvokeAI设置界面语言:点击右上角的三条横杠的图标,然后点击Settings,然后找到Language选项,点击文字下方的选项框,找到简体中文并选中即可\n
15、如遇到网络问题,比如下载模型失败等,且在开启代理后依然无法解决问题时,可设置代理。代理参数的格式为\"ip:port\",参数例子:\"127.0.0.1:10808\",ip、port、代理协议需查看用户使用的代理软件配置(在终端环境中,除了有驱动模式或者TUN模式的代理软件,一般没办法为终端设置代理,所以可以使用该功能为终端环境设置代理)\n
16、在代理选项中\"huggingface独占代理\"可在安装过程中单独为从huggingface中下载模型时单独启用代理,保证安装速度,因为除了从huggingface下载模型的过程之外,其他下载过程可以不走代理进行下载(注:在使用驱动模式或者TUN模式的代理软件时,该功能无效,因为代理软件会强制让所有网络流量走代理)\n
17、一般在安装时,一路回车保持默认值也可以安装\n
\n
" 23 70
}

#term-sd功能介绍
function help_option_3()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "Term-SD功能说明:\n
参数使用方法(设置快捷启动命令后可将\"./term-sd.sh\"替换成\"termsd\"或者\"tsd\"):\n
  ./term-sd.sh [--help] [--extra] [--multi-threaded-download] [--enable-auto-update] [--disable-auto-update] [--reinstall-term-sd] [--remove-term-sd] [--test-proxy] [--quick-cmd] [--set-python-path] [--set-pip-path] [--unset-python-path] [--unset-pip-path]\n
参数功能:\n
help:显示启动参数帮助\n
extra:启动扩展脚本\n
multi-threaded-download:安装过程中启用多线程下载模型\n
enable-auto-update:启动Term-SD自动检查更新功能\n
disable-auto-update:禁用Term-SD自动检查更新功能\n
reinstall-term-sd:重新安装Term-SD\n
remove-term-sd:卸载Term-SD\n
test-proxy:测试网络环境,用于测试代理是否可用\n
quick-cmd:将Term-SD快捷启动指令安装到shell中,在shell中直接输入\"termsd\"即可启动Term-SD\n
set-python-path:手动指定python解释器路径\n
set-pip-path:手动指定pip路径\n
unset-python-path:删除自定义python解释器路径配置\n
unset-pip-path:删除自定义pip解释器路径配置\n
\n
Term-SD的功能(除了安装,更新,启动,卸载):\n
主界面:\n
Term-SD更新管理:对本脚本进行更新,更换更新源,切换版本分支\n
venv虚拟环境设置:启用/禁用venv环境,默认保持启用,防止不同AI软件因软件包版本不同造成互相干扰\n
pip镜像源设置:设置pip的下载源,解决国内网络环境访问pip软件源速度慢的问题\n
pip缓存清理:清理pip在安装软件包后产生的缓存\n
代理设置:为Term-SD访问网络设置代理,一般用在代理软件开启后,Term-SD安装AI软件时依然出现无法访问huggingface等资源的问题(如果代理软件有驱动模式或者TUN模式时则不会有这种问题,就不需要使用\"代理设置\"进行配置代理)\n
空间占用分析:显示Term-SD管理的AI软件的所占空间\n
管理功能:\n
修复更新:在更新AI软件时出现更新失败时,可使用该功能进行修复\n
切换版本:对AI软件的版本进行切换\n
更新源切换:切换AI软件的更新源,解决国内网络下载慢的问题\n
管理插件/自定义节点:对AI软件的插件/自定义节点进行管理\n
更新依赖:更新ai的python包依赖,一般情况下不需要用到\n
重新安装:重新执行一次AI软件的安装\n
重新安装pytorch:用于切换pytorch版本(pytorch为ai的框架,为ai提供大量功能)\n
重新生成venv虚拟环境:在移动AI软件的文件夹后,venv会出现路径问题而导致运行异常,该功能可修复该问题\n
重新构建venv虚拟环境:venv出现比较严重的软件包版本问题,导致AI软件运行异常,此时可使用该功能进行修复(该功能同时会运行\"重新生成venv虚拟环境\"功能)\n
安装准备功能:\n
启用pip镜像源:使用国内镜像源下载python软件包\n
启用github代理:使用github代理站下载github上的软件\n
huggingface独占代理:仅在下载huggingface上的模型时使用代理,且只在配置代理设置后才会生效(注:在使用驱动模式或者TUN模式的代理软件时,该功能无效,因为代理软件会强制让所有网络流量走代理)\n
强制使用pip:忽略系统警告强制使用pip包管理器下载软件包,一般用不到,只有在Linux系统中,禁用虚拟环境后才需要使用(不推荐禁用虚拟环境)\n
常规安装(setup.py):使用常规安装方式\n
标准构建安装(--use-pep517):使用编译安装方式(有时可以解决python软件包安装失败的问题。在InvokeAI官方文档中,安装时推荐使用该模式,实际上用常规安装也可以)\n
\n
\n
" 23 70
}

#启动参数说明
function help_option_4()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "A1111-SD-Webui启动参数说明:\n
stable diffusion webui的启动参数:\n
skip-torch-cuda-test:不检查CUDA是否正常工作\n
no-half:不将模型切换为16位浮点数\n
no-half-vae:不将VAE模型切换为16位浮点数\n
medvram:启用稳定扩散模型优化(6g显存时使用),以牺牲速度换取低VRAM使用\n
lowvram:启用稳定扩散模型优化(4g显存时使用),大幅牺牲速度换取极低VRAM使用\n
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
medvram-sdxl:仅在SDXL模型上启用稳定扩散模型优化(8g显存时使用),以牺牲速度换取低VRAM使用\n
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
" 23 70
}

#目录说明
function help_option_5()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "AI软件的目录说明:\n
在启用venv虚拟环境后,在安装时AI软件的目录下会产生venv文件夹,这个是python软件包安装的目录,更换cudnn可在该文件夹中操作\n
\n
\n
stable diffusion webui目录的说明(只列举比较重要的):\n
stable-diffusion-webui\n
├── embeddings   embeddings模型存放位置\n
├── extensions   插件存放位置\n
├── launch.py    term-sd启动sd-webui的方法\n
├── config.json  stable-diffusion-webui的配置文件,需要重置设置时删除该文件即可\n
├── outputs   生成图片的保存位置\n
└── models    模型存放目录\n
    ├── ESRGAN    放大模型存放位置\n
    ├── GFPGAN    放大模型存放位置\n
    ├── hypernetworks    hypernetworks模型存放位置\n
    ├── Lora    Lora模型存放位置\n
    ├── RealESRGAN    放大模型存放位置\n
    ├── Stable-diffusion    大模型存放位置\n
    └── VAE    VAE模型存放位置\n
\n
\n
ComfyUI目录的部分说明(只列举比较重要的):\n
ComfyUI\n
├── custom_nodes   自定义节点存放位置\n
├── main.py        term-sd启动ComfyUI的方法\n
├── models         模型存放位置\n
│   ├── checkpoints    大模型存放位置\n
│   ├── controlnet   controlnet模型存放位置\n
│   ├── embeddings   embeddings模型存放位置\n
│   ├── hypernetworks   hypernetworks模型存放位置\n
│   ├── loras   Lora模型存放位置\n
│   ├── upscale_models   放大模型存放位置\n
│   └── vae   VAE模型存放位置\n
├── output   生成图片的保存位置\n
└── web\n
    └── extensions   插件存放位置\n
\n
\n
InvokeAI目录的部分说明(只列举比较重要的):\n
├── configs   配置文件存放目录\n
├── invokeai.yaml   主要配置文件,需要重置设置时删除该文件即可\n
├── models   模型存放位置\n
│   ├── core\n
│   │   └── upscaling\n
│   │       └── realesrgan   放大模型存放位置\n
│   ├── sd-1   sd1.5模型的存放位置\n
│   │   ├── controlnet   controlnet模型存放位置\n
│   │   ├── embedding   embeddings模型存放位置\n
│   │   ├── lora   Lora模型存放位置\n
│   │   ├── main\n
│   │   ├── onnx\n
│   │   └── vae   VAE模型存放位置\n
│   ├── sd-2\n
│   │   ├── controlnet\n
│   │   ├── embedding\n
│   │   ├── lora\n
│   │   ├── main\n
│   │   ├── onnx\n
│   │   └── vae\n
│   ├── sdxl\n
│   │   ├── controlnet\n
│   │   ├── embedding\n
│   │   ├── lora\n
│   │   ├── main\n
│   │   ├── onnx\n
│   │   └── vae\n
│   └── sdxl-refiner\n
│       ├── controlnet\n
│       ├── embedding\n
│       ├── lora\n
│       ├── main\n
│       ├── onnx\n
│       └── vae\n
└── outputs   生成图片的存放位置\n
\n
\n
lora-scripts目录的部分说明(只列举比较重要的):\n
lora-scripts\n
├── gui.py   term-sd启动lora-scripts的方法\n
├── logs   日志存放位置\n
├── output   训练得到的模型存放位置\n
├── sd-models   训练所用的底模存放位置\n
└── toml   保存的训练参数存放位置\n
\n
\n
" 23 70
}

#扩展脚本说明
function help_option_6()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "Term-SD扩展脚本说明:\n
扩展脚本列表(启动Term-SD时加入\"--extra\"启动参数即可使用扩展脚本):\n
sd-webui-extension:安装sd-webui的插件\n
comfyui-extension:安装ComfyUI的插件\n
\n
\n
" 23 70
}

#AUTOMATIC1111-stable-diffusion-webui插件说明
function help_option_7()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "AUTOMATIC1111-stable-diffusion-webui插件说明:\n
注:有些插件因为年久失修,可能会出现兼容性问题。具体介绍请在github上搜索项目\n
\n
kohya-config-webui: 一个用于生成kohya-ss训练脚本使用的toml配置文件的WebUI\n
sd-webui-additional-networks:将 LoRA 等模型添加到stable diffusion以生成图像的扩展\n
a1111-sd-webui-tagcomplete:输入Tag时提供booru风格(如Danbooru)的TAG自动补全\n
multidiffusion-upscaler-for-automatic1111:在有限的显存中进行大型图像绘制,提供图片区域控制\n
sd-dynamic-thresholding:解决使用更高的 CFG Scale 而出现颜色问题\n
sd-webui-cutoff:解决tag污染\n
sd-webui-model-converter:模型转换扩展\n
sd-webui-supermerger:模型合并扩展\n
stable-diffusion-webui-localization-zh_Hans:WEBUI中文扩展\n
stable-diffusion-webui-wd14-tagger:图片tag反推\n
sd-webui-regional-prompter:图片区域分割\n
stable-diffusion-webui-baidu-netdisk:强大的图像管理器\n
stable-diffusion-webui-anti-burn:通过跳过最后几个步骤并将它们之前的一些图像平均在一起来平滑生成的图像,加快点击停止生成图像后WEBUI的响应速度\n
loopback_scaler:使用迭代过程增强图像分辨率和质量\n
latentcoupleregionmapper:控制绘制和定义区域\n
ultimate-upscale-for-automatic1111:图片放大工具\n
deforum-for-automatic1111:视频生成插件\n
stable-diffusion-webui-images-browser:图像管理器\n
stable-diffusion-webui-huggingface:huggingface模型下载扩展\n
sd-civitai-browser:civitai模型下载扩展\n
a1111-stable-diffusion-webui-vram-estimator:显存占用评估\n
openpose-editor:openpose姿势编辑\n
sd-webui-depth-lib:深度图库,用于Automatic1111/stable-diffusion-webui的controlnet扩展\n
posex:openpose姿势编辑\n
sd-webui-tunnels:WEBUI端口映射扩展\n
batchlinks-webui:批处理链接下载器\n
stable-diffusion-webui-catppuccin:WEBUI主题\n
a1111-sd-webui-lycoris:添加lycoris模型支持\n
stable-diffusion-webui-rembg:人物背景去除\n
stable-diffusion-webui-two-shot:图片区域分割和控制\n
sd-webui-lora-block-weight:lora分层扩展\n
sd-face-editor:面部编辑器\n
sd-webui-segment-anything:图片语义分割\n
sd-webui-controlnet:图片生成控制\n
sd-webui-prompt-all-in-one:tag翻译和管理插件\n
sd-webui-comfyui:在WEBUI添加ComfyUI界面\n
sd-webui-animatediff:GIF生成扩展\n
sd-webui-photopea-embed:在WEBUI界面添加ps功能\n
sd-webui-openpose-editor:ControlNet的pose编辑器\n
sd-webui-llul:给图片的选定区域增加细节\n
sd-webui-bilingual-localization:WEBUI双语对照翻译插件\n
adetailer:图片细节修复扩展\n
sd-webui-mov2mov:视频逐帧处理插件\n
sd-webui-IS-NET-pro:人物抠图\n
ebsynth_utility:视频处理扩展\n
sd_dreambooth_extension:dreambooth模型训练\n
sd-webui-memory-release:显存释放扩展\n
stable-diffusion-webui-dataset-tag-editor:训练集打标和处理扩展\n
sd-webui-stablesr:图片放大\n
sd-webui-deoldify:黑白图片上色\n
stable-diffusion-webui-model-toolkit:大模型数据查看\n
sd-webui-oldsix-prompt-dynamic:动态提示词\n
sd-webui-fastblend:ai视频平滑\n
StyleSelectorXL:选择SDXL模型画风\n
sd-dynamic-prompts:动态提示词\n
LightDiffusionFlow:保存工作流\n
sd-webui-workspace:保存webui生图的参数\n
openOutpaint-webUI-extension:提供类似InvokeAI的统一画布的功能\n
sd-webui-EasyPhoto:以简单的操作生成自己的ai人像\n
\n
\n
" 23 70
}

#ComfyUI插件/自定义节点说明
function help_option_8()
{
    dialog --clear --title "Term-SD" --backtitle "Term-SD帮助选项" --ok-label "确认" --msgbox "ComfyUI插件/自定义节点说明:\n
注:具体介绍请在github上搜索项目\n
\n
插件:\n
ComfyUI-extensions:ComfyUI插件扩展\n
graphNavigator:节点辅助插件\n
\n
节点:\n
was-node-suite-comfyui:适用于 ComfyUI 的广泛节点套件，包含 190 多个新节点\n
ComfyUI_Cutoff:解决tag污染\n
ComfyUI_TiledKSampler:ComfyUI 的平铺采样器\n
ComfyUI_ADV_CLIP_emb:高级剪辑文本编码,可让您选择解释提示权重的方式\n
ComfyUI_Noise:噪声控制\n
ComfyUI_Dave_CustomNode:图片区域控制\n
ComfyUI-Impact-Pack:通过检测器、细节器、升频器、管道等方便地增强图像\n
ComfyUI-Manager:自定义节点/插件管理器\n
ComfyUI-Custom-Nodes:ComfyUI的自定义节点\n
ComfyUI-Custom-Scripts:ComfyUI的增强功能\n
NodeGPT:使用GPT辅助生图\n
Derfuu_ComfyUI_ModdedNodes:方程式节点\n
efficiency-nodes-comfyui:ComfyUI 的效率节点\n
ComfyUI_node_Lilly:通配符文本工具\n
ComfyUI-nodes-hnmr:包含X/Y/Z-plot X/Y/Z,合并,潜在可视化,采样等节点\n
ComfyUI-Vextra-Nodes:包含像素排序,交换颜色模式,拼合颜色等节点\n
ComfyUI-QualityOfLifeSuit_Omar92:包含GPT辅助标签生成,字符串操作,latentTools等节点\n
FN16-ComfyUI-nodes:ComfyUI自定义节点集合\n
masquerade-nodes-comfyui:ComfyUI 掩码相关节点\n
ComfyUI-post-processing-nodes:ComfyUI的后处理节点集合,可实现各种酷炫的图像效果\n
images-grid-comfy-plugin:XYZPlot图生成\n
ComfyUI-CLIPSeg:利用 CLIPSeg 模型根据文本提示为图像修复任务生成蒙版\n
rembg-comfyui-node:背景去除\n
ComfyUI_tinyterraNodes:ComfyUI的自定义节点\n
yk-node-suite-comfyui:ComfyUI的自定义节点\n
ComfyUI_experiments:ComfyUI 的一些实验性自定义节点\n
ComfyUI_tagger:图片tag反推\n
MergeBlockWeighted_fo_ComfyUI:权重合并\n
ComfyUI-Saveaswebp:将生成的图片保存为webp格式\n
trNodes:通过蒙版混合两个图像\n
ComfyUI_NetDist:在多个本地 GPU/联网机器上运行 ComfyUI 工作流程\n
ComfyUI-Image-Selector:从批处理中选择一个或多个图像\n
ComfyUI-Strimmlarns-Aesthetic-Score:图片美学评分\n
ComfyUI_UltimateSDUpscale:图片放大\n
ComfyUI-Disco-Diffusion:Disco Diffusion模块\n
ComfyUI-Waveform-Extensions:一些额外的音频工具,用于示例扩散ComfyUI扩展\n
ComfyUI_Custom_Nodes_AlekPet:包括姿势,翻译等节点\n
comfy_controlnet_preprocessors:ComfyUI的ControlNet辅助预处理器\n
AIGODLIKE-COMFYUI-TRANSLATION:ComfyUI的翻译扩展\n
stability-ComfyUI-nodes:Stability-AI自定义节点支持\n
\n
\n
" 23 70
}
