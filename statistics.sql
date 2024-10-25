-- previous conclusions from results
SELECT
    p.patient_id,
    p.first_name,
    p.last_name,
    p.middle_name,
    r.conclusion,
    r.complaints,
    LAG(r.conclusion) OVER (PARTITION BY p.patient_id ORDER BY r.result_id) AS previous_conclusion
FROM Patients p
JOIN Results r ON p.patient_id = r.patient_id;

--last and first result for patient
SELECT
    p.patient_id,
    r.recommendations,
    r.recommendations,
    FIRST_VALUE(r.conclusion) OVER (PARTITION BY p.patient_id ORDER BY result_id) AS first_results,
    LAST_VALUE(r.conclusion) OVER (PARTITION BY  p.patient_id ORDER BY result_id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_results
FROM Patients p
JOIN Results r ON p.patient_id = r.patient_id
WHERE p.patient_id = 1;

--first and last patients visit
SELECT DISTINCT
    p.patient_id,
    p.first_name,
    p.last_name,
    p.middle_name,
    FIRST_VALUE(a.appointment_date) OVER (PARTITION BY p.patient_id ORDER BY a.appointment_date) AS date_of_first_visit,
    LAST_VALUE(a.appointment_date) OVER (PARTITION BY p.patient_id ORDER BY a.appointment_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS date_of_last_visit
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
WHERE p.patient_id = 1;

--rank most visited procedures
SELECT
    mp.procedure_name,
    COUNT(mp.patient_id) as total_visited,
    DENSE_RANK() OVER (ORDER BY mp.patient_id DESC) AS procedures_rank
FROM MedicalProcedures as mp
GROUP BY mp.procedure_name, mp.patient_id;

--rank doctors among patients
SELECT
    d.first_name,
    d.last_name,
    d.middle_name,
    COUNT(a.patient_id) AS total_patients,
    RANK() OVER (ORDER BY COUNT(a.patient_id) DESC) AS rank_by_patients
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
group by d.last_name, d.first_name, d.middle_name;

-- doctors with patients > avg
SELECT
  d.doctor_id,
  d.first_name,
  d.last_name,
  d.middle_name,
  COUNT(a.patient_id) AS total_patients
FROM Doctors d
       JOIN Appointments a ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.first_name, d.last_name, d.middle_name
HAVING COUNT(a.patient_id) > (
    SELECT AVG(patients_count)
    FROM (
        SELECT COUNT(a.patient_id) as patients_count
        FROM Doctors d
        JOIN Appointments a ON a.doctor_id = d.doctor_id
        GROUP BY d.doctor_id
    ) AS subQuery
);

-- union for all employees
SELECT first_name, last_name, middle_name, date_of_birth FROM Doctors
UNION ALL
SELECT first_name, last_name, middle_name, date_of_birth FROM Receptionists;

-- age statistics
SELECT
    COUNT(CASE WHEN AGE(date_of_birth) < '18 years' THEN 1 END) AS children_count,
    COUNT(CASE WHEN AGE(date_of_birth) > '18 years' AND AGE(date_of_birth) < '65 years' THEN 1 END) AS adults_count,
    COUNT(CASE WHEN AGE(date_of_birth) > '65 years' THEN 1 END) AS seniors_count
FROM Patients;
