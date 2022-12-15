#!/bin/bash
##功能:删除过期数据
##作者:tx
##说明:删除过期数据
##手动执行:sh -x delete_history_data.sh
##调度任务:1)使用命令:crontab -e;2)添加内容:分 时 日 月 周 /bin/bash 脚本绝对路径 >> 日志存放路径 2>&1 
##例如:45 10 * * *  /bin/bash /opt/shell/delete_history_data.sh >> /opt/shell/delete_history_data.log 2>&1

#获取系统毫秒时间戳
current=`date "+%Y-%m-%d %H:%M:%S"`
timeStamp=`date -d "$current" +%s`
currentTimeStamp=$((timeStamp*1000+`date "+%N"`/1000000))

#获取pgsql配置文件
db_config_file="/opt/shell/db_config_source.conf"
hostname="$(cat "${db_config_file}" | sed -n 's/hostname\s*=\s*//p')"
username="$(cat "${db_config_file}" | sed -n 's/username\s*=\s*//p')"
password="$(cat "${db_config_file}" | sed -n 's/password\s*=\s*//p')"
port="$(cat "${db_config_file}" | sed -n 's/port\s*=\s*//p')"
db_name="$(cat "${db_config_file}" | sed -n 's/db_name\s*=\s*//p')"

#获取删除策略
map=`PGPASSWORD=${password}  psql -h ${hostname}  -U ${username} -p ${port} -d ${db_name} -c "select concat_ws('#', table_name, data_cycle) from delete_history_data;"`
map=`echo ${map##*-}`
map=`echo ${map%(*}`

for map_info in $map
do
{
table_name=`echo ${map_info}|awk  -F '#' '{print $1}'`
data_cycle=`echo ${map_info}|awk  -F '#' '{print $2}'`

delete_time=$(($currentTimeStamp - 86400000 * $data_cycle))

#执行删除策略
PGPASSWORD=${password}  psql -h ${hostname}  -U ${username} -p ${port} -d ${db_name} -c "delete from ${table_name} where ts <${delete_time};"
} done

#删除访客数据
delete_time=$(($currentTimeStamp - 86400000 * 90))
PGPASSWORD=${password}  psql -h ${hostname}  -U ${username} -p ${port} -d ${db_name} -c "delete from rdr_visitor where create_ts <${delete_time};"