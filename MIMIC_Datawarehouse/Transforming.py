import pandas as pd
from fastavro import writer, parse_schema
import os

input_folder = r"E:\Average tables\DWH"
output_folder = r"E:\Average tables\DWH\Avro"
os.makedirs(output_folder, exist_ok=True)

schemas = {
    "DIM_ADMISSION": {
        "name": "DIM_ADMISSION",
        "type": "record",
        "fields": [
            {"name": "HADM_SK", "type": ["null", "long"], "default": None},
            {"name": "SUBJECT_ID", "type": ["null", "long"], "default": None},
            {"name": "ADMITTIME", "type": ["null", "string"], "default": None},
            {"name": "DISCHTIME", "type": ["null", "string"], "default": None},
            {"name": "DEATHTIME", "type": ["null", "string"], "default": None},
            {"name": "ADMISSION_TYPE", "type": ["null", "string"], "default": None},
            {"name": "INSURANCE", "type": ["null", "string"], "default": None},
            {"name": "HOSPITAL_EXPIRE_FLAG", "type": ["null", "string"], "default": None},
            {"name": "language", "type": ["null", "string"], "default": None},
            {"name": "religion", "type": ["null", "string"], "default": None},
            {"name": "marital_status", "type": ["null", "string"], "default": None},
        ],
    },
    "DIM_CAREGIVER": {
        "name": "DIM_CAREGIVER",
        "type": "record",
        "fields": [
            {"name": "CG_ID", "type": ["null", "long"], "default": None},
            {"name": "label", "type": ["null", "string"], "default": None},
            {"name": "description", "type": ["null", "string"], "default": None},
        ],
    },
    "DIM_DATE": {
        "name": "DIM_DATE",
        "type": "record",
        "fields": [
            {"name": "DATE_ID", "type": ["null", "long"], "default": None},
            {"name": "DATE_VALUE", "type": ["null", "string"], "default": None},
            {"name": "DAY", "type": ["null", "long"], "default": None},
            {"name": "MONTH", "type": ["null", "long"], "default": None},
            {"name": "YEAR", "type": ["null", "long"], "default": None},
            {"name": "QUARTER", "type": ["null", "long"], "default": None},
            {"name": "WEEK", "type": ["null", "long"], "default": None},
        ],
    },
    "DIM_DIAGNOSIS": {
        "name": "DIM_DIAGNOSIS",
        "type": "record",
        "fields": [
            {"name": "DIAG_Sk", "type": ["null", "long"], "default": None},
            {"name": "icd9_code", "type": ["null", "string"], "default": None},
            {"name": "subject_id", "type": ["null", "string"], "default": None},
            {"name": "hadm_id", "type": ["null", "string"], "default": None},
            {"name": "LONG_TITLE", "type": ["null", "string"], "default": None},
            {"name": "SHORT_TITLE", "type": ["null", "string"], "default": None},
            {"name": "seq_num", "type": ["null", "long"], "default": None},
        ],
    },
    "DIM_PATIENT": {
        "name": "DIM_PATIENT",
        "type": "record",
        "fields": [
            {"name": "SUBJECT_ID", "type": ["null", "long"], "default": None},
            {"name": "GENDER", "type": ["null", "string"], "default": None},
            {"name": "DOB", "type": ["null", "string"], "default": None},
            {"name": "MARITAL_STATUS", "type": ["null", "string"], "default": None},
            {"name": "LANGUAGE", "type": ["null", "string"], "default": None},
            {"name": "RELIGION", "type": ["null", "string"], "default": None},
        ],
    },
    "FACT_PATIENT_VISITS": {
        "name": "FACT_PATIENT_VISITS",
        "type": "record",
        "fields": [
            {"name": "SUBJECT_ID", "type": ["null", "long"], "default": None},
            {"name": "VISIT_SK", "type": ["null", "long"], "default": None},
            {"name": "ICUSTAY_ID", "type": ["null", "long"], "default": None},
            {"name": "HADM_ID", "type": ["null", "long"], "default": None},
            {"name": "DIAGNOSIS_SK", "type": ["null", "long"], "default": None},
            {"name": "CG_SK", "type": ["null", "long"], "default": None},
            {"name": "Hosp_LOS", "type": ["null", "double"], "default": None},
            {"name": "ICU_LOS", "type": ["null", "double"], "default": None},
            {"name": "Death_Date", "type": ["null", "string"], "default": None},
            {"name": "DIED_FLAG", "type": ["null", "string"], "default": None},
            {"name": "ADMIT_DATE_ID", "type": ["null", "long"], "default": None},
            {"name": "DISCHARGE_DATE_ID", "type": ["null", "long"], "default": None},
            {"name": "ICU_ADMIT_DATE_ID", "type": ["null", "long"], "default": None},
            {"name": "ICU_DISCHARGE_DATE_ID", "type": ["null", "long"], "default": None},
        ],
    },
}

