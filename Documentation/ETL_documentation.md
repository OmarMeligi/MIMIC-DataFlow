# ETL Documentation

## 🧪 Extract
- Raw CSVs located in `raw-material/`
- Source: MIMIC-III open access clinical database

## 🧹 Transform (Python script: `transform.py`)
- Remove missing IDs
- Normalize columns (uppercase headers, strip whitespace)
- Convert to Parquet format using Pandas and PyArrow

## 🚀 Load (Shell scripts)
- `hdfs_upload.sh`: pushes Parquet files to HDFS path `/user/omar/mimiciii/parquet/`
- `run_pipeline.sh`: automates both transform and load in one script

## 🧠 Post-Load: Hive Integration
- After loading data into HDFS, Hive external tables are created pointing to the Parquet files.
- These tables are queried to generate insights (e.g., patient visits, mortality rates).
- Sample query files and their results are available in the `results/` directory.
