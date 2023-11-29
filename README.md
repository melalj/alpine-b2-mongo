# alpine-b2-mongo

Alpine docker image with b2 and mongodb-tools with two scripts:

- `./backup.sh`: Backup a mongo database
- `./restore.sh`: Restore a mongo database

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
```

## Getting started

```sh
# Edit your .env

# Backup
docker run -it --rm --env-file .env $(docker build -q .) sh /backup.sh

# Restore
docker run -it --rm --env-file .env $(docker build -q .) sh /restore.sh
```