def convert_bool_to_str(val):
    if pd.isna(val):
        return None
    if isinstance(val, bool):
        return "True" if val else "False"
    if isinstance(val, (int, float)):
        if val == 0:
            return "False"
        elif val == 1:
            return "True"
    if isinstance(val, str):
        v = val.strip().lower()
        if v in ['true', 'false']:
            return val.capitalize()
    return val


def clean_and_cast(df, schema):
    for col in df.columns:
        if df[col].dtype == object:
            df[col] = df[col].apply(lambda x: x.strip() if isinstance(x, str) else x)
    df.replace({"": None}, inplace=True)

    # Fix NaN or float in icd9_code for DIM_DIAGNOSIS
    if schema["name"] == "DIM_DIAGNOSIS" and "icd9_code" in df.columns:
        df["icd9_code"] = df["icd9_code"].apply(lambda x: None if pd.isna(x) or isinstance(x, float) else x)

    for field in schema["fields"]:
        name = field["name"]
        types = field["type"]
        if name not in df.columns:
            continue
        if types == ["null", "string"] and name in ["HOSPITAL_EXPIRE_FLAG", "DIED_FLAG"]:
            df[name] = df[name].apply(convert_bool_to_str)
        elif "long" in types:
            df[name] = pd.to_numeric(df[name], errors='coerce').astype("Int64")
        elif "double" in types:
            df[name] = pd.to_numeric(df[name], errors='coerce')
        else:
            pass

    # Special case: FACT_PATIENT_VISITS Death_Date must be string or None
    if "Death_Date" in df.columns:
        df["Death_Date"] = df["Death_Date"].apply(
            lambda x: str(int(x)) if pd.notna(x) and isinstance(x, float) else (x if x is None or isinstance(x, str) else None)
        )
    return df


def dataframe_to_avro(df, schema, output_file):
    parsed_schema = parse_schema(schema)
    records = df.where(pd.notnull(df), None).to_dict(orient="records")
    with open(output_file, "wb") as out:
        writer(out, parsed_schema, records)
    print(f"✅ Converted {os.path.basename(output_file).replace('.avro','')} ➝ {output_file}")


def process_file(base_name):
    file_path = os.path.join(input_folder, base_name + ".txt")
    if base_name not in schemas:
        print(f"⚠️ No schema defined for {base_name}")
        return

    try:
        # Use quoting to handle commas inside text fields, skip bad lines
        df = pd.read_csv(file_path, quotechar='"', on_bad_lines='skip', encoding='utf-8')
    except Exception as e:
        print(f"❌ Could not read {file_path}: {e}")
        return

    schema = schemas[base_name]
    df = clean_and_cast(df, schema)
    output_file = os.path.join(output_folder, base_name + ".avro")

    try:
        dataframe_to_avro(df, schema, output_file)
    except Exception as e:
        print(f"❌ Error processing {file_path}: {e}")


if __name__ == "__main__":
    for table in schemas.keys():
        process_file(table)
