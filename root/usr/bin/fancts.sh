#!/bin/sh
#by manper 20250117
lockfile="/var/run/cooling_control.pid"

if [ -e "$lockfile" ]; then
    pid=$(cat "$lockfile")
    if kill -0 $pid > /dev/null 2>&1; then
        echo "Script is already running with PID $pid."
        exit 1
    else
        echo "Lock file found but no process running with PID $pid. Removing lock file."
        rm "$lockfile"
    fi
fi

echo $$ > "$lockfile"

trap "rm -f '$lockfile'; exit" INT TERM EXIT


fanvall=$(cat /etc/fanvall)
    
if [ "$fanvall" = 3 ]; then
    echo 3 > /sys/class/thermal/cooling_device0/cur_state
    exit 1
elif [ "$fanvall" = 2 ]; then
    echo 2 > /sys/class/thermal/cooling_device0/cur_state
    exit 1
elif [ "$fanvall" = 1 ]; then
    echo 1 > /sys/class/thermal/cooling_device0/cur_state
    exit 1
elif [ "$fanvall" = 0 ]; then
    echo 0 > /sys/class/thermal/cooling_device0/cur_state
    exit 1
fi

while true; do
    fanvall_conf=$(cat /etc/fanvallv.conf)
    if [ "$fanvall_conf" = "模组温度" ]; then
        temp=$(sendat 1 'AT^CHIPTEMP?' | grep 'CHIPTEMP' | sed -n '1p' | cut -d, -f9 | sed '/^$/d')
        if [ -n "$temp" ]; then
            temp=$((temp * 100))
        else
            temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        fi
    else
        temp=$(cat /sys/class/thermal/thermal_zone0/temp)
    fi

    if [ "$temp" -gt 60000 ]; then
        echo 0 > /sys/class/thermal/cooling_device0/cur_state
    elif [ "$temp" -gt 45000 ] && [ "$temp" -le 60000 ]; then
        echo 1 > /sys/class/thermal/cooling_device0/cur_state
    elif [ "$temp" -gt 35000 ] && [ "$temp" -le 45000 ]; then
        echo 2 > /sys/class/thermal/cooling_device0/cur_state
    elif [ "$temp" -gt 0 ] && [ "$temp" -le 35000 ]; then
        echo 3 > /sys/class/thermal/cooling_device0/cur_state
    fi
    sleep 15
done


