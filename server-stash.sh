#!/bin/bash

if [ -z "$BASH_VERSION" ]; then 
    echo "Пожалуйста, запустите скрипт с помощью bash"
    exit 1
fi

echo "Server Performance Stats"
echo 

### === CPU USAGE ===
echo "CPU Usage:"

CPU_LINE=$(top -bn1 | grep "^%Cpu" || top -bn1 | grep "Cpu(s)")
IDLE_FIELD=$(echo "$CPU_LINE" | awk -F', ' '
    {
        for (i = 1; i <= NF; i++) {
            if ($i ~ /id/) {
                print $i
                break
            }
        }
    }')

CPU_IDLE=$(echo "$IDLE_FIELD" | grep -o '[0-9]*')
CPU_USED=$(awk "BEGIN {print 100 - $CPU_IDLE}")

echo "Total CPU Usage: $CPU_USED%"

### === MEMORY USAGE ===
echo
echo "Memory Usage:"

MEM_TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
MEM_TOTAL_MB=$((MEM_TOTAL / 1024))
MEM_FREE=$(grep MemFree /proc/meminfo | awk '{print $2}')
MEM_FREE_MB=$((MEM_FREE / 1024))
MEM_AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
MEM_AVAILABLE_MB=$((MEM_AVAILABLE / 1024))
MEM_USED_MB=$((MEM_TOTAL_MB - MEM_AVAILABLE_MB))

MEM_USED_PERCENT=$(awk "BEGIN {printf \"%.1f\", ($MEM_USED_MB/$MEM_TOTAL_MB)*100}")

echo "Total Memory: ${MEM_TOTAL_MB} MB"
echo "Used Memory:  ${MEM_USED_MB} MB"
echo "Free Memory:  ${MEM_FREE_MB} MB"
echo "Available:    ${MEM_AVAILABLE_MB} MB"
echo "Memory Usage: ${MEM_USED_PERCENT}%"



### === DISK USAGE ===
echo
echo "Disk Usage:"

DISK_LINE=$(df -h / | awk 'NR==2')

DISK_TOTAL=$(echo "$DISK_LINE" | awk '{print $2}')
DISK_USED=$(echo "$DISK_LINE" | awk '{print $3}')
DISK_AVAIL=$(echo "$DISK_LINE" | awk '{print $4}')
DISK_USE_PERCENT=$(echo "$DISK_LINE" | awk '{print $5}')

echo "Mount point: /"
echo "Total Disk:   $DISK_TOTAL"
echo "Used Disk:    $DISK_USED"
echo "Available:    $DISK_AVAIL"
echo "Disk Usage:   $DISK_USE_PERCENT"

### === TOP PROCESSES ===
echo
echo "Top 5 Processes by CPU Usage:"
ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6

echo
echo "Top 5 Processes by Memory Usage:"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6

echo
