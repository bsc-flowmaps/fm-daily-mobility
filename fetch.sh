FORMAT=parquet

flowmaps-data daily_mobility list | sed 1d |
while read -r line
do
    SOURCE_LAYER=`echo "$line" | python3 -c "import json, sys; d = json.load(sys.stdin); print(d['source_layer'], end='');"`
    TARGET_LAYER=`echo "$line" | python3 -c "import json, sys; d = json.load(sys.stdin); print(d['target_layer'], end='');"`

    DATES=`flowmaps-data daily_mobility list-dates`

    mkdir -p data/$SOURCE_LAYER-$TARGET_LAYER/
    for date in $DATES; do
        echo $date

        FILENAME=data/$SOURCE_LAYER-$TARGET_LAYER/$date.$SOURCE_LAYER-$TARGET_LAYER.daily_mobility.$FORMAT

        if [ -f "$FILENAME" ]; then
            echo "skipping $FILENAME (already exists)"
            continue
        fi

        flowmaps-data daily_mobility download \
                --start-date $date \
                --end-date $date \
                --source-layer $SOURCE_LAYER \
                --target-layer $TARGET_LAYER \
                --output-format $FORMAT \
                --output-file $FILENAME
    done
done
