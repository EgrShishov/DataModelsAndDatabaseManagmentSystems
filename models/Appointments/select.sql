/*appointment history by patient*/
SELECT
    a.appointment_date,
    a.appointment_time,
    p.first_name AS patients_first_name,
    p.last_name AS patients_last_name,
    d.first_name AS doctors_first_name,
    d.last_name AS doctors_last_name,
    o.phone_number AS office_phone_number
FROM Appointments AS a
         JOIN Patients AS p ON (a.patient_id=p.patient_id)
         JOIN Doctors AS d ON (a.doctor_id=d.doctor_id)
         JOIN Offices AS o ON (a.office_id=o.office_id)
WHERE a.patient_id = 1
ORDER BY a.appointment_date DESC;

/*поулчение всех встреч с докторами для пациента*/
SELECT
    a.appointment_date,
    a.appointment_time,
    d.first_name AS doctors_first_name,
    d.last_name AS doctors_last_name
FROM Appointments a
         JOIN Patients p ON a.patient_id = p.patient_id
         JOIN Doctors d ON d.doctor_id = a.doctor_id
WHERE a.patient_id = 1;

/*просмотр расписания врача на дату */
SELECT
    a.appointment_date,
    a.appointment_time,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    p.middle_name AS patient_middle_name,
    d.first_name AS doctors_first_name,
    d.last_name AS doctors_last_name,
    d.middle_name AS doctors_middle_name,
    o.city AS office_city,
    o.region AS office_region,
    o.street AS office_street,
    o.street_number AS office_number,
    s.service_name AS service_name
FROM Appointments a
         JOIN Patients p ON a.patient_id = p.patient_id
         JOIN Doctors d ON d.doctor_id = a.doctor_id
         JOIN Services s ON s.service_id = a.service_id
         JOIN Offices o ON o.office_id = a.office_id
WHERE a.doctor_id = 1
  AND a.appointment_date = '2024-10-22'
ORDER BY a.appointment_time;

/*расписание upcoming встреч*/
SELECT a.appointment_date, a.appointment_time, p.first_name, p.last_name, p.middle_name
FROM Appointments a
         JOIN Patients p ON a.patient_id = p.patient_id
WHERE a.doctor_id = 1 AND a.appointment_date >= CURRENT_DATE
ORDER BY a.appointment_date, a.appointment_time;

/*процедуры для встречи*/
ANALYZE Appointments;
EXPLAIN
SELECT
    a.appointment_time,
    d.first_name AS doctor_first_name,
    d.last_name AS doctor_last_name,
    s.service_name,
    mp.procedure_name,
    mp.procedure_cost
FROM Appointments a
         JOIN Doctors d ON a.doctor_id = d.doctor_id
         JOIN Services s ON a.service_id = s.service_id
         LEFT JOIN AppointmentProcedures ap ON a.appointment_id = ap.appointment_id
         LEFT JOIN MedicalProcedures mp ON ap.procedure_id = mp.procedure_id
WHERE a.patient_id = 1
  AND a.appointment_date = '2024-11-05'
ORDER BY a.appointment_time;

SELECT
    a.appointment_date,
    a.appointment_time,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    p.middle_name AS patient_middle_name
FROM Appointments a
         JOIN Patients p ON a.patient_id = p.patient_id
WHERE p.user_id = 1;

SELECT
    appointment_time,
    appointment_date,
    doctor_id,
    patient_id
FROM Appointments
WHERE is_approved = false;

/*предыдущие встречи пациента*/
SELECT DISTINCT
    a.appointment_date,
    a.appointment_time,
    a_alias.appointment_date AS previous_appointment_date,
    a_alias.appointment_time AS previous_appointment_time,
    d.first_name AS doctors_first_name,
    d.last_name AS doctors_last_name,
    d.middle_name AS doctors_middle_name
FROM Appointments AS a
         LEFT JOIN Appointments AS a_alias
                   ON a_alias.appointment_date < a.appointment_date
                       OR (a_alias.appointment_date = a.appointment_date
                           AND a_alias.appointment_time < a.appointment_time)
         JOIN Doctors AS d ON d.doctor_id = a.doctor_id
WHERE a.is_approved = true
  AND a.patient_id = 3
ORDER BY a.appointment_date DESC;

/*amount of appointments per doctor*/
SELECT
    COUNT(a.appointment_id) AS appointments_count,
    d.first_name,
    d.last_name,
    d.middle_name
FROM Appointments AS a
         JOIN Doctors AS d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id;

/*appointment history for patient*/
SELECT
    a.appointment_date, a.appointment_time,
    o.country, o.city, o.street_number, o.street, o.office_number, o.phone_number
FROM appointments a
         JOIN patients p ON a.patient_id = p.patient_id
         JOIN offices o ON o.office_id = a.office_id
WHERE p.patient_id = 3
ORDER BY a.appointment_date DESC, a.appointment_time DESC;