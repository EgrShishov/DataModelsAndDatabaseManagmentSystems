/*Prescriptions by patient*/
SELECT
    p.prescription_date,
    p.medication,
    p.dosage,
    p.duration,
    pt.last_name AS patients_last_name,
    d.last_name AS doctors_last_name
FROM Prescriptions AS p
         JOIN Patients AS pt ON (p.patient_id=pt.patient_id)
         JOIN Doctors AS d ON (p.doctor_id=d.doctor_id)
WHERE p.patient_id = 1 AND p.prescription_date > '2023-01-01';

/*amount of prescripntions per user*/
SELECT
    d.last_name,
    COUNT(p.prescription_id) AS prescription_count
FROM Doctors AS d
         JOIN Prescriptions AS p ON (p.doctor_id=d.doctor_id)
GROUP BY d.last_name;

SELECT
    medication,
    dosage
FROM Prescriptions
WHERE patient_id IN (
    SELECT patient_id
    FROM Patients
    WHERE date_of_birth > '1960-01-01'
);

