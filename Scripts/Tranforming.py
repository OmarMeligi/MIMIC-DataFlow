import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq

base_path = r"E:\New folder\mimic-iii-clinical-database-demo-1.4"

# --- Process PATIENTS.csv ---
df_patients = pd.read_csv(f"{base_path}\\PATIENTS.csv")

df_patients['subject_id'] = pd.to_numeric(df_patients['subject_id'], errors='coerce').fillna(0).astype('int64')
df_patients['expire_flag'] = pd.to_numeric(df_patients['expire_flag'], errors='coerce').fillna(0).astype('int64')
for col in ['dob', 'dod', 'dod_hosp', 'dod_ssn']:
    df_patients[col] = pd.to_datetime(df_patients[col], errors='coerce')
df_patients['gender'] = df_patients['gender'].astype(str).fillna('')

schema_patients = pa.schema([
    pa.field('subject_id', pa.int64()),
    pa.field('gender', pa.string()),
    pa.field('dob', pa.timestamp('ns')),
    pa.field('dod', pa.timestamp('ns')),
    pa.field('dod_hosp', pa.timestamp('ns')),
    pa.field('dod_ssn', pa.timestamp('ns')),
    pa.field('expire_flag', pa.int64())
])

table_patients = pa.Table.from_pandas(df_patients, schema=schema_patients, preserve_index=False)
pq.write_table(table_patients, 'patients.parquet', use_deprecated_int96_timestamps=True)


# --- Process ADMISSIONS.csv ---
df_admissions = pd.read_csv(f"{base_path}\\ADMISSIONS.csv")
df_admissions.columns = df_admissions.columns.str.strip()

df_admissions['subject_id'] = pd.to_numeric(df_admissions['subject_id'], errors='coerce').fillna(0).astype('int64')
df_admissions['hadm_id'] = pd.to_numeric(df_admissions['hadm_id'], errors='coerce').fillna(0).astype('int64')

for col in ['admittime', 'dischtime', 'deathtime', 'edregtime', 'edouttime']:
    if col in df_admissions.columns:
        df_admissions[col] = pd.to_datetime(df_admissions[col], errors='coerce')

# Stay durations may or may not exist
df_admissions['Stays_Hosp'] = pd.to_numeric(df_admissions['Stays_Hosp'], errors='coerce') if 'Stays_Hosp' in df_admissions.columns else None
df_admissions['Stays_Emerg'] = pd.to_numeric(df_admissions['Stays_Emerg'], errors='coerce') if 'Stays_Emerg' in df_admissions.columns else None

df_admissions['admission_type'] = df_admissions['admission_type'].astype(str).fillna('')
df_admissions['diagnosis'] = df_admissions['diagnosis'].astype(str).fillna('')

schema_admissions = pa.schema([
    pa.field('subject_id', pa.int64()),
    pa.field('hadm_id', pa.int64()),
    pa.field('admittime', pa.timestamp('ns')),
    pa.field('dischtime', pa.timestamp('ns')),
    pa.field('Stays_Hosp', pa.float64()),
    pa.field('deathtime', pa.timestamp('ns')),
    pa.field('admission_type', pa.string()),
    pa.field('edregtime', pa.timestamp('ns')),
    pa.field('edouttime', pa.timestamp('ns')),
    pa.field('Stays_Emerg', pa.float64()),
    pa.field('diagnosis', pa.string())
])

table_admissions = pa.Table.from_pandas(df_admissions, schema=schema_admissions, preserve_index=False)
pq.write_table(table_admissions, 'admissions.parquet', use_deprecated_int96_timestamps=True)


# --- Process D_ICD_DIAGNOSES.csv ---
df_d_icd = pd.read_csv(f"{base_path}\\D_ICD_DIAGNOSES.csv")

df_d_icd['row_id'] = pd.to_numeric(df_d_icd['row_id'], errors='coerce').fillna(0).astype('int64')
df_d_icd['icd9_code'] = df_d_icd['icd9_code'].astype(str).fillna('')
df_d_icd['short_title'] = df_d_icd['short_title'].astype(str).fillna('')

schema_d_icd = pa.schema([
    pa.field('row_id', pa.int64()),
    pa.field('icd9_code', pa.string()),
    pa.field('short_title', pa.string())
])

table_d_icd = pa.Table.from_pandas(df_d_icd, schema=schema_d_icd, preserve_index=False)
pq.write_table(table_d_icd, 'd_icd_diagnoses.parquet', use_deprecated_int96_timestamps=True)


# --- Process DIAGNOSES_ICD.csv ---
df_diagnoses_icd = pd.read_csv(f"{base_path}\\DIAGNOSES_ICD.csv")
df_diagnoses_icd.columns = df_diagnoses_icd.columns.str.strip()

df_diagnoses_icd['row_id'] = pd.to_numeric(df_diagnoses_icd['row_id'], errors='coerce').fillna(0).astype('int64')
df_diagnoses_icd['subject_id'] = pd.to_numeric(df_diagnoses_icd['subject_id'], errors='coerce').fillna(0).astype('int64')
df_diagnoses_icd['hadm_id'] = pd.to_numeric(df_diagnoses_icd['hadm_id'], errors='coerce').fillna(0).astype('int64')
df_diagnoses_icd['seq_num'] = pd.to_numeric(df_diagnoses_icd['seq_num'], errors='coerce').fillna(0).astype('int64')
df_diagnoses_icd['icd9_code'] = df_diagnoses_icd['icd9_code'].astype(str).fillna('')

schema_diagnoses_icd = pa.schema([
    pa.field('row_id', pa.int64()),
    pa.field('subject_id', pa.int64()),
    pa.field('hadm_id', pa.int64()),
    pa.field('seq_num', pa.int64()),
    pa.field('icd9_code', pa.string())
])

table_diagnoses_icd = pa.Table.from_pandas(df_diagnoses_icd, schema=schema_diagnoses_icd, preserve_index=False)
pq.write_table(table_diagnoses_icd, 'diagnoses_icd.parquet', use_deprecated_int96_timestamps=True)


# --- Process ICUSTAYS.csv ---
df_icustays = pd.read_csv(f"{base_path}\\ICUSTAYS.csv")
df_icustays.columns = df_icustays.columns.str.strip()

df_icustays['subject_id'] = pd.to_numeric(df_icustays['subject_id'], errors='coerce').fillna(0).astype('int64')
df_icustays['hadm_id'] = pd.to_numeric(df_icustays['hadm_id'], errors='coerce').fillna(0).astype('int64')
df_icustays['icustay_id'] = pd.to_numeric(df_icustays['icustay_id'], errors='coerce').fillna(0).astype('int64')

df_icustays['intime'] = pd.to_datetime(df_icustays['intime'], errors='coerce')
df_icustays['outtime'] = pd.to_datetime(df_icustays['outtime'], errors='coerce')

df_icustays['los'] = pd.to_numeric(df_icustays['los'], errors='coerce')

schema_icustays = pa.schema([
    pa.field('subject_id', pa.int64()),
    pa.field('hadm_id', pa.int64()),
    pa.field('icustay_id', pa.int64()),
    pa.field('intime', pa.timestamp('ns')),
    pa.field('outtime', pa.timestamp('ns')),
    pa.field('los', pa.float64())
])

table_icustays = pa.Table.from_pandas(df_icustays, schema=schema_icustays, preserve_index=False)
pq.write_table(table_icustays, 'icustays.parquet', use_deprecated_int96_timestamps=True)

