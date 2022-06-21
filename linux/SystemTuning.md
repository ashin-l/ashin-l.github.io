# Linux系统调优
## 关闭交换区

如果服务器上有运行数据库服务或消息中间件服务，请关闭交换分区

```
echo "vm.swappiness = 0" >> /etc/sysctl.conf & sysctl -p
```

## Linux操作系统参数
系统全局允许分配的最大文件句柄数

```
# 2 millions system-wide
sysctl -w fs.file-max=2097152
sysctl -w fs.nr_open=2097152
echo 2097152 > /proc/sys/fs/nr_open
```

允许当前会话/进程打开文件句柄数

```
ulimit -n 1048576
```

## /etc/sysctl.conf
持久化 'fs.file-max' 设置到 /etc/sysctl.conf 文件:

```
fs.file-max = 1048576
```

/etc/systemd/system.conf 设置服务最大文件句柄数:

```
DefaultLimitNOFILE=1048576
```

## /etc/security/limits.conf
/etc/security/limits.conf 持久化设置允许用户 / 进程打开文件句柄数:

```
*      soft   nofile      1048576
*      hard   nofile      1048576
```

## TCP 协议栈网络参数
/etc/sysctl.conf是一个允许你改变正在运行中的Linux系统的接口。它包含一些TCP/IP堆栈和虚拟内存系统的高级选项，可用来控制Linux网络配置，建议把TCP参数的修改添加到/etc/sysctl.conf文件, 然后保存文件，使用命令“/sbin/sysctl –p”使之立即生效

并发连接 backlog 设置,客户端的请求在服务端由两个队列进行管理，一种是与客户端完成连接建立后，等待accept的放到一个队列，这个队列的长度由somaxconn参数控制；另一种是正在建立但未完成的连接单独存放一个队列，这个队列的长度由tcp_max_syn_backlog控制

```
sysctl -w net.core.somaxconn=32768
sysctl -w net.ipv4.tcp_max_syn_backlog=16384
sysctl -w net.core.netdev_max_backlog=16384
```

可用知名端口范围:

```
sysctl -w net.ipv4.ip_local_port_range='1000 65535'
```

TCP Socket 读写 Buffer 设置:

```
sysctl -w net.core.rmem_default=262144
sysctl -w net.core.wmem_default=262144
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.wmem_max=16777216
sysctl -w net.core.optmem_max=16777216

#sysctl -w net.ipv4.tcp_mem='16777216 16777216 16777216'
sysctl -w net.ipv4.tcp_rmem='1024 4096 16777216'
sysctl -w net.ipv4.tcp_wmem='1024 4096 16777216'
```

TCP 连接追踪设置:

```
sysctl -w net.netfilter.nf_conntrack_max=1000000
sysctl -w net.netfilter.nf_conntrack_tcp_timeout_time_wait=30
```

TIME-WAIT Socket 最大数量、回收与重用设置:

```
sysctl -w net.ipv4.tcp_max_tw_buckets=1048576

# 注意：不建议开启该设置，NAT 模式下可能引起连接 RST
# sysctl -w net.ipv4.tcp_tw_recycle=1
# sysctl -w net.ipv4.tcp_tw_reuse=1
```

FIN-WAIT-2 Socket 超时设置:

```
sysctl -w net.ipv4.tcp_fin_timeout=15
```
