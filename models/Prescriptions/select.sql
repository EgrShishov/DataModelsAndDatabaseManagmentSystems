/*Prescriptions by patient*/
SELECT
    p.prescription_id,
    p.prescription_date,
    p.medication,
    p.dosage,
    p.duration,
    CONCAT(pt.last_name, ' ', pt.first_name, ' ', pt.middle_name) AS patients_name,
    CONCAT(d.last_name, ' ', d.first_name, ' ', d.middle_name) AS doctors_name
FROM Prescriptions p
JOIN Doctors d ON d.doctor_id = p.doctor_id
JOIN Patients pt ON p.patient_id = pt.patient_id
ORDER BY p.prescription_date DESC;

SELECT
    p.prescription_id,
    p.prescription_date,
    p.medication,
    p.dosage,
    p.duration,
    CONCAT(pt.last_name, ' ', pt.first_name, ' ', pt.middle_name) AS patients_name,
    CONCAT(d.last_name, ' ', d.first_name, ' ', d.middle_name) AS doctors_name
FROM Prescriptions AS p
         JOIN Patients AS pt ON (p.patient_id=pt.patient_id)
         JOIN Doctors AS d ON (p.doctor_id=d.doctor_id)
WHERE p.patient_id = 19;

/*amount of prescripntions per user*/
SELECT
    d.last_name,
    COUNT(p.prescription_id) AS prescription_count
FROM Doctors AS d
         JOIN Prescriptions AS p ON (p.doctor_id=d.doctor_id)
GROUP BY d.last_name;