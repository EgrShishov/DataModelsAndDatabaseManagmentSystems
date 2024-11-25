INSERT INTO Roles (role_name)
VALUES
    ('receptionist'),
    ('doctor'),
    ('patient');

INSERT INTO Offices (country, region, city, street, street_number, office_number, phone_number)
VALUES
    ('Belarus', 'Minsk', 'Minsk', 'Yakuba Kolasa', 28, 1106, '+375445717021'),
    ('Belarus', 'Mogilev', 'Mogilev', 'Nezavisimosti', 10, 32, '+375445717021'),
    ('Belarus', 'Mogilev', 'Horki', 'Zaslonova', 138, 2, '+375445717021'),
    ('Belarus', 'Mogilev', 'Mstislavl', 'Petra Mstislavtsa', 6, 222, '+375445717021'),
    ('Belarus', 'Minsk', 'Soligorsk', 'Nepokorennyx', 23, 43, '+375445717021'),
    ('Belarus', 'Minsk', 'Minsk', 'Yakuba Kolassa', 34, 1, '+375445717021'),
    ('Belarus', 'Grodno', 'Grodno', 'Sovetskaya', 55, 15, '+375445717022'),
    ('Belarus', 'Brest', 'Brest', 'Pushkinskaya', 1, 101, '+375445717023'),
    ('Belarus', 'Gomel', 'Gomel', 'Sovetskaya', 99, 502, '+375445717024'),
    ('Belarus', 'Vitebsk', 'Vitebsk', 'Frunze', 25, 5, '+375445717025');

INSERT INTO Users (user_name, email, phone_number, is_email_verified, password_hash, role_id)
VALUES
    ('receptionist', 'receptionist@example.com', '+375445717021', TRUE, 'password123',(SELECT roles.role_id FROM Roles WHERE role_name = 'receptionist'));

    ('rosto4eks', 'rosto4eks@gmail.com', '+375445717021', TRUE, 'hash1', (SELECT roles.role_id FROM Roles WHERE role_name = 'patient')),
    ('statham', 'statham@gmail.com', '+375445717021', TRUE,'hash2', (SELECT roles.role_id FROM Roles WHERE role_name = 'patient')),
    ('pupsik228', 'pupsik228@gmail.com', '+375445717021', FALSE, 'hash3',(SELECT roles.role_id FROM Roles WHERE role_name = 'patient')),
    ('yarik1337', 'yarik1337@gmail.com', '+375445717021', FALSE, 'hash4',(SELECT roles.role_id FROM Roles WHERE role_name = 'doctor')),
    ('receptionist', 'receptionist@example.com', '+375445717021', TRUE, 'password123',(SELECT roles.role_id FROM Roles WHERE role_name = 'receptionist')),
    ('ronaldo7', 'ronaldo7@gmail.com', '+375445717021', TRUE, 'hash6',(SELECT roles.role_id FROM Roles WHERE role_name = 'receptionist')),
    ('bekarevstanislav', 'bekarevstanislav@gmail.com', '+375445717021', FALSE, 'hash7',(SELECT roles.role_id FROM Roles WHERE role_name = 'doctor')),
    ('shishov', 'e.shishov@gmail.com', '+375445717021', TRUE, 'hash8', (SELECT roles.role_id FROM Roles WHERE role_name = 'patient')),
    ('krasev', 'professor@gmail.com', '+375445717021', FALSE, 'hash9',(SELECT roles.role_id FROM Roles WHERE role_name = 'patient')),
    ('makarevich', 'makarevich@gmail.com', '+375445717021', TRUE, 'hash10',(SELECT roles.role_id FROM Roles WHERE role_name = 'doctor'));

INSERT INTO Services (service_category_id, service_name, is_active)
VALUES
    (1, 'Blood Test', TRUE),
    (2, 'MRI Scan', TRUE),
    (3, 'Consultation', TRUE),
    (1, 'X-Ray', TRUE),
    (2, 'Ultrasound', TRUE),
    (3, 'Surgery Consultation', TRUE),
    (1, 'Urine Test', TRUE),
    (2, 'CT Scan', TRUE),
    (3, 'Orthopedic Consultation', TRUE),
    (1, 'Liver Function Test', TRUE);

