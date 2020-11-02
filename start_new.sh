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
cp -rf . /home/copiler/
# chamando o copilador
cd /home/copiler/
clone(){
    df -hT $(pwd)
    git clone --depth 1 $REPO_URL -b $REPO_BRANCH /home/copiler/openwrt
}
p1(){
    [ -e $FEEDS_CONF ] && mv $FEEDS_CONF openwrt/feeds.conf.default
    chmod +x /home/copiler/$DIY_P1_SH
    cd /home/copiler/openwrt
    /home/copiler/$DIY_P1_SH
    cd /home/copiler/
}
update(){
    cd /home/copiler/openwrt 
    ./scripts/feeds update -a
    cd /home/copiler/
}
update_install(){
    cd /home/copiler/openwrt
    ./scripts/feeds install -a
    cd /home/copiler/
}
p2(){
    [ -e files ] && mv files openwrt/files
    [ -e $CONFIG_FILE ] && mv $CONFIG_FILE openwrt/.config
    chmod +x /home/copiler/$DIY_P2_SH
    cd /home/copiler/openwrt
    /home/copiler/$DIY_P2_SH
    cd /home/copiler/
}
make_download(){
    cd /home/copiler/openwrt
    make defconfig
    make download -j8
    find dl -size -1024c -exec ls -l {} \;
    find dl -size -1024c -exec rm -f {} \;
    cd /home/copiler/
}
make_copiler(){
    cd /home/copiler/openwrt
    echo -e "$(nproc) thread compile"
    make -j$(nproc) || make -j1 || make -j1 V=s
    cd /home/copiler/
}
final(){
    cd /home/copiler/openwrt/bin/targets/*/*
    rm -rf packages
    mv * $uploadssh23
    echo "You files to Upload"
    ls 
}
USS="$(whoami)"
if [ $USS = 'root' ];then
    echo 'root !WARNING!'
    FORCE_UNSAFE_CONFIGURE=1
    clone && p1 && update && update_install && p2 && make_download && make_copiler && final
else
    echo 'Not ROOT'
    clone && p1 && update && update_install && p2 && make_download && make_copiler && final
fi

