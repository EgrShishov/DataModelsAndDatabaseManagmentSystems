/*Procedures*/
SELECT
    mp.procedure_name,
    mp.description,
    mp.procedure_cost,
    mp.procedure_date,
    mp.procedure_time,
    d.last_name AS doctors_last_name,
    p.last_name AS patients_last_name
FROM MedicalProcedures AS mp
         JOIN Doctors AS d ON (mp.doctor_id=d.doctor_id)
         JOIN Patients AS p ON (mp.patient_id=p.patient_id)
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
WHERE p.patient_id = 1;