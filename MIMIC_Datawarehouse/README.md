# MIMIC Data Warehouse Star Schema

```mermaid
erDiagram
    FACT_PATIENT_VISITS {
        string VISIT_SK PK
        string SUBJECT_ID FK
        string ICUSTAY_ID
        string HADM_ID
        string DIAGNOSIS_SK FK
        string CG_SK FK
        number Hosp_LOS
        number ICU_LOS
        date Death_date
        boolean DEED_FLAG
        string ADMIT_DATE_ID FK
        string DISCHARGE_DATE_ID FK
        string ICU_ADMIT_DATE_ID FK
    }

    DIM_PATIENT {
        string SUBJECT_ID PK
        string GENDER
        date DOB
        string MARITAL_STATUS
        string LANGUAGE
        string RELIGION
    }

    DIM_DATE {
        string DATE_ID PK
        date DATE_VALUE
        number DAY
        number MONTH
        number YEAR
        number QUARTER
        number WEEK
    }

    DIM_DIAGNOSIS {
        string DIAG_SK PK
        string icd9_code
        string LONG_TITLE
        string SHORT_TITLE
    }

    DIM_ADMISSION {
        string HADM_SK PK
        string SUBJECT_ID
        string ADMISSION_TYPE
        string INSURANCE
        boolean HOSPITAL_EXPIRE_FLAG
        string language
        string religion
        string marital_status
    }

    DIM_CAREGIVER {
        string CG_ID PK
        string label
        string description
    }

    FACT_PATIENT_VISITS ||--o{ DIM_PATIENT : "References"
    FACT_PATIENT_VISITS }|--|| DIM_DATE : "ADMIT_DATE"
    FACT_PATIENT_VISITS }|--|| DIM_DATE : "DISCHARGE_DATE"
    FACT_PATIENT_VISITS }|--|| DIM_DATE : "ICU_ADMIT_DATE"
    FACT_PATIENT_VISITS }|--|| DIM_DIAGNOSIS : "Has"
    FACT_PATIENT_VISITS }|--|| DIM_CAREGIVER : "Assigned"
    FACT_PATIENT_VISITS }|--|| DIM_ADMISSION : "Associated with"

