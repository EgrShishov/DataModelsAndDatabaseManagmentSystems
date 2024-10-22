/* Appointments */
UPDATE Appointments
SET is_approved = true
WHERE appointment_id = 1;

UPDATE Appointments
SET is_approved = false
WHERE appointment_id = 1;

UPDATE Appointments
SET (appointment_date, appointment_time) = ('2024-01-12', '09:30:00')
WHERE appointment_id = 1 AND is_approved = false;

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

/*процедуры для встречи*/
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

/*amount of appointments per doctor*/
SELECT
    COUNT(a.appointment_id) AS appointments_count,
    d.first_name,
    d.last_name,
    d.middle_name
FROM Appointments AS a
JOIN Doctors AS d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id;

/*Results*/
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
    JOIN Documents AS d ON (r.doctor_id=d.document_id)
    JOIN Appointments AS a ON (r.appointment_id=a.appointment_id)
    JOIN Patients AS p ON (r.patient_id=a.patient_id)
    JOIN Doctors AS doc ON (doc.doctor_id=a.doctor_id)
WHERE r.patient_id = '1';

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

/*Doctors */
SELECT d.career_start_year
FROM Doctors AS d
JOIN Specializations AS s ON (s.specialization_id=d.specialization_id)
WHERE d.doctor_id = '1';

/*Patients */
SELECT
    first_name,
    last_name,
    middle_name,
    date_of_birth
FROM Patients;

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

/*Doctors */
SELECT
    doctors.first_name,
    doctors.last_name,
    doctors.middle_name,
    doctors.career_start_year,
    s.specialization_name
FROM Doctors as doctors
JOIN Specializations as s
ON doctors.specialization_id = s.specialization_id;

/*doctors with upcoming appointments*/
SELECT *
FROM Doctors
WHERE doctor_id IN (
    SELECT doctor_id
    FROM Appointments
    WHERE appointment_date >= current_date
);

SELECT
    d.first_name,
    d.last_name,
    d.middle_name,
    s.specialization_name
FROM Doctors as d
LEFT JOIN Specializations as s ON s.specialization_id = d.specialization_id;

/*Receptionists */
SELECT
    first_name,
    last_name,
    middle_name,
    date_of_birth
FROM Receptionists
ORDER BY last_name;

/*Services */
SELECT
FROM Services AS s
JOIN ServiceCategory AS sc ON (sc.service_category_id=s.service_category_id)
WHERE s.is_active=True;

/*Prescriptions*/
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
WHERE p.patient_id='1' AND p.prescription_date > '2023-01-01';

/*prescripntions per user*/
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

/*Payments*/
SELECT
    p.amount,
    p.payment_date,
    a.appointment_date
FROM Payments AS p
JOIN Appointments AS a ON (p.appointment_id=a.appointment_id)
WHERE p.user_id='1';

-- задолженности
/*SELECT
    pt.patient_id,
    pt.last_name,
    pt.first_name,
    COALESCE(SUM(SELECT procedure_cost FROM MedicalProcedures WHERE patient_id=pt.patient_id) AS invoices), 0) as total_invoices
COALESCE(SUM(p.amount),0) as total_payments,
FROM Payments AS pm
    JOIN Patients AS p ON (pm.user_id=p.user_id)
    JOIN Appointments AS a ON (a.patient_id=p.patient_id)
    LEFT JOIN MedicalProcedures AS mp ON (mp.patient_id=p.patient_id)
SELECT
GROUP BY pt.patient_id, pt.first_name, pt.last_name;*/

-- todo

/*Common*/
SELECT
pt.first_name,
d.last_name
FROM Patients AS pt
CROSS JOIN Doctors AS d;

/*Logs*/
SELECT
    user_id,
    action,
    action_date
FROM Logs;

EXPLAIN SELECT * FROM Appointments WHERE doctor_id = 1;
