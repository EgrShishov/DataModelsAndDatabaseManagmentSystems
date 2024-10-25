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

SELECT * FROM Offices ORDER GROUP BY Country;

SELECT
    p.last_name,
    SUM(pm.amount) AS total_count
FROM Patients as p
         JOIN Payments as pm ON (pm.user_id=p.user_id)
GROUP BY p.last_name;

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

/*количество апрувнутых по доктору*/
SELECT doctor_id, COUNT(is_approved) as total
FROM appointments
GROUP BY doctor_id;

SELECT * FROM patients;

-- json stathem
SELECT * FROM Patients
WHERE first_name ILIKE '%Js%' AND last_name ILIKE '%ath%';
