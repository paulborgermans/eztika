#!/bin/bash

# Apache Tika Start Stop Script
# description: Control Apache Tika Server
# Adapted from https://github.com/galkan/depdep

TIKA_PATH="/srv/dev/git/eztika/bin/tika-server-1.7.jar"
PS_NAME_TIKA="`basename $TIKA_PATH`"
JAVA="/usr/bin/java"

#echo process name $PS_NAME_TIKA
#echo `ps -ef | grep $PS_NAME_TIKA | grep -v grep | wc -l`
if [ ! -f $TIKA_PATH ]
then
        echo "Error: Tika cannot be found on this system !!!"
        exit 1
fi


function is_tika_running()
{
      tika_proc=`ps -ef | grep $PS_NAME_TIKA | grep -v grep | wc -l`

      if [ $tika_proc == 0 ]
      then
	  echo "0"
      else
	  echo "1"
      fi
}


case "$1" in
'start')
	tika_result="`is_tika_running`"
        echo "test if running = " $tika_result

	if [ $tika_result == "1" ]
	then
	    echo "[-] Tika is already running !!!"
	else
	    $JAVA -jar $TIKA_PATH > /dev/null 2>/dev/null &

	    if [ $? -eq 0 ]
	    then
		echo "[+] Tika has been started ..."
	    else
		echo "[-] Tika cannot be started ..."
	    fi

	fi
;;
'stop')
	tika_result="`is_tika_running`"

	if [ $tika_result == 0 ]
	then
	    echo "[-] Tika was already stopped ..."
	else
	    ps -ef | grep "$PS_NAME_TIKA" | grep -v grep | awk '{print $2}' | while read -r line
	    do
                kill -9 $line 2>/dev/null
	    done

	    echo "[+] Tika has been stopped ..."
	fi
	;;
'status')
        ps -ef | grep "$PS_NAME_TIKA" | grep -vq grep

        if [ $? -eq 0 ]
        then
                echo "[+] Tika is: Up"
        else
                echo "[+] Tika is: Down"
        fi
;;
*)
        echo "Usage: $0 { start | stop | status }"
        exit 1
;;
esac
exit 0


