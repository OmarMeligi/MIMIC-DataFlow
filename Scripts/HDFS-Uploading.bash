#!/bin/bash

CONTAINER_NAME="namenode"
LOCAL_DIR="/e/Average tables/parq/Scripts"
CONTAINER_TMP="/tmp"
HDFS_BASE_DIR="/mimic"

FILES=(
  "d_icd_diagnoses.parquet"
  "patients.parquet"
  "diagnoses_icd.parquet"
  "admissions.parquet"
  "patients"
)

# 1. Copy files to container
for file in "${FILES[@]}"; do
  docker cp "$LOCAL_DIR/$file" "$CONTAINER_NAME:$CONTAINER_TMP/"
done

echo "All files have been copied to container"

# 2. Put files into HDFS
docker exec -i $CONTAINER_NAME bash -c "
  for file in ${FILES[*]}; do
    FILENAME=\$(basename \"\$file\")
    NAME_NO_EXT=\${FILENAME%.*}
    HDFS_PATH=\"$HDFS_BASE_DIR/\$NAME_NO_EXT\"

    hdfs dfs -mkdir -p \"\$HDFS_PATH\"
    hdfs dfs -put -f \"$CONTAINER_TMP/\$FILENAME\" \"\$HDFS_PATH/\"
  done
"

echo "All files have been copied to $HDFS_BASE_DIR"