INSERT INTO Patients (user_id, first_name, last_name, middle_name, date_of_birth)
VALUES
    (1, 'Rostislav', 'Sergeev', 'BRSMovich', '1990-05-10'),
    (2, 'Json', 'Stathem', 'Alexandrovich', '1985-03-22'),
    (3, 'Yaroslav', 'Yastremskiy', 'Migalovich', '2000-06-12'),
    (8, 'Yahor', 'Shyshoy', 'Pavlovich', '2004-01-12'),
    (9, 'Pavel', 'Krasev', 'Professorovich', '2004-09-21');

INSERT INTO Doctors (user_id, first_name, last_name, middle_name, date_of_birth, career_start_year, specialization_id)
VALUES
    (4, 'Yastremskiy', 'Yaroslav', 'Doctorovich', '1990-05-10', '2004', (SELECT specialization_id FROM Specializations WHERE specialization_name='General Practitioner')),
    (7, 'Stanislav', 'Beakrev', 'Serggevich', '2005-01-24', '2020', (SELECT specialization_id FROM Specializations WHERE specialization_name='Cardiologist')),
    (10, 'Darya', 'Makarevich', 'Studsovetovna', '2000-06-12', '2004', (SELECT specialization_id FROM Specializations WHERE specialization_name='Neurologist'));


INSERT INTO Receptionists (user_id, first_name, last_name, middle_name, date_of_birth)
VALUES
    (36, 'Sarah', 'Connor', 'Jane', '1992-07-18');
    (6, 'Peter', 'Parker', 'Benjamin', '1989-11-10');

INSERT INTO Appointments (patient_id, doctor_id, office_id, service_id, appointment_date, appointment_time, is_approved)
VALUES
    (1, 1, 1, 11, '2024-01-15', '09:30', FALSE),
    (2, 2, 1, 12, '2024-01-16', '10:00', TRUE),
    (3, 3, 2, 13, '2024-01-17', '11:00', FALSE),
    (4, 1, 1, 14, '2024-01-15', '09:30', FALSE),
    (5, 2, 1, 12, '2024-01-16', '10:00', TRUE),
    (1, 3, 2, 11, '2024-01-17', '11:00', FALSE),
    (2, 1, 1, 11, '2024-01-15', '09:30', FALSE),
    (3, 2, 1, 12, '2024-01-16', '10:00', TRUE),
    (4, 3, 2, 13, '2024-01-17', '11:00', FALSE),
    (5, 1, 3, 13, '2024-01-18', '12:00', TRUE);

INSERT INTO Specializations (specialization_name)
VALUES
('General Practitioner'),
('Cardiologist'),
('Neurologist');

INSERT INTO Logs (user_id, action, action_date)
VALUES
(1, 'Created appointment', '2024-01-15 09:30:00'),
(2, 'Uploaded results', '2024-01-16 10:00:00'),
(3, 'Made a payment', '2024-01-17 11:00:00'),
(4, 'Updated profile', '2024-01-18 12:00:00'),
(5, 'Cancelled appointment', '2024-01-19 13:00:00'),
(6, 'Checked-in', '2024-01-20 14:00:00'),
(7, 'Scheduled follow-up', '2024-01-21 15:00:00'),
(8, 'Completed survey', '2024-01-22 16:00:00'),
(9, 'Rescheduled appointment', '2024-01-23 17:00:00'),
(10, 'Left feedback', '2024-01-24 18:00:00');

INSERT INTO MedicalProcedures (procedure_name, description, procedure_cost, doctor_id, patient_id, procedure_time, procedure_date)
VALUES
('Appendectomy', 'Appendix removal surgery', 1500.00, 1, 1, '10:00', '2024-02-01'),
('Cataract surgery', 'Lens replacement surgery', 2000.00, 2, 2, '11:30', '2024-02-02'),
('Colonoscopy', 'Examination of the colon', 500.00, 3, 3, '09:00', '2024-02-03');

