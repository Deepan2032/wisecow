#!/bin/bash

# Variables
SOURCE_DIR=""      # Directory for back up
REMOTE_USER=""           # Remote server username
REMOTE_SERVER=""  # Remote server address
REMOTE_DIR=""  # Remote server directory

# For backup to cloud storage (AWS S3)
USE_S3=false                      # Set to true if using S3
S3_BUCKET="s3://your-bucket-name"  # S3 bucket name

# Log file for backup status
LOG_FILE="/var/log/backup.log"

log_message() {
  local message=$1
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" | tee -a $LOG_FILE
}

backup_to_remote() {
  log_message "Starting backup of $SOURCE_DIR to $REMOTE_USER@$REMOTE_SERVER:$REMOTE_DIR"
  rsync -avz $SOURCE_DIR $REMOTE_USER@$REMOTE_SERVER:$REMOTE_DIR
  if [ $? -eq 0 ]; then
    log_message "Backup to remote server succeeded."
  else
    log_message "Backup to remote server failed."
  fi
}

backup_to_s3() {
  log_message "Starting backup of $SOURCE_DIR to S3 bucket $S3_BUCKET"
  aws s3 sync $SOURCE_DIR $S3_BUCKET
  if [ $? -eq 0 ]; then
    log_message "Backup to S3 succeeded."
  else
    log_message "Backup to S3 failed."
  fi
}

main() {
  if [ "$USE_S3" = true ]; then
    backup_to_s3
  else
    backup_to_remote
  fi
}

main
