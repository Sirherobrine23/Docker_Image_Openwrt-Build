#!/bin/bash
# importando e exportando as configurações
echo "Seu diretorio da copilação inicial é: $(pwd)"
export DIR2="$(pwd)"
chmod 775 /home/copiler/
chown copilador:copilador /home/copiler
export uploadssh23="$DIR2/publics/"
echo "Diretorio para Uploads: $uploadssh23"
# echo "$HOMEDIR"
echo "Diretorio Principal: $DIR2"
#
[ -z $URL ] && echo 'not informed url repo, using git.openwrt.org'; URL='https://git.openwrt.org/openwrt/openwrt.git'
[ -z $BRANCH ] && echo 'not informed brach, using master' BRANCH='master'
#
export REPO_URL="$(echo "$URL")"
export REPO_BRANCH="$(echo "$BRANCH")"
export FEEDS_CONF="$(echo "$FEED_FILE")"
export CONFIG_FILE="$(echo "$CONFIG")"
export DIY_P1_SH="$(echo "$P1")"
export DIY_P2_SH="$(echo "$P2")"
#
echo "As variaveis pré-definidas pelo Usuario"
echo "URL do repositorio de copilação: $REPO_URL"
echo "BRANCH do repositorio: $REPO_BRANCH"
echo "Configurações do feed: $FEEDS_CONF"
echo "Arquivo da copilação: $CONFIG_FILE"
echo "Arquivo de custumização P1: $DIY_P1_SH"
echo "Arquivo de custumização P2: $DIY_P2_SH"
echo "a pasta do arquivos pós copilação sera: $uploadssh23"
mkdir publics/
# cp -rf "$P1" /home/copiler/
# cp -rf "$P2" /home/copiler/
# cp -rf "$FEED_FILE" /home/copiler/
cp -rfv . /home/copiler/
# chamando o copilador
cd /home/copiler/
clone(){
    df -hT $(pwd)
    git clone --depth 1 $REPO_URL -b $REPO_BRANCH /home/copiler/openwrt
    status1=1
}
p1(){
    [ -e $FEEDS_CONF ] && mv $FEEDS_CONF openwrt/feeds.conf.default
    chmod +x /home/copiler/$DIY_P1_SH
    cd /home/copiler/openwrt
    /home/copiler/$DIY_P1_SH
    cd /home/copiler/
    status2=1
}
update(){
    cd /home/copiler/openwrt 
    ./scripts/feeds update -a &> /home/copiler/log_update.txt
    cd /home/copiler/
    status3=1
}
update_install(){
    cd /home/copiler/openwrt
    ./scripts/feeds install -a &> /home/copiler/log_install.txt
    cd /home/copiler/
    status4=1
}
p2(){
    [ -e files ] && mv files openwrt/files
    [ -e $CONFIG_FILE ] && mv $CONFIG_FILE openwrt/.config
    chmod +x /home/copiler/$DIY_P2_SH
    cd /home/copiler/openwrt
    /home/copiler/$DIY_P2_SH
    cd /home/copiler/
    status5=1
}
make_download(){
    cd /home/copiler/openwrt
    make defconfig
    make download -j8
    find dl -size -1024c -exec ls -l {} \;
    find dl -size -1024c -exec rm -f {} \;
    cd /home/copiler/
    status6=1
}
make_copiler(){
    cd /home/copiler/openwrt
    echo -e "$(nproc) thread compile"
    make -j$(nproc) || build1='1'
        if [ $build1 == '1' ];then
            make -j1 || build2='1'
            if [ $build2 == '1' ];then
                make -j1 V=s
            fi
        fi
    cd /home/copiler/
    status7=1
}
final(){
    cd /home/copiler/openwrt/bin/targets/*/*
    rm -rfv packages *.squashfs *.manifest *lzma.bin *.elf *vmlinux.bin *vmlinux.lzma
    FILESUP="$(ls)"
    zip ../upload.zip -r ./
    rm -rfv *
    mv -rfv ../upload.zip ./
    cp -rfv * $uploadssh23
    echo "You files to Upload"
    echo "$FILESUP"
    status8=1
}
# status1-8=1
echo 'root !WARNING!'
export FORCE_UNSAFE_CONFIGURE=1
clone 
if [ $status1 == '1' ];then
    p1
    if [ $status2 == '1' ];then
        update
        if [ $status3 == '1' ];then
            update_install 
            if [ $status4 == '1' ];then
                p2
                if [ $status5 == '1' ];then
                    make_download
                    if [ $status6 == '1' ];then
                        make_copiler
                        if [ $status7 == '1' ];then
                            final
                            if [ $status8 == '1' ];then
                                exit 0
                            else
                                exit 134
                            fi
                        else
                            exit 133
                        fi
                    else
                        exit 132
                    fi
                else
                    exit 131
                fi
            else
                exit 130
            fi
        else
            exit 129
        fi
    else
     exit 128
    fi
else
    exit 127
fi