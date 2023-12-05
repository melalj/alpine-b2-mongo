# alpine-b2-mongo

Alpine docker image with b2 and mongodb-tools with two scripts:

- `./backup.sh`: Backup a mongo database
- `./restore.sh`: Restore a mongo database
- `./thin.sh`: Thin backblaze backup (rotate to keep hourly, daily, weekly, monthly)

## Environement variables

```sh
# B2
B2_ACCOUNT_ID=xxx
B2_ACCESS_KEY=xxx
B2_BUCKET=xxx

# BACKUP
BACKUP_ARCHIVE_NAME=xxx.gz
BACKUP_MONGODB_URI=mongodb://xxx:xxx@xxx:27017
BACKUP_AUTH_DB_NAME=admin
BACKUP_DB_NAME=xxx
BACKUP_EXTRA_PARAMS=
BACKUP_EXTRA_FLAGS=--excludeCollection=xxx

# RESTORE
RESTORE_ARCHIVE_NAME=xxx.gz
RESTORE_MONGODB_URI=mongodb://xxx:xxx@xxx:27017
RESTORE_AUTH_DB_NAME=admin
RESTORE_DB_NAME=xxx
RESTORE_EXTRA_PARAMS=
RESTORE_EXTRA_FLAGS=--drop


# THIN
THIN_ARCHIVE_NAME=xxx.gz
KEEP_HOURLY_FOR_IN_HOURS=24
KEEP_DAILY_FOR_IN_DAYS=30
KEEP_WEEKLY_FOR_IN_WEEKS=52
KEEP_MONTHLY_FOR_IN_MONTHS=60
```

## Getting started

```sh
# Edit your .env

# Backup
docker run -it --rm --env-file .env $(docker build -q .) bash /backup.sh

# Restore
docker run -it --rm --env-file .env $(docker build -q .) bash /restore.sh

# Thin
docker run -it --rm --env-file .env $(docker build -q .) bash /thin.sh
```