INSERT INTO Payments (appointment_id, amount, user_id, payment_date)
VALUES
(41, 100.00, 1, '2024-01-15 09:30:00'),
(42, 150.00, 2, '2024-01-16 10:00:00'),
(43, 200.00, 3, '2024-01-17 11:00:00');

INSERT INTO Prescriptions (patient_id, doctor_id, prescription_date, medication, dosage, duration)
VALUES
(1, 1, '2024-01-15 09:30:00', 'Paracetamol', '500mg', 10),
(2, 2, '2024-01-16 10:00:00', 'Ibuprofen', '400mg', 7),
(3, 3, '2024-01-17 11:00:00', 'Amoxicillin', '250mg', 5);

INSERT INTO Documents (document_type, file_path)
VALUES
('Blood Test', '/documents/blood_test_1.pdf'),
('X-Ray', '/documents/xray_1.pdf'),
('MRI Scan', '/documents/mri_1.pdf');

INSERT INTO Results (patient_id, doctor_id, document_id, appointment_id, complaints, recommendations, conclusion)
VALUES
    (1, 1, 1, 41, 'Headache', 'Take rest', 'Migraine'),
    (2, 2, 2, 42, 'Back pain', 'Physical therapy', 'Muscle strain'),
    (3, 3, 3, 43, 'Fever', 'Antibiotics', 'Viral infection');

INSERT INTO servicecategory (category_name)
VALUES
('Laboratory Tests'),
('Imaging'),
('Consultation');

CREATE INDEX idx_patient_search ON Patients (last_name, first_name);
CREATE INDEX idx_users_phone_number ON Users(phone_number);
CREATE INDEX idx_doctors_search ON Doctors (last_name, first_name);
CREATE INDEX idx_services_category_active ON Services(service_category_id, is_active);
CREATE INDEX idx_offices_city_region ON Offices(city, region);
CREATE INDEX idx_prescriptions_doctor_date ON Prescriptions(doctor_id, prescription_date);
CREATE INDEX idx_results_patient_appointment ON Results(patient_id, appointment_id);
CREATE INDEX idx_payments_user_date ON Payments(user_id, payment_date);
CREATE INDEX idx_appointments_doctor_date ON Appointments(doctor_id, appointment_date);
CREATE INDEX idx_appointment_date_patient ON Appointments(appointment_date, patient_id);

INSERT INTO AppointmentProcedures (appointment_id, procedure_id)
VALUES
((SELECT appointments.appointment_id FROM appointments WHERE appointment_date='2024-01-15' LIMIT 1),(SELECT procedure_id FROM medicalprocedures WHERE procedure_name='Appendectomy' LIMIT 1)),
((SELECT appointments.appointment_id FROM appointments WHERE appointment_date='2024-01-15' LIMIT 1),(SELECT procedure_id FROM medicalprocedures WHERE procedure_name='Cataract surgery' LIMIT 1)),
((SELECT appointments.appointment_id FROM appointments WHERE appointment_date='2024-01-16' LIMIT 1),(SELECT procedure_id FROM medicalprocedures WHERE procedure_name='Cataract surgery' LIMIT 1)),
((SELECT appointments.appointment_id FROM appointments WHERE appointment_date='2024-01-16' LIMIT 1),(SELECT procedure_id FROM medicalprocedures WHERE procedure_name='Appendectomy' LIMIT 1)),
((SELECT appointments.appointment_id FROM appointments WHERE appointment_date='2024-01-16' LIMIT 1),(SELECT procedure_id FROM medicalprocedures WHERE procedure_name='Colonoscopy' LIMIT 1)),
((SELECT appointments.appointment_id FROM appointments WHERE appointment_date='2024-01-17' LIMIT 1),(SELECT procedure_id FROM medicalprocedures WHERE procedure_name='Cataract surgery' LIMIT 1)),
((SELECT appointments.appointment_id FROM appointments WHERE appointment_date='2024-01-18' LIMIT 1),(SELECT procedure_id FROM medicalprocedures WHERE procedure_name='Appendectomy' LIMIT 1));