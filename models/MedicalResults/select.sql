/*Results for patient*/
SELECT
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    p.middle_name AS patient_middle_name,
    doc.first_name AS doctor_first_name,
    doc.last_name AS doctor_last_name,
    doc.middle_name AS doctor_middle_name,
    r.complaints AS complaints,
    r.conclusion AS conclusion,
    r.recommendations AS recommendations,
    d.file_path AS document_path
FROM Results AS r
         JOIN Documents AS d ON (r.document_id=d.document_id)
         JOIN Appointments AS a ON (r.appointment_id=a.appointment_id)
         JOIN Patients AS p ON (r.patient_id=a.patient_id)
         JOIN Doctors AS doc ON (doc.doctor_id=a.doctor_id)
WHERE r.patient_id = '1';

/*medical history*/
SELECT
    r.Complaints,
    r.Conclusion,
    r.Recommendations,
    r.document_id
FROM Results r
         JOIN Patients p ON r.patient_id = p.patient_id
WHERE p.patient_id = 3
ORDER BY r.result_id DESC;

