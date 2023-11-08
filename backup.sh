#!/bin/bash

set -e

# DB_NAME=XXX
# B2_ACCOUNT_ID=XXX
# B2_ACCESS_KEY=XXX
# B2_BUCKET=XXX
# MONGODB_URI=mongodb://XXX:XXX@XXX:27017
# AUTH_DB_NAME=admin
# ARCHIVE_NAME=${DB_NAME}.gz
# EXTRAFLAGS=

echo "Authorizing B2 account"
/usr/local/bin/b2 authorize-account ${B2_ACCOUNT_ID} ${B2_ACCESS_KEY}


echo "Dumping MongoDB databases ${DB_NAME} to compressed archive..."
/usr/bin/mongodump ${BACKUP_EXTRA_PARAMS} \
	--authenticationDatabase "$AUTH_DB_NAME" \
	--db "$DB_NAME" \
	--archive="$ARCHIVE_NAME" \
	--gzip \
	--uri "$MONGODB_URI" $EXTRAFLAGS

echo "Uploading ${ARCHIVE_NAME} to S3 bucket..."
/usr/local/bin/b2 upload-file --noProgress --sha1 $(sha1sum $ARCHIVE_NAME | awk '{print $1}') ${B2_BUCKET} $ARCHIVE_NAME $ARCHIVE_NAME

echo "Cleaning up compressed archive..."
rm "$ARCHIVE_NAME"

echo "[$SCRIPT_NAME] Backup complete!"
exit 0
