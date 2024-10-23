CREATE VIEW PatientAppointments AS
SELECT
    p.patient_id,
    p.first_name as patient_first_name,
    p.last_name as patient_last_name,
    p.middle_name as patient_middle_name,
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    d.doctor_id,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    d.middle_name AS doctor_middle_name,
    s.service_name
FROM Patients p
JOIN Appointments a ON a.patient_id = p.patient_id
JOIN Doctors d ON d.doctor_id = a.doctor_id
JOIN Services s ON s.service_id = a.service_id;

SELECT * FROM PatientAppointments;

CREATE VIEW AppointmentResults AS
SELECT
    a.appointment_date,
    a.appointment_time,
    a.appointment_id,
    r.result_id,
    r.conclusion,
    r.recommendations,
    r.complaints
FROM Appointments as a
LEFT JOIN Results as r
ON a.appointment_id = r.appointment_id;

CREATE VIEW DoctorAppointments AS
SELECT
    d.doctor_id,
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    d.first_name,
    d.last_name,
    d.middle_name
FROM Doctors as d
RIGHT JOIN Appointments a ON d.doctor_id = a.doctor_id;

CREATE VIEW PatientAppointments AS
SELECT
    p.patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    p.middle_name AS patient_middle_name,
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    r.result_id,
    r.recommendations,
    r.complaints,
    r.conclusion
FROM Patients AS p
FULL OUTER JOIN Appointments AS a ON a.patient_id = p.patient_id
JOIN Offices AS o ON a.office_id = o.office_id
LEFT JOIN Results r ON r.appointment_id = a.appointment_id;

CREATE VIEW DoctorServices AS
SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    d.middle_name,
    s.service_id,
    s.service_name
FROM Doctors d
CROSS JOIN Services s;

CREATE MATERIALIZED VIEW PatientsAppointmentsSummary AS
SELECT
    p.patient_id,
    p.first_name,
    p.middle_name,
    p.last_name,
    COUNT(a.appointment_id) AS total_appointments,
    MAX(a.appointment_date) AS last_appointment_date
FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.middle_name, p.last_name;

CREATE VIEW PatientsAppointmentsSummaryNonMaterialized AS
SELECT
    p.patient_id,
    p.first_name,
    p.middle_name,
    p.last_name,
    COUNT(a.appointment_id) AS total_appointments,
    MAX(a.appointment_date) AS last_appointment_date
FROM Appointments a
         JOIN Patients p ON a.patient_id = p.patient_id
GROUP BY p.patient_id, p.first_name, p.middle_name, p.last_name;

CREATE MATERIALIZED VIEW PatientLatestResults AS
SELECT
    p.patient_id,
    r.result_id,
    r.conclusion,
    r.complaints,
    r.recommendations,
    d.file_path,
    d.document_type,
    ROW_NUMBER() OVER (PARTITION BY r.patient_id ORDER BY a.appointment_date DESC) AS rn
FROM Patients p
JOIN Results r ON p.patient_id = r.patient_id
JOIN Appointments a ON a.appointment_id = r.appointment_id
JOIN Documents d ON d.document_id = r.document_id;

SELECT * FROM PatientLatestResults;

EXPLAIN
SELECT * FROM PatientsAppointmentsSummary;

EXPLAIN
SELECT * FROM PatientsAppointmentsSummaryNonMaterialized;