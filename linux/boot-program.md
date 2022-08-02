# Linux系统配置开机启动程序
## 1. 编写启动脚本

推荐启动脚本保存在 `/root`

```
cd /root
vi init.sh
```

```
#! /bin/bash

cd /home/lqc/www
caddy run -config ./Caddyfile
```

## 2. 启动脚本增加执行权限

```
chmod a+x init.sh
```

## 3. 在系统文件中增加配置

使用vi等编辑工具打开文件`vi /etc/rc.d/rc.local`
在文件末尾添加

```
/root/init.sh
```

也可直接将启动命令添加到文件末尾

```
cd /usr/local/kafka_2.13-3.1.1
bin/zookeeper-server-start.sh config/zookeeper.properties &
bin/kafka-server-start.sh config/server.properties &
```