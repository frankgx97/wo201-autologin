#!/bin/sh
source $(dirname $0)/config.sh;

connect()
{
    echo "USERNAME:"$username;
    restart_wan
    ip=`ifconfig eth2.2 | awk -F'[ :]+' '$0 ~ "inet addr"{print $4}'`
    echo "IP:"$ip;
    curl -A "Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.20 Mobile Safari/537.36" \
    -H "Pragma:no-cache" -H "Cache-Control:no-cache" -H "Referer:http://114.247.41.52:808/protalAction!index.action?wlanuserip=$ip&basip=$basip" \
    -H "Accept-Encoding:gzip,deflate" -H "Accept-Language:en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4" \
    -H "Accept: application/json, text/javascript, */*" -b "JSESSIONID=D4CB5C7CEC0B78473E4C2439AE4A8CCD" \
    -d "wlanuserip=$ip&localIp=&basip=$basip&lpsUserName=$username&lpsPwd=$password" \
    -v "http://114.247.41.52:808/protalAction!portalAuth.action?";
}

chknetwork()
{
    timeout=5    
    target=www.baidu.com    
    ret_code=`curl -I -s --connect-timeout $timeout $target -w %{http_code} | tail -n1`    
    if [ "x$ret_code" = "x200" ];
    then
        echo 1;
    else
        echo 0;
    fi    
}

heartbeat()
{
    curl -A "Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.20 Mobile Safari/537.36" \
    -H "Pragma:no-cache" -H "Cache-Control:no-cache" -H "Referer:http://114.247.41.52:808/protalAction!toSuccess.action" \
    -H "Accept-Encoding:gzip,deflate" -H "Accept-Language:en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4" \
    -H "Accept: application/json, text/javascript, */*" -b "JSESSIONID=D4CB5C7CEC0B78473E4C2439AE4A8CCD" \
    -v "http://114.247.41.52:808/";
    curl -v "http://www.baidu.com/" > /dev/null;
}

if [ $(chknetwork) == 1 ]
then
    echo "network up, sending heartbeat."
    heartbeat;
else
    echo "network down, connecting."
    connect;
fi