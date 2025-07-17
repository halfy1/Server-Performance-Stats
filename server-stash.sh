#!/bin/bash

if [-z "$BASH_VERSION"]; then 
    echo "Пожалуйста, запустите скрпит с помощью bash"
    exit 1
fi

echo "Server Perfomance Stats"
echo 

echo "CPU USAGE"

CPU_LINE=$(top -bn1 | grep "^%Cpu" || top -bn1 | grep "Cpu(s)")
#CPU_LINE=$(echo "$CPU_LINE" | awk -F',' '{for(i=1; i<=NF;i++) if ($1 ~ /id/) print $1}' | grep -o '[0-9]*')

IDLE_FIELD=$(echo "CPU_LINE" | awk -F', ' '
    {
        for(i=1; i<NF; i++) {
            if ($1 ~ /id/){
                print $1
                break
            }
        }
    }')

CPU_IDLE=$(echo "$IDLE_FIELD" | grep -o '[0-9]*')
CPU_USED=$(awk "BEGIN {print 100 - $CPU_IDLE}")

echo "TOTAL CPU Usage: $CPU_USED%"