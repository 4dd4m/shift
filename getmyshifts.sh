#!/bin/bash
DIR=$(ls ~/.mail/[Gmail]/INBOX/cur)
TODAY=$(LC_ALL=en_GB.utf8 date +%a)
if [ $TODAY == Mon ];then
    MONDAY=$(date +%d/%m)
    DAY=$(date +%d)
    MONTH=$(date  +%m)
    FILENAME=shifts$DAY$MONTH
else
    MONDAY=$(date -dlast-monday +%d/%m)
    DAY=$(date -dlast-monday +%d)
    MONTH=$(date -dlast-monday +%m)
    FILENAME=shifts$DAY$MONTH
fi
if [ ! -f ~/bin/$FILENAME ];then
    rm ~/bin/shifts*
    cd ~/.mail/[Gmail]/INBOX/cur
    for file in $DIR; do
            if grep -ql "commencing $MONDAY" $file ; then
                TARGET=$(grep -l "commencing $MONDAY" $file)
            fi
        done
    grep -oh -e "\w\{3\},\s\w\{2\}\s\w\{3\}\s\w*\:\w\{2\}\s\-\s\(\w*\|\w*\:\w\{2\}\)" $TARGET > ~/bin/$FILENAME
fi
while IFS= read -r line;do
    if file -b $line | grep -q $TODAY ;then
        WORKDAY=$(echo $line | awk '{print $4 $5 $6}')
    fi
done < ~/bin/$FILENAME
    if [ ! -n "$WORKDAY"  ];then
        echo 🆓
    else
        echo LDV: $WORKDAY
    fi
