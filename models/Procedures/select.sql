/*/*Procedures*/
SELECT
    mp.procedure_name,
    mp.description,
    mp.procedure_cost,
    mp.procedure_date,
    mp.procedure_time,
    d.last_name AS doctors_last_name,
    p.last_name AS patients_last_name
FROM MedicalProcedures AS mp
         JOIN Doctors AS d ON (mp.doctor_id = d.doctor_id)
         JOIN Patients AS p ON (mp.patient_id = p.patient_id)
ORDER BY mp.procedure_name;

/*пациенты, которые проходили эту процедуру*/
SELECT p.first_name, p.last_name, p.middle_name
FROM Patients AS p
WHERE EXISTS (
    SELECT 1
    FROM medicalprocedures as mp
    WHERE mp.patient_id = p.patient_id
      AND mp.procedure_name ILIKE '%Appendectomy%'
);

/*procedrues history for patient*/
SELECT DISTINCT
    p.first_name,
    p.last_name,
    p.middle_name,
    mp.procedure_name,
    mp.procedure_cost,
    mp.procedure_date,
    mp.procedure_time
FROM MedicalProcedures AS mp
         JOIN Patients as p ON p.patient_id = mp.patient_id
WHERE p.patient_id = 1;

/* all procedures total amount*/
SELECT DISTINCT
    p.first_name,
    p.last_name,
    p.middle_name,
    mp.procedure_name,
    mp.procedure_cost,
    SUM(mp.procedure_cost) OVER (PARTITION BY mp.patient_id) AS total
FROM MedicalProcedures AS mp
         JOIN Patients as p ON p.patient_id = mp.patient_id
WHERE p.patient_id = 1;*/

SELECT
    mp.procedure_id,
    mp.procedure_name,
    mp.procedure_cost,
    mp.procedure_time,
    mp.procedure_date
FROM MedicalProcedures mp;

SELECT
    mp.procedure_name,
    mp.procedure_cost,
    mp.procedure_time,
    mp.procedure_date
FROM MedicalProcedures mp WHERE mp.procedure_id = 1;

-- patients history
SELECT
    ph.history_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    mp.procedure_name,
    ph.procedure_date,
    ph.status
FROM
ProceduresHistory ph
JOIN Patients p ON ph.patient_id = p.patient_id
JOIN MedicalProcedures mp ON ph.procedure_id = mp.procedure_id
WHERE p.patient_id = 1
ORDER BY ph.procedure_date DESC;

-- by date range
SELECT
    ph.history_id,
    mp.procedure_name,
    ph.procedure_date,
    ph.status
FROM ProceduresHistory ph
JOIN MedicalProcedures mp ON ph.procedure_id = mp.procedure_id
WHERE ph.patient_id = 1
        AND ph.procedure_date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY ph.procedure_date;

--latest for each patient
SELECT
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    mp.procedure_name,
    ph.procedure_date,
    ph.status
FROM ProceduresHistory ph
JOIN Patients p ON ph.patient_id = p.patient_id
JOIN MedicalProcedures mp ON ph.procedure_id = mp.procedure_id
WHERE
    ph.history_id IN (
        SELECT MAX(history_id)
        FROM ProceduresHistory
        GROUP BY patient_id
    )
ORDER BY p.last_name;

