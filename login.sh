source $(dirname $0)/config.sh;
echo "USERNAME:"$username;
. /lib/functions/network.sh;
network_get_ipaddr ip wan; 
echo "IP:"$ip;
curl -A "Mozilla/5.0 (Linux; Android 5.1.1; Nexus 6 Build/LYZ28E) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.20 Mobile Safari/537.36" \
-H "Pragma:no-cache" -H "Cache-Control:no-cache" -H "Referer:http://114.247.41.52:808/protalAction!index.action?wlanuserip=$ip&basip=61.148.2.182" \
-H "Accept-Encoding:gzip,deflate" -H "Accept-Language:en-US,en;q=0.8,zh-CN;q=0.6,zh;q=0.4" \
-d "wlanuserip="$ip"&localIp=&basip=61.148.2.182&lpsUserName=$username&lpsPwd=$password" \
-H "Accept: application/json, text/javascript, */*" -b "JSESSIONID=D4CB5C7CEC0B78473E4C2439AE4A8CCD" \
-v "http://114.247.41.52:808/protalAction!portalAuth.action?";