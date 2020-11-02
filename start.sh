#!/bin/bash
# importando e exportando as configurações
mkdir publics/
export DIR2="$(pwd)"
cp -rf . /home/copiler/
# cp -rf "$P1" /home/copiler/
# cp -rf "$P2" /home/copiler/
# cp -rf "$FEED_FILE" /home/copiler/
chmod 775 /home/copiler/
chown copilador:copilador /home/copiler
export uploadssh23="$DIR2/publics/"
export REPO_URL="$(echo "$URL")"
export REPO_BRANCH="$(echo "$BRANCH")"
export FEEDS_CONF="$(echo "$FEEDS_FILE")"
export CONFIG_FILE="$(echo "$CONFIG")"
export DIY_P1_SH="$(echo "$P1")"
export DIY_P2_SH="$(echo "$P2")"
export FORCE_UNSAFE_CONFIGURE=1
#
echo "*##################################################################*"
echo "# As variaveis pré-definidas pelo Usuario"
echo "# URL do repositorio de copilação: $REPO_URL"
echo "# BRANCH do repositorio: $REPO_BRANCH"
echo "# Configurações do feed: $FEEDS_CONF"
echo "# Arquivo da copilação: $CONFIG_FILE"
echo "# Arquivo de custumização P1: $DIY_P1_SH"
echo "# Arquivo de custumização P2: $DIY_P2_SH"
echo "# a pasta do arquivos pós copilação sera: $uploadssh23"
echo "*##################################################################*"
echo "# O diretorio do usuario é no: $HOMEDIR"
echo "# Seu diretorio da copilação inicial é: $DIR2"
echo "*##################################################################*"
# -------------------------------------
cd /home/copiler/
bash 1.sh
bash 2.sh
bash 3.sh
bash 4.sh
bash 5.sh
bash 6.sh
bash 7.sh
bash 8.sh
bash 9.sh