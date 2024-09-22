#!/bin/bash

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

LOG_FILE="/var/log/system_health.log"

log_alert() {
  local message=$1
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a $LOG_FILE
}

check_cpu() {
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
  if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) ))
  then
    log_alert "WARNING: CPU usage is at ${cpu_usage}% (Threshold: ${CPU_THRESHOLD}%)"
  fi
}

check_memory() {
  memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    log_alert "WARNING: Memory usage is at ${memory_usage}% (Threshold: ${MEMORY_THRESHOLD}%)"
}

check_disk() {
  disk_usage=$(df -h / | grep / | awk '{print $5}' | sed 's/%//g')
    log_alert "WARNING: Disk usage is at ${disk_usage}% (Threshold: ${DISK_THRESHOLD}%)"
}

check_processes() {
  running_processes=$(ps -ef | wc -l)
  log_alert "INFO: There are currently ${running_processes} processes running."
}

main() {
  check_cpu
  check_memory
  check_disk
  check_processes
}

main
