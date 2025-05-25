# Project Overview: MIMIC-III Big Data Pipeline

## 🎯 Objective
Build a Big Data pipeline to cleanse, transform, and analyze the MIMIC-III medical dataset using Apache Hadoop, Hive, and Python.

## 🧰 Tools & Technologies
- Apache Hadoop (HDFS)
- Apache Hive
- Docker
- Python
- Parquet
- Bash/Shell
- SSIS (ETL Design, optional)

## 📂 Pipeline Flow
1. Ingest raw CSVs from the MIMIC-III dataset
2. Clean and convert them into Parquet using Python
3. Upload Parquet files to HDFS
4. Create Hive external tables pointing to HDFS data
5. Run queries to analyze patient visits, diagnoses, and mortality rates

## 📈 Outcomes
- Structured star schema model in Hive
- Optimized storage with Parquet
- Efficient querying via Hive
