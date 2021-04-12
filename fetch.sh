flowmaps-data daily_mobility list | sed 1d |
while read -r line
do
    SOURCE_LAYER=`echo "$line" | python3 -c "import json, sys; d = json.load(sys.stdin); print(d['source_layer'], end='');"`
    TARGET_LAYER=`echo "$line" | python3 -c "import json, sys; d = json.load(sys.stdin); print(d['target_layer'], end='');"`

    DATES=`flowmaps-data daily_mobility list-dates`
    FILENAME=data/$SOURCE_LAYER-$TARGET_LAYER/$date.daily_mobility.parquet

    mkdir -p data/$SOURCE_LAYER-$TARGET_LAYER/

	if [ -f "$FILENAME" ]; then
		echo "skipping $FILENAME (already exists)"
		continue
	fi

    for date in $DATES; do
    	echo $date
	    flowmaps-data daily_mobility download \
	    	--start-date $date \
	    	--end-date $date \
	    	--source-layer $SOURCE_LAYER \
	    	--target-layer $TARGET_LAYER \
	    	--output-format parquet \
	    	--output-file $FILENAME
    done
done
