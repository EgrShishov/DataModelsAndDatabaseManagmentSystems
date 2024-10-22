INSERT INTO Users (role_id, user_name, email, phone_number, is_email_verified, password_hash)
VALUES (1, 'ivan_ivanov', 'ivanov@example.com', '+79001234567', FALSE, 'hashed_password');

INSERT INTO Doctors (user_id, first_name, last_name, middle_name, date_of_birth, specialization_id, career_start_year)
VALUES (2, 'Анна', 'Петрова', 'Сергеевна', '1978-06-15', 1, 2003);

INSERT INTO Appointments (patient_id, doctor_id, office_id, service_id, appointment_date, appointment_time)
VALUES (1, 1, 1, 1, '2024-10-25', '10:30:00');

INSERT INTO Results (patient_id, doctor_id, document_id, appointment_id, complaints, recommendations, conclusion)
VALUES (1, 1, 1, 1, 'Боль в спине', 'Массаж', 'Межпозвоночная грыжа');

UPDATE Users
SET role_id = 2
WHERE user_id = 1;

UPDATE Patients
SET first_name = 'New name', last_name = 'New surname'
WHERE patient_id = 1;

UPDATE Users
SET is_email_verified = true
WHERE email = 'ivanov@example.com';

UPDATE Appointments
SET is_approved = true
WHERE appointment_id = 1;

UPDATE MedicalProcedures
SET procedure_cost = 777
WHERE procedure_id = 1;

DELETE FROM Patients
WHERE patient_id = 1;

DELETE FROM Appointments
WHERE appointment_id = 1;

DELETE FROM Appointments
WHERE is_approved = false;

SELECT * FROM Appointments a
JOIN Patients p ON a.patient_id = p.patient_id
WHERE p.user_id = 1;

SELECT d.career_start_year
FROM Doctors AS d
JOIN Specializations AS s ON (s.specialization_id=d.specialization_id)
WHERE d.doctor_id = '1';

SELECT * FROM Patients;

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
WHERE a.is_approved=True
ORDER BY a.appointment_date DESC;

SELECT
FROM Results AS r
     JOIN Documents AS d ON (r.doctor_id=d.document_id)
     JOIN Appointments AS a ON (r.appointment_id=a.appointment_id)
     JOIN Patients AS p ON (r.patient_id=a.patient_id)
     JOIN Doctors AS doc ON (doc.doctor_id=a.doctor_id);

SELECT
FROM Services AS s
     JOIN ServiceCategory AS sc ON (sc.service_category_id=s.service_category_id)
WHERE s.is_active=True;

SELECT
    first_name,
    last_name,
    middle_name,
    date_of_birth
FROM Receptionists
ORDER BY last_name;

SELECT
    p.amount,
    p.payment_date,
    a.appointment_date
FROM
Payments AS p
    JOIN Appointments AS a ON (p.appointment_id=a.appointment_id)
WHERE p.user_id='1';

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

SELECT
    medication,
    dosage
FROM Prescriptions
WHERE patient_id IN (
    SELECT patient_id
    FROM Patients
    WHERE date_of_birth > '1960-01-01'
);

SELECT
    pt.first_name,
    d.last_name
FROM Patients AS pt
CROSS JOIN Doctors AS d;

SELECT
    user_id,
    action,
    action_date
FROM Logs;

SELECT
    mp.procedure_name,
    mp.description,
    mp.procedure_cost,
    mp.procedure_date,
    mp.procedure_time,
    d.last_name AS doctors_last_name,
    p.last_name AS patients_last_name
FROM
MedicalProcedures AS mp
     JOIN Doctors AS d ON (mp.doctor_id=d.doctor_id)
     JOIN Patients AS p ON (mp.patient_id=p.patient_id)
ORDER BY mp.procedure_name;

SELECT * FROM Offices ORDER GROUP BY Country;

SELECT
    d.last_name,
    COUNT(p.prescription_id) AS prescription_count
FROM
Doctors AS d
    JOIN Prescriptions AS p ON (p.doctor_id=d.doctor_id)
GROUP BY d.last_name;

SELECT
    p.last_name,
    SUM(pm.amount) AS total_count
FROM Patients as p
JOIN Payments as pm ON (pm.user_id=p.user_id)
GROUP BY p.last_name;

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

/*процедуры для встречи*/
SELECT mp.procedure_name, mp.procedure_cost
FROM MedicalProcedures mp
 JOIN AppointmentProcedures ap ON mp.procedure_id = ap.procedure_id
WHERE ap.appointment_id = 1;

/*Подсчет количества встреч пациента:*/
SELECT Count(*) AS appointment_amount
FROM Appointments WHERE patient_id = 1;

/*Подсчет общего количества встреч по врачу на определенную дату:*/
SELECT Count(*) AS total_appointments_per_doctor
FROM Appointments WHERE doctor_id = 1 AND appointment_date = '2020-10-25';

/*общий по услугам*/
SELECT Sum(amount) AS total_income
FROM Payments;

/*общий по услугам с деталями*/
SELECT Sum(procedure_cost) AS total, procedure_name
FROM MedicalProcedures
GROUP BY procedure_name;

SELECT * FROM Patients
WHERE first_name ILIKE '%Иван%' AND last_name ILIKE '%Иванов%';

-- задолженности
/*SELECT
    pt.patient_id,
    pt.last_name,
    pt.first_name
        COALESCE(SUM(SELECT procedure_cost FROM MedicalProcedures WHERE patient_id=pt.patient_id) AS invoices), 0) as total_invoices
COALESCE(SUM(p.amount),0) as total_payments,
FROM Payments AS pm
    JOIN Patients AS p ON (pm.user_id=p.user_id)
    JOIN Appointments AS a ON (a.patient_id=p.patient_id)
    LEFT JOIN MedicalProcedures AS mp ON (mp.patient_id=p.patient_id)
SELECT
GROUP BY pt.patient_id, pt.first_name, pt.last_name;*/

-- todo
