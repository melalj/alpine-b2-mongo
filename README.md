# alpine-b2-mongo

Alpine docker image with b2 and mongodb-tools with two scripts:

- `./backup.sh`: Backup a mongo database
- `./restore.sh`: Restore a mongo database

```sh
# Edit your .env

# Backup
docker run -it --rm --env-file .env $(docker build -q .) sh /backup.sh

# Restore
docker run -it --rm --env-file .env $(docker build -q .) sh /restore.sh
```
