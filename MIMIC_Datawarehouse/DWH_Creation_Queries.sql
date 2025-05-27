create database MIMIC_DWH ;
use MIMIC_DWH ;

--dim_patient

CREATE EXTERNAL TABLE DIM_PATIENT (
  SUBJECT_ID BIGINT,
  GENDER STRING,
  DOB STRING,
  MARITAL_STATUS STRING,
  LANGUAGE STRING,
  RELIGION STRING
)
STORED AS AVRO
LOCATION '/MIMIC_DWH/DIM_PATIENT'
TBLPROPERTIES (
  'avro.schema.literal'='{
    "type": "record",
    "name": "DIM_PATIENT",
    "fields": [
      {"name": "SUBJECT_ID", "type": ["null", "long"], "default": null},
      {"name": "GENDER", "type": ["null", "string"], "default": null},
      {"name": "DOB", "type": ["null", "string"], "default": null},
      {"name": "MARITAL_STATUS", "type": ["null", "string"], "default": null},
      {"name": "LANGUAGE", "type": ["null", "string"], "default": null},
      {"name": "RELIGION", "type": ["null", "string"], "default": null}
    ]
  }'
);

--dim_diagnosis

CREATE EXTERNAL TABLE dim_diagnosis
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/MIMIC_DWH/DIM_DIAGNOSIS'
TBLPROPERTIES (
  'avro.schema.literal'='{
    "doc": "Schema for DIM_DIAGNOSIS table",
    "name": "Diagnosis",
    "namespace": "com.example",
    "type": "record",
    "fields": [
      {"name": "DIAG_Sk", "type": "int"},
      {"name": "icd9_code", "type": "string"},
      {"name": "LONG_TITLE", "type": "string"},
      {"name": "SHORT_TITLE", "type": "string"}
    ]
  }'
);

--dim_admission

CREATE EXTERNAL TABLE IF NOT EXISTS DIM_ADMISSION (
    HADM_SK INT,
    SUBJECT_ID INT,
    ADMISSION_TYPE STRING,
    INSURANCE STRING,
    HOSPITAL_EXPIRE_FLAG BOOLEAN,
    language STRING,
    religion STRING,
    marital_status STRING
)
STORED AS AVRO
LOCATION '/MIMIC_DWH/DIM_ADMISSION'
TBLPROPERTIES (
  'avro.schema.literal'='{
    "type": "record",
    "name": "DIM_ADMISSION",
    "fields": [
      {"name": "HADM_SK", "type": ["null", "int"], "default": null},
      {"name": "SUBJECT_ID", "type": ["null", "int"], "default": null},
      {"name": "ADMITTIME", "type": ["null", "string"], "default": null},
      {"name": "DISCHTIME", "type": ["null", "string"], "default": null},
      {"name": "DEATHTIME", "type": ["null", "string"], "default": null},
      {"name": "ADMISSION_TYPE", "type": ["null", "string"], "default": null},
      {"name": "INSURANCE", "type": ["null", "string"], "default": null},
      {"name": "HOSPITAL_EXPIRE_FLAG", "type": ["null", "boolean"], "default": null},
      {"name": "language", "type": ["null", "string"], "default": null},
      {"name": "religion", "type": ["null", "string"], "default": null},
      {"name": "marital_status", "type": ["null", "string"], "default": null}
    ]
  }'
);


--dim_cargiver

CREATE EXTERNAL TABLE IF NOT EXISTS DIM_CAREGIVER (
    CG_ID BIGINT,
    label STRING,
    description STRING
)
STORED AS AVRO
LOCATION '/MIMIC_DWH/DIM_CAREGIVER'
TBLPROPERTIES (
  'avro.schema.literal'='{
    "type": "record",
    "name": "DIM_CAREGIVER",
    "fields": [
      {"name": "CG_ID", "type": ["null", "long"], "default": null},
      {"name": "label", "type": ["null", "string"], "default": null},
      {"name": "description", "type": ["null", "string"], "default": null}
    ]
  }'
);


--dim_date

CREATE EXTERNAL TABLE IF NOT EXISTS DIM_DATE (
    DATE_ID BIGINT,
    DATE_VALUE STRING,
    DAY BIGINT,
    MONTH BIGINT,
    YEAR BIGINT,
    QUARTER BIGINT,
    WEEK BIGINT
)
STORED AS AVRO
LOCATION '/MIMIC_DWH/DIM_DATE'
TBLPROPERTIES (
  'avro.schema.literal'='{
    "type": "record",
    "name": "DIM_DATE",
    "fields": [
      {"name": "DATE_ID", "type": ["null", "long"], "default": null},
      {"name": "DATE_VALUE", "type": ["null", "string"], "default": null},
      {"name": "DAY", "type": ["null", "long"], "default": null},
      {"name": "MONTH", "type": ["null", "long"], "default": null},
      {"name": "YEAR", "type": ["null", "long"], "default": null},
      {"name": "QUARTER", "type": ["null", "long"], "default": null},
      {"name": "WEEK", "type": ["null", "long"], "default": null}
    ]
  }'
);


--FACT_PATIENT_VISITS

CREATE EXTERNAL TABLE FACT_PATIENT_VISITS (
  SUBJECT_ID BIGINT,
  VISIT_SK BIGINT,
  ICUSTAY_ID BIGINT,
  HADM_ID BIGINT,
  DIAGNOSIS_SK BIGINT,
  CG_SK BIGINT,
  Hosp_LOS DOUBLE,
  ICU_LOS DOUBLE,
  Death_Date STRING,
  DIED_FLAG STRING,
  ADMIT_DATE_ID BIGINT,
  DISCHARGE_DATE_ID BIGINT,
  ICU_ADMIT_DATE_ID BIGINT,
  ICU_DISCHARGE_DATE_ID BIGINT
)
STORED AS AVRO
LOCATION '/MIMIC_DWH/FACT_PATIENT_VISITS'
TBLPROPERTIES (
  'avro.schema.literal'='{
    "type": "record",
    "name": "FACT_PATIENT_VISITS",
    "fields": [
      {"name": "SUBJECT_ID", "type": ["null", "long"], "default": null},
      {"name": "VISIT_SK", "type": ["null", "long"], "default": null},
      {"name": "ICUSTAY_ID", "type": ["null", "long"], "default": null},
      {"name": "HADM_ID", "type": ["null", "long"], "default": null},
      {"name": "DIAGNOSIS_SK", "type": ["null", "long"], "default": null},
      {"name": "CG_SK", "type": ["null", "long"], "default": null},
      {"name": "Hosp_LOS", "type": ["null", "double"], "default": null},
      {"name": "ICU_LOS", "type": ["null", "double"], "default": null},
      {"name": "Death_Date", "type": ["null", "string"], "default": null},
      {"name": "DIED_FLAG", "type": ["null", "string"], "default": null},
      {"name": "ADMIT_DATE_ID", "type": ["null", "long"], "default": null},
      {"name": "DISCHARGE_DATE_ID", "type": ["null", "long"], "default": null},
      {"name": "ICU_ADMIT_DATE_ID", "type": ["null", "long"], "default": null},
      {"name": "ICU_DISCHARGE_DATE_ID", "type": ["null", "long"], "default": null}
    ]
  }'
);
