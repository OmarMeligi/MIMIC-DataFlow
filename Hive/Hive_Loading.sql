CREATE database mimic ;
USE mimic;

CREATE EXTERNAL TABLE IF NOT EXISTS admissions (
  subject_id       BIGINT,
  hadm_id          BIGINT,
  admittime        TIMESTAMP,
  dischtime        TIMESTAMP,
  stays_hosp       DOUBLE,
  deathtime        TIMESTAMP,
  admission_type   STRING,
  edregtime        TIMESTAMP,
  edouttime        TIMESTAMP,
  stays_emerg      DOUBLE,
  diagnosis        STRING
)
STORED AS PARQUET
LOCATION '/mimic/admissions';


CREATE EXTERNAL TABLE IF NOT EXISTS d_icd_diagnoses (
  row_id       BIGINT,
  icd9_code    STRING,
  short_title  STRING
)
STORED AS PARQUET
LOCATION '/mimic/d_icd_diagnoses';



CREATE EXTERNAL TABLE IF NOT EXISTS diagnoses_icd (
  row_id     BIGINT,
  subject_id BIGINT,
  hadm_id    BIGINT,
  seq_num    INT,
  icd9_code  STRING
)
STORED AS PARQUET
LOCATION '/mimic/diagnoses_icd';



CREATE EXTERNAL TABLE IF NOT EXISTS icustays (
  subject_id BIGINT,
  hadm_id BIGINT,
  icustay_id BIGINT,
  intime TIMESTAMP,
  outtime TIMESTAMP,
  los DOUBLE
)
STORED AS PARQUET
LOCATION '/mimic/icustays';
