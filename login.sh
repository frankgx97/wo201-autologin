#!/bin/sh
source $(dirname $0)/config.sh;

function connect(){
    echo "USERNAME:"$username;
    ifdown wan;
    ifup wan;
    . /lib/functions/network.sh;
    network_get_ipaddr ip wan; 
    echo "IP:"$ip;
    curl -A "Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.20 Mobile Safari/537.36" \
    -H "Pragma:no-cache" -H "Cache-Control:no-cache" -H "Referer:http://114.247.41.52:808/protalAction!index.action?wlanuserip=$ip&basip=$basip" \
    -H "Accept-Encoding:gzip,deflate" -H "Accept-Language:en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4" \
    -H "Accept: application/json, text/javascript, */*" -b "JSESSIONID=D4CB5C7CEC0B78473E4C2439AE4A8CCD" \
    -d "wlanuserip=$ip&localIp=&basip=$basip&lpsUserName=$username&lpsPwd=$password" \
    -v "http://114.247.41.52:808/protalAction!portalAuth.action?";
}

function chknetwork(){
    timeout=5    
    target=www.baidu.com    
    ret_code=`curl -I -s --connect-timeout $timeout $target -w %{http_code} | tail -n1`    
    if [ "x$ret_code" = "x200" ];
    then
        return 1;
    else
        return 0;
    fi    
}

function heartbeat(){
    echo "sending heartbeat."
    curl -A "Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.20 Mobile Safari/537.36" \
    -H "Pragma:no-cache" -H "Cache-Control:no-cache" -H "Referer:http://114.247.41.52:808/protalAction!toSuccess.action" \
    -H "Accept-Encoding:gzip,deflate" -H "Accept-Language:en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4" \
    -H "Accept: application/json, text/javascript, */*" -b "JSESSIONID=D4CB5C7CEC0B78473E4C2439AE4A8CCD" \
    -v "http://114.247.41.52:808/";
    curl -v "http://www.baidu.com/"
}

network_status=chknetwork;
if [$network_status == 1]
then
    heartbeat;
else
    connect;
fi
