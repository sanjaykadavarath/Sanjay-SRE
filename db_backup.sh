#!/bin/bash
# This script can be used to run and create backups of s3 buckets
# Set variables
date=$(date +"%d-%m-%Y")
fdate=$(date +%Y%m%d-%H%M)
DIR=/mnt/backups/crlqs
RETENTION="+30"
S3_BUCKET="demppsqlbackups"
SERVERNAME="dbserverdemo"
AWS_PROFILE="default"

# Set AWS CLI profile
export AWS_PROFILE=$AWS_PROFILE

echo "=============================`date`====================================="

# List of databases to backup
databases=("demodb1" "demodb2" "demodb3")

# Loop through each database
for db_name in "${databases[@]}"
do
    PGPASSWORD="password" pg_dump -U postgres "$db_name" -h localhost > "$DIR/$db_name-$fdate.sql"
done

echo "======================================================================="

# Upload backups to S3 with timestamp
for db_name in "${databases[@]}"
do
    aws s3 cp "$DIR/$db_name-$fdate.sql" "s3://$S3_BUCKET/$SERVERNAME/$date/$db_name-$fdate.sql"
done

echo "======================================================================="

echo "Removing Temporary Backups"

rm -rf /mnt/backups/crlqs/*

# Remove old backups from the S3 bucket
echo "==============================Removing Older Backup from Bucket================================"
OLD_BACKUPS=$(aws s3 ls s3://$S3_BUCKET/ | grep " PRE " | awk '{print $2}' | sort -r | tail -n +$((RETENTION+1)))
for BACKUP in $OLD_BACKUPS; do
    aws s3 rm --recursive s3://$S3_BUCKET/$BACKUP
done
