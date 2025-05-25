--average hospital length of stay per diagnosis

SELECT
  diag.short_title,
  AVG(a.stays_hosp) AS avg_length_of_stay
FROM
  diagnoses_icd d
JOIN
  admissions a
    ON d.hadm_id = a.hadm_id
LEFT JOIN
  d_icd_diagnoses diag
    ON d.icd9_code = diag.icd9_code
GROUP BY
  diag.short_title
ORDER BY
  avg_length_of_stay DESC;

--distribution of ICU readmissions

WITH patient_icu_counts AS (
  SELECT
    subject_id,
    COUNT(icustay_id) AS icu_stay_count
  FROM
    icustays
  GROUP BY
    subject_id
)

SELECT
  icu_stay_count,
  COUNT(subject_id) AS patient_count
FROM
  patient_icu_counts
GROUP BY
  icu_stay_count
ORDER BY
  icu_stay_count;


--Mortality rate by gender

WITH patient_age AS (
  SELECT
    p.subject_id,
    p.gender,
    FLOOR(DATEDIFF(a.admittime, p.dob) / 365.25) AS age,
    p.expire_flag
  FROM patients p
  JOIN admissions a ON p.subject_id = a.subject_id
),
age_grouped AS (
  SELECT *,
    CASE
      WHEN age < 19 THEN '0-18'
      WHEN age BETWEEN 19 AND 40 THEN '19-40'
      WHEN age BETWEEN 41 AND 65 THEN '41-65'
      ELSE '66+'
    END AS age_group
  FROM patient_age
)

SELECT
  gender,
  age_group,
  COUNT(*) AS total_patients,
  SUM(CASE WHEN expire_flag = 1 THEN 1 ELSE 0 END) AS deaths,
  ROUND(SUM(CASE WHEN expire_flag = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS mortality_rate_percent
FROM age_grouped
GROUP BY gender, age_group
ORDER BY gender, age_group;

