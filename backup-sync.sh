#!/bin/bash
# Backup to google drive
options="--ignore-existing --progress --transfers 4 --checkers 8 --contimeout 60s --timeout 300s --retries 3 --low-level-retries 10 --stats 10s --verbose --log-file backup.log"
source="/home/tim/Documents"
target="gdrive:sync"
filefrom="--include-from backup-dirs.txt"
echo "Starting backup to Google drive"
echo
rclone sync $options $filefrom $source $target
