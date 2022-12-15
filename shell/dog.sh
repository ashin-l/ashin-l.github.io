#!/bin/bash

export LD_LIBRARY_PATH=/usr/local/pgsql/lib:/usr/local/lib
flag=0
pgdb=thdb
pguser=th
pgpasswd=11
pgport=5432


while true
do
	time=`date "+%Y-%m-%d %H:%M:%S"`
	res=`ps aux | grep video_cuda_enc  | grep -v grep |wc -l `
        if [ "$res" = "0" ]; then
		cd /usr/src/jetson_multimedia_api/samples/zh_bf_v5_new_bs06_fw &&  echo 'nvidia' |  sudo -S  ./video_cuda_enc   &
	fi
        sleep 0.1

	res=`ps aux | grep intrusion_detection  | grep -v grep |wc -l `
        if [ "$res" = "0" ]; then
		echo 'nvidia' |sudo -S docker start intrusion_detection &
		if [ "$flag" = "1" ]; then
			PGPASSWORD=$pgpasswd psql -h 127.0.0.1 -p $pgport -U $pguser $pgdb -c "insert into sys_exception_log (msg, create_time) VALUES('docker intrusion_detection进程重启','$time');"
		fi
	fi
        sleep 0.1
	
	res=`ps aux | grep person_recognition_coco  | grep -v grep |wc -l `
        if [ "$res" = "0" ]; then
		echo 'nvidia' |sudo -S docker start person_car_recognition_1 &
                if [ "$flag" = "1" ]; then
			PGPASSWORD=$pgpasswd psql -h 127.0.0.1 -p $pgport -U $pguser $pgdb -c "insert into sys_exception_log (msg, create_time) VALUES('docker person_car_recognition_1 进程重启','$time');"
		fi	
	
	fi
        sleep 0.1

	res=`ps aux | grep wvp-pro-2.0-11190958  | grep -v grep |wc -l `
        if [ "$res" = "0" ]; then
		cd /home/nvidia/edge-app/wvp && java -jar wvp-pro-2.0-11190958.jar &
		if [ "$flag" = "1" ]; then
			 PGPASSWORD=$pgpasswd psql -h 127.0.0.1 -p $pgport -U $pguser $pgdb -c "insert into sys_exception_log (msg, create_time) VALUES('wvp-pro-2.0-11190958.jar 进程重启','$time');"
		fi
	fi
        sleep 0.1

	res=`ps aux | grep MediaServer  | grep -v grep |wc -l `
        if [ "$res" = "0" ]; then
		cd /home/nvidia/edge-app/zlm && ./MediaServer &
		if [ "$flag" = "1" ]; then
			PGPASSWORD=$pgpasswd psql -h 127.0.0.1 -p $pgport -U $pguser $pgdb -c "insert into sys_exception_log (msg, create_time) VALUES('MediaServer 进程重启','$time');"
		fi
	fi
        sleep 0.1

	res=`ps aux | grep speed-admin  | grep -v grep |wc -l `
        if [ "$res" = "0" ]; then
		cd /home/nvidia/edge-app/java && java -jar speed-admin.jar &
		if [ "$flag" = "1" ]; then
			PGPASSWORD=$pgpasswd psql -h 127.0.0.1 -p $pgport -U $pguser $pgdb -c "insert into sys_exception_log (msg, create_time) VALUES('speed-admin.jar 进程重启','$time');"
		fi	
	fi
        sleep 0.1

        res=`ps aux | grep  node-monitor.sh  | grep -v grep |wc -l `
	if [ "$res" = "0" ]; then
	      cd /home/nvidia/workspace &&  ./node-monitor.sh  &
	      if [ "$flag" = "1" ]; then
		      PGPASSWORD=$pgpasswd psql -h 127.0.0.1 -p $pgport -U $pguser $pgdb -c "insert into sys_exception_log (msg, create_time) VALUES('node-monitor.sh进程重启','$time');"
	      fi
     	fi
	sleep 0.1

	res=`ps aux | grep Aserver  | grep -v grep |wc -l `
        if [ "$res" = "0" ]; then
		cd /home/server/ && ./Aserver &
		if [ "$flag" = "1" ]; then
			PGPASSWORD=$pgpasswd psql -h 127.0.0.1 -p $pgport -U $pguser $pgdb -c "insert into sys_exception_log (msg, create_time) VALUE('Aserver 进程重启','$time');"
		fi
	fi
	sleep 0.1

	 if [ "$flag" = "0" ]; then
		sleep 10
		 flag=1

	fi 

done

