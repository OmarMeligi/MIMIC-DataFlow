-- 1. SEASONAL ADMISSION PATTERNS
-- Monthly admission trends and outcomes
SELECT 
    d.YEAR,
    d.MONTH,
    COUNT(*) as total_admissions,
    ROUND(AVG(f.Hosp_LOS), 2) as avg_los,
    SUM(CASE WHEN f.DIED_FLAG = 'Y' THEN 1 ELSE 0 END) as deaths,
    ROUND(SUM(CASE WHEN f.DIED_FLAG = 'Y' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as mortality_rate_pct
FROM FACT_PATIENT_VISITS f
JOIN DIM_DATE d ON f.ADMIT_DATE_ID = d.DATE_ID
WHERE d.YEAR >= 2020  -- Adjust year range as needed
GROUP BY d.YEAR, d.MONTH
ORDER BY d.YEAR, d.MONTH;


2-- Patients with multiple visits (potential readmissions)
SELECT 
    p.SUBJECT_ID,
    p.GENDER,
    COUNT(*) as visit_count,
    MIN(admit_d.DATE_VALUE) as first_admission,
    MAX(admit_d.DATE_VALUE) as last_admission,
    ROUND(AVG(f.Hosp_LOS), 2) as avg_los_per_visit,
    SUM(CASE WHEN f.DIED_FLAG = 'Y' THEN 1 ELSE 0 END) as total_deaths
FROM FACT_PATIENT_VISITS f
JOIN DIM_PATIENT p ON f.SUBJECT_ID = p.SUBJECT_ID
JOIN DIM_DATE admit_d ON f.ADMIT_DATE_ID = admit_d.DATE_ID
GROUP BY p.SUBJECT_ID, p.GENDER
HAVING COUNT(*) > 1
ORDER BY visit_count DESC
LIMIT 20;

3-- Average length of stay by gender and age groups
SELECT 
    p.GENDER,
    CASE 
        WHEN YEAR('2024-01-01') - YEAR(p.DOB) < 30 THEN '18-29'
        WHEN YEAR('2024-01-01') - YEAR(p.DOB) < 50 THEN '30-49'
        WHEN YEAR('2024-01-01') - YEAR(p.DOB) < 70 THEN '50-69'
        ELSE '70+' 
    END AS age_group,
    COUNT(*) as total_visits,
    ROUND(AVG(f.Hosp_LOS), 2) as avg_hospital_los,
    ROUND(AVG(f.ICU_LOS), 2) as avg_icu_los,
    SUM(CASE WHEN f.DIED_FLAG = 'Y' THEN 1 ELSE 0 END) as deaths,
    ROUND(SUM(CASE WHEN f.DIED_FLAG = 'Y' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as mortality_rate_pct
FROM FACT_PATIENT_VISITS f
JOIN DIM_PATIENT p ON f.SUBJECT_ID = p.SUBJECT_ID
WHERE p.DOB IS NOT NULL
GROUP BY p.GENDER, 
    CASE 
        WHEN YEAR('2024-01-01') - YEAR(p.DOB) < 30 THEN '18-29'
        WHEN YEAR('2024-01-01') - YEAR(p.DOB) < 50 THEN '30-49'
        WHEN YEAR('2024-01-01') - YEAR(p.DOB) < 70 THEN '50-69'
        ELSE '70+' 
    END
ORDER BY p.GENDER, age_group;


-- 4. LENGTH OF STAY OUTLIER ANALYSIS
-- Identify unusually long stays and their characteristics
WITH los_with_stats AS (
    SELECT 
        f.SUBJECT_ID,
        f.VISIT_SK,
        f.Hosp_LOS,
        f.ICU_LOS,
        f.DIAGNOSIS_SK,
        f.HADM_ID,
        f.DIED_FLAG,
        AVG(f.Hosp_LOS) OVER() as mean_los,
        STDDEV(f.Hosp_LOS) OVER() as std_los
    FROM FACT_PATIENT_VISITS f
    WHERE f.Hosp_LOS IS NOT NULL
)
SELECT 
    lws.SUBJECT_ID,
    lws.VISIT_SK,
    lws.Hosp_LOS,
    lws.ICU_LOS,
    diag.SHORT_TITLE,
    a.ADMISSION_TYPE,
    lws.DIED_FLAG,
    p.GENDER,
    CASE 
        WHEN lws.Hosp_LOS > (lws.mean_los + 2 * lws.std_los) THEN 'Extreme Outlier'
        WHEN lws.Hosp_LOS > (lws.mean_los + lws.std_los) THEN 'Outlier'
        ELSE 'Normal'
    END as los_category
FROM los_with_stats lws
JOIN DIM_PATIENT p ON lws.SUBJECT_ID = p.SUBJECT_ID
JOIN DIM_DIAGNOSIS diag ON lws.DIAGNOSIS_SK = diag.DIAG_SK
JOIN DIM_ADMISSION a ON lws.HADM_ID = a.HADM_SK
WHERE lws.Hosp_LOS > (lws.mean_los + lws.std_los)
ORDER BY lws.Hosp_LOS DESC
LIMIT 50;
