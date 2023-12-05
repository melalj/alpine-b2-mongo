#!/usr/bin/bash
set -e

required_vars="B2_ACCOUNT_ID B2_ACCESS_KEY B2_BUCKET RESTORE_DB_NAME RESTORE_MONGODB_URI RESTORE_AUTH_DB_NAME RESTORE_ARCHIVE_NAME"

for var in $required_vars; do
	if [ -z "$(eval echo \$$var)" ]; then
		echo "Error: Environment variable $var is not set."
		exit 1
	fi
done

echo "Authorizing B2 account"
/usr/bin/b2 authorize-account $B2_ACCOUNT_ID $B2_ACCESS_KEY

echo "Download $RESTORE_ARCHIVE_NAME from B2 bucket..."
/usr/bin/b2 download-file-by-name --noProgress $B2_BUCKET $RESTORE_ARCHIVE_NAME $RESTORE_ARCHIVE_NAME

echo "Restore MongoDB database $RESTORE_DB_NAME from compressed archive..."
/usr/bin/mongorestore $RESTORE_EXTRA_PARAMS \
	--uri "$RESTORE_MONGODB_URI" $RESTORE_EXTRA_FLAGS \
	--authenticationDatabase "$RESTORE_AUTH_DB_NAME" \
	--db "$RESTORE_DB_NAME" \
	--gzip \
	--archive="$RESTORE_ARCHIVE_NAME"

echo "Cleaning up compressed archive..."
rm "$RESTORE_ARCHIVE_NAME"

echo "Restore complete!"
exit 0
