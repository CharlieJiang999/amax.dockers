NET=$1
His=$2
BP=$3

[ -z "$NET" ] && NET=devnet
[ -z "$His" ] && His="na"
[ -z "$BP" ] && BP="na"

cd $NET
set -a
source ./.env

NOD_DIR=/opt/data/amax_$NET
mkdir -p $NOD_DIR $NOD_DIR/data $NOD_DIR/logs

cp -r ../bin $NOD_DIR/
cp -r ./conf $NOD_DIR/
cp ../config.ini $NOD_DIR/conf/

# copy conf node info into config
cat "../conf_node_${NET}.ini" >> $NOD_DIR/conf/config.ini

if  [ "$His" == "his" ]; then
    cat ../conf_plugin_history.ini >> $NOD_DIR/conf/config.ini
fi

if  [ "$BP" == "bp" ]; then
    cat ../conf_plugin_bp.ini >> $NOD_DIR/conf/config.ini
fi

#podman-compose up -d
docker-compose up -d

if   [ "$NET" = "mainnet" ]; then
    sudo iptables -I INPUT -p tcp -m tcp --dport 9806 -j ACCEPT
    sudo iptables -I INPUT -p tcp -m tcp --dport 8888 -j ACCEPT
elif [ "$NET" = "testnet" ]; then
    sudo iptables -I INPUT -p tcp -m tcp --dport 19806 -j ACCEPT
    sudo iptables -I INPUT -p tcp -m tcp --dport 18888 -j ACCEPT
elif [ "$NET" = "devnet" ]; then
    sudo iptables -I INPUT -p tcp -m tcp --dport 29806 -j ACCEPT
    sudo iptables -I INPUT -p tcp -m tcp --dport 28888 -j ACCEPT
fi