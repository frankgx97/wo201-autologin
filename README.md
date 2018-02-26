# wo201-autologin
联通校园宽带的自动认证脚本

## 原理
在[关于破解联通校园宽带限制终端数量的探究](https://blog.nyan.im/posts/1796.html)文中，我使用抓包找出真实的PPPOE用户名和密码并在路由器上拨号的方法实现无限制的联通校园宽带。然而在2017年7月底，联通更新了认证系统，此后上文所述方法不再有效。
我使用了原文中方案B的思路，在路由器上使用curl来自动完成网页认证。

**本脚本适用于OpenWRT，如果你使用Padavan，请切换到padavan分支**

我编写了一个shell脚本，使其在路由器启动时及启动后的每分钟运行。
该脚本每次运行时执行如下操作：
1. 判断网络是否连通。
2. 如果已连通，则向认证服务器发送心跳。
3. 如果未连通，则重启wan接口以获取新的ip地址，然后进行登录。

## 使用
1. 首先，你需要一个安装了curl的openwrt路由器，并且将网线接口配置为wan口（只有一个网口的路由器通常默认配置网口为lan口，需要注意）。

2. 克隆代码到路由器
```
git clone https://github.com/hyriamb/wo201-autologin
或
git clone https://git.guoduhao.cn/gdh/wo201-auth
```
如果路由器不方便使用git，可以打包下载之后用SCP工具传上路由器。

3. 配置用户名，密码及basip
将`config.sample.sh`复制为`config.sh`，填入你的用户名（不含@wo201）、密码和basip。basip可以通过手动登录时自动跳转的网页的URL里面找到。

4. 测试登录
执行`./login.sh`，如果出现`login success`则成功。

5. 添加开机启动和计划任务
编辑`/etc/rc.local/`，在`exit 0`前面加入
```
/path/to/project/login.sh
```

编辑crontab，加入
```
*/1 * * * * /path/to/project/login.sh
```
openwrt的crond默认是关闭的，需要手动启动
```
/etc/init.d/cron start
/etc/init.d/cron enable
```

## 已知可用的学校
- 北京工业大学
- 北方工业大学
