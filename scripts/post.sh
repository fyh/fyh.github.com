#!/bin/env sh
if [ ! -d "./_drafts" ]; then
	echo "_drafts/ not exist."
	exit 1
fi

if [ "$#" -ne 1 ]; then
	echo "empty filename."
	exit 1
fi

DATE=`date +%Y-%m-%d`
DATETIME=`date '+%Y-%m-%d %H:%M:%S'`
FNAME="./_drafts/$DATE-$1.md"
touch $FNAME

echo "---\nlayout: post\ndate: $DATETIME +0800\ntitle: $1\nnocomments: false\n---\n\n" >> $FNAME
