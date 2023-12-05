#!/usr/bin/bash
set -e

required_vars="B2_ACCOUNT_ID B2_ACCESS_KEY B2_BUCKET BACKUP_DB_NAME BACKUP_MONGODB_URI BACKUP_AUTH_DB_NAME BACKUP_ARCHIVE_NAME"

for var in $required_vars; do
	if [ -z "$(eval echo \$$var)" ]; then
		echo "Error: Environment variable $var is not set."
		exit 1
	fi
done

echo "Authorizing B2 account"
/usr/bin/b2 authorize-account $B2_ACCOUNT_ID $B2_ACCESS_KEY

echo "Dumping MongoDB databases $BACKUP_DB_NAME to compressed archive..."
/usr/bin/mongodump $BACKUP_EXTRA_PARAMS \
	--uri "$BACKUP_MONGODB_URI" $BACKUP_EXTRA_FLAGS \
	--authenticationDatabase "$BACKUP_AUTH_DB_NAME" \
	--db "$BACKUP_DB_NAME" \
	--gzip \
	--archive="$BACKUP_ARCHIVE_NAME"

echo "Uploading $BACKUP_ARCHIVE_NAME to B2 bucket..."
/usr/bin/b2 upload-file --noProgress --sha1 $(sha1sum $BACKUP_ARCHIVE_NAME | awk '{print $1}') $B2_BUCKET $BACKUP_ARCHIVE_NAME $BACKUP_ARCHIVE_NAME

echo "Cleaning up compressed archive..."
rm "$BACKUP_ARCHIVE_NAME"

echo "Backup complete!"

if [ -n "$THIN_ARCHIVE_NAME" ]; then
	/bin/bash /thin.sh
fi

exit 0
