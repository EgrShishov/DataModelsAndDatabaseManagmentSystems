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

SELECT
    CONCAT(p.last_name, ' ', p.first_name, ' ', p.middle_name) AS patients_name,
    CONCAT(doc.last_name, ' ', doc.first_name, ' ', doc.middle_name) AS doctors_name,
    r.complaints,
    r.conclusion,
    r.recommendations,
    d.file_path,
    d.document_type
FROM Results AS r
         JOIN Documents AS d ON (r.document_id=d.document_id)
         JOIN Appointments AS a ON (r.appointment_id=a.appointment_id)
         JOIN Patients AS p ON (a.patient_id=p.patient_id)
         JOIN Doctors AS doc ON (doc.doctor_id=a.doctor_id);