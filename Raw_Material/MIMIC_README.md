## 🏥 MIMIC-III Demo Dataset Overview

The **MIMIC-III Clinical Database Demo v1.4** is a publicly accessible subset of the full MIMIC-III dataset, designed to help researchers and students explore the structure and content of the data without requiring credentialed access. 

It includes deidentified health-related data for **100 patients** who were admitted to critical care units at the **Beth Israel Deaconess Medical Center** between 2001 and 2012.  
> *Note: This demo dataset excludes free-text notes to simplify access and usage.*

---

### 🧾 What's Inside the Demo Dataset

The demo dataset is organized into multiple CSV files, each representing different aspects of patient care. Key tables include:

- **PATIENTS.csv**: Demographic information such as age, gender, and ethnicity.
- **ADMISSIONS.csv**: Details of hospital admissions, including admission and discharge times, admission type, and insurance information.
- **ICUSTAYS.csv**: Records of ICU stays, capturing the duration and identifiers for each stay.
- **DIAGNOSES_ICD.csv**: International Classification of Diseases (ICD-9) codes assigned to patients, indicating diagnoses.
- **PROCEDURES_ICD.csv**: ICD-9 procedure codes detailing medical procedures performed.
- **LABEVENTS.csv**: Laboratory test results, including test identifiers, values, and units.
- **PRESCRIPTIONS.csv**: Information on prescribed medications, dosages, and administration routes.
- **INPUTEVENTS_CV.csv / INPUTEVENTS_MV.csv**: Records of fluid and medication inputs, sourced from two different ICU information systems (CareVue and MetaVision).
- **OUTPUTEVENTS.csv**: Data on patient outputs, such as urine output and other measurements.
- **CHARTEVENTS.csv**: Time-stamped observations and measurements charted by caregivers, including vital signs and other monitoring data.

These tables are interconnected through unique identifiers like `SUBJECT_ID` (patient), `HADM_ID` (hospital admission), and `ICUSTAY_ID` (ICU stay), facilitating comprehensive analyses across different data types.

---

### 📚 Data Source

The data originates from two critical care information systems used at the **Beth Israel Deaconess Medical Center**:

- **Philips CareVue Clinical Information System**
- **iMDsoft MetaVision ICU**

These systems provided detailed clinical data, including physiological measurements, medication administration records, and caregiver notes.  

Additional information was sourced from hospital electronic health records and the **Social Security Administration Death Master File** to capture out-of-hospital mortality data. All data underwent deidentification in compliance with **HIPAA standards** to protect patient privacy.

---

### 🎯 Purpose and Use Cases

The MIMIC-III Demo dataset serves as an **educational and exploratory tool**, allowing users to:

- Familiarize themselves with the structure and types of data available in the full MIMIC-III database.
- Develop and test data processing pipelines and analytical methods.
- Conduct preliminary analyses to assess the feasibility of research questions before applying for access to the full dataset.

By providing a **manageable subset** of the comprehensive MIMIC-III database, the demo facilitates learning and preliminary research in **clinical data science**.

---
