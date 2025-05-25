#!/bin/bash

# Use the real Python 3.13.3 path
PYTHON_EXE="/c/Users/One/AppData/Local/Programs/Python/Python313/python.exe"

echo "Using Python at: $PYTHON_EXE"
echo "Running cleansing script..."

"$PYTHON_EXE" Cleansing.py

if [ $? -eq 0 ]; then
    echo "Cleansing completed successfully. Starting file transfer to HDFS..."
    ./copying.bash
else
    echo "Cleansing script failed. Aborting file transfer."
fi
