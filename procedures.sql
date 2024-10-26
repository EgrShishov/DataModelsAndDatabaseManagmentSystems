-- procedures for creating accounts
CREATE OR REPLACE PROCEDURE create_patient_account(
    email VARCHAR(128),
    password VARCHAR(256),
    first_name VARCHAR(128),
    last_name VARCHAR(128),
    middle_name VARCHAR(128),
    phone_number VARCHAR(20),
    date_of_birth DATE)
AS $$
DECLARE
    inserted_user_id INTEGER;
BEGIN
    -- already in transaction
    INSERT INTO Users (role_id, user_name, email, phone_number, password_hash)
    VALUES ((SELECT role_id FROM Roles WHERE role_name = 'patient'),
            CONCAT(first_name, ' ', COALESCE(middle_name, ''), ' ', last_name),
            email, phone_number, password)
    RETURNING user_id INTO inserted_user_id;

    INSERT INTO Patients (user_id, first_name, last_name, middle_name, date_of_birth)
    VALUES(inserted_user_id, first_name, last_name, middle_name, date_of_birth);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE create_doctors_account(
    email VARCHAR(128),
    password VARCHAR(256),
    first_name VARCHAR(128),
    last_name VARCHAR(128),
    middle_name VARCHAR(128),
    phone_number VARCHAR(20),
    date_of_birth DATE,
    spec_name TEXT,
    career_start_year INTEGER)
AS $$
DECLARE
    inserted_user_id INTEGER;
    selected_specialization_id INTEGER;
BEGIN
    INSERT INTO Users (role_id, user_name, email, phone_number, password_hash)
    VALUES ((SELECT role_id FROM Roles WHERE role_name = 'doctor'),
            CONCAT(first_name, ' ', COALESCE(middle_name, ''), ' ', last_name),
            email, phone_number, password)
    RETURNING user_id INTO inserted_user_id;

    SELECT specialization_id INTO selected_specialization_id
    FROM Specializations WHERE Specializations.specialization_name = spec_name;

    INSERT INTO Doctors (user_id, first_name, last_name, middle_name, date_of_birth, specialization_id, career_start_year)
    VALUES(inserted_user_id, first_name, last_name, middle_name, date_of_birth, specialization_id, career_start_year);

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE create_receptionists_account(
    email VARCHAR(128),
    password VARCHAR(256),
    first_name VARCHAR(128),
    last_name VARCHAR(128),
    middle_name VARCHAR(128),
    phone_number VARCHAR(20),
    date_of_birth DATE)
AS $$
DECLARE
    inserted_user_id INTEGER;
BEGIN
    INSERT INTO Users (role_id, user_name, email, phone_number, password_hash)
    VALUES ((SELECT role_id FROM Roles WHERE role_name = 'receptionist'),
            CONCAT(first_name, ' ', COALESCE(middle_name, ''), ' ', last_name),
            email, phone_number, password)
    RETURNING user_id INTO inserted_user_id;

    INSERT INTO Receptionists (user_id, first_name, last_name, middle_name, date_of_birth)
    VALUES(inserted_user_id, first_name, last_name, middle_name, date_of_birth);

END;
$$ LANGUAGE plpgsql;

-- procedures for creating appointment
CREATE OR REPLACE PROCEDURE create_new_appointment(
    p_patient_id INTEGER,
    p_doctor_id INTEGER,
    p_office_id INTEGER,
    p_service_id INTEGER,
    p_appointment_date DATE,
    p_procedure_id INTEGER,
    p_appointment_time TIME)
AS $$
DECLARE
    inserted_appointment_id INTEGER;
BEGIN
    INSERT INTO Appointments (patient_id, doctor_id, office_id, service_id, appointment_date, appointment_time)
    VALUES (p_patient_id, p_doctor_id, p_office_id, p_service_id, p_appointment_date, p_appointment_time)
    RETURNING appointment_id INTO inserted_appointment_id;

    INSERT INTO Invoice (patient_id, appointment_id, total_amount, is_paid, invoice_date, invoice_time)
    VALUES (p_patient_id, inserted_appointment_id,
            (SELECT mp.procedure_cost FROM MedicalProcedures mp WHERE procedure_id = p_procedure_id),
            FALSE, now(), now());
END;
$$ LANGUAGE plpgsql;

--

-- usage
--CALL create_patient_account('mama', 'password', 'Alice', 'Johnson', 'Marie', '+274635437','1995-11-15');