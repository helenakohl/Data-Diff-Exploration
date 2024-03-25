#!/bin/sh

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <database1> <database2>"
    exit 1
fi

# Assign the arguments to variables
db1="$1"
db2="$2"

# Export schema from first database
sqlite3 "$db1" .schema > "dumps/${db1%.sqlite}_schema.sql"

# Export schema from second database
sqlite3 "$db2" .schema > "dumps/${db2%.sqlite}_schema.sql"

# Dump data from first database
sqlite3 "$db1" .dump > "dumps/${db1%.sqlite}.sql"

# Dump data from first database
sqlite3 "$db2" .dump > "dumps/${db2%.sqlite}.sql"

# Compare SQL files using Git diff
git diff "dumps/${db1%.sqlite}.sql" "dumps/${db2%.sqlite}.sql"

# Compare SQL schemas using Git diff
git diff "dumps/${db1%.sqlite}_schema.sql" "dumps/${db2%.sqlite}_schema.sql"