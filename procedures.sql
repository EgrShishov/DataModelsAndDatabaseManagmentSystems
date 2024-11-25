-- procedures for creating accounts
CREATE OR REPLACE FUNCTION create_patient_account(
    email VARCHAR(128),
    password VARCHAR(256),
    first_name VARCHAR(128),
    last_name VARCHAR(128),
    middle_name VARCHAR(128),
    phone_number VARCHAR(20),
    date_of_birth DATE)
RETURNS TABLE(user_id INTEGER, patient_id INTEGER) AS $$
BEGIN
    -- already in transaction
    INSERT INTO Users (role_id, user_name, email, phone_number, password_hash)
    VALUES ((SELECT role_id FROM Roles WHERE role_name = 'patient'),
            CONCAT(first_name, ' ', COALESCE(middle_name, ''), ' ', last_name),
            email, phone_number, password)
    RETURNING Users.user_id INTO user_id;

    INSERT INTO Patients (user_id, first_name, last_name, middle_name, date_of_birth)
    VALUES (user_id, first_name, last_name, middle_name, date_of_birth)
    RETURNING Patients.patient_id INTO patient_id;

    RETURN QUERY SELECT user_id, patient_id;
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
    spec_id INTEGER,
    career_start_year INTEGER,
    OUT user_id INTEGER,
    OUT doctor_id INTEGER)
AS $$
DECLARE
    inserted_user_id INTEGER;
    inserted_doctor_id INTEGER;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Specializations WHERE specialization_id = spec_id) THEN
        RAISE EXCEPTION 'Specialization % does not exist', spec_id;
    END IF;

    INSERT INTO Users (role_id, user_name, email, phone_number, password_hash)
    VALUES ((SELECT role_id FROM Roles WHERE role_name = 'doctor'),
            CONCAT(first_name, ' ', COALESCE(middle_name, ''), ' ', last_name),
            email, phone_number, password)
    RETURNING Users.user_id INTO inserted_user_id;

    INSERT INTO Doctors (user_id, first_name, last_name, middle_name, date_of_birth, specialization_id, career_start_year)
    VALUES(inserted_user_id, first_name, last_name, middle_name, date_of_birth, spec_id, career_start_year)
    RETURNING Doctors.doctor_id INTO inserted_doctor_id;

    user_id := inserted_user_id;
    doctor_id:= inserted_doctor_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE create_receptionists_account(
    email VARCHAR(128),
    password VARCHAR(256),
    first_name VARCHAR(128),
    last_name VARCHAR(128),
    middle_name VARCHAR(128),
    phone_number VARCHAR(20),
    date_of_birth DATE,
    OUT user_id INTEGER,
    OUT receptionist_id INTEGER)
AS $$
DECLARE
    inserted_user_id INTEGER;
BEGIN
    INSERT INTO Users (role_id, user_name, email, phone_number, password_hash)
    VALUES ((SELECT role_id FROM Roles WHERE role_name = 'receptionist'),
            CONCAT(first_name, ' ', COALESCE(middle_name, ''), ' ', last_name),
            email, phone_number, password)
    RETURNING Users.user_id INTO inserted_user_id;

    INSERT INTO Receptionists (user_id, first_name, last_name, middle_name, date_of_birth)
    VALUES(inserted_user_id, first_name, last_name, middle_name, date_of_birth)
    RETURNING Receptionists.receptionist_id INTO receptionist_id;

    user_id := inserted_user_id;
END;
$$ LANGUAGE plpgsql;

CALL create_receptionists_account(
        'bekarevstanislav@gmail.com',
        'ud115wov',
        'Станислав',
        'Бекарев',
        'Сергеевич',
        '+432764238422344',
        '2005-01-24',
        NULL,
        NULL);


-- procedures for deleting accounts
CREATE OR REPLACE PROCEDURE delete_patient_account(
    p_patient_id INTEGER)
AS $$
DECLARE
    deleted_patient_user_id INTEGER;
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Patients WHERE patient_id = p_patient_id) THEN
        RAISE EXCEPTION 'Patient % does not exists', p_patient_id;
    END IF;

    DELETE FROM Patients WHERE patient_id = p_patient_id RETURNING user_id INTO deleted_patient_user_id;

    IF NOT EXISTS(SELECT 1 FROM Users WHERE user_id = deleted_patient_user_id) THEN
        RAISE EXCEPTION 'User % related to patient % does not exists', deleted_patient_user_id, p_patient_id;
    END IF;

    DELETE FROM Users WHERE user_id = deleted_patient_user_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE delete_doctors_account(
    p_doctor_id INTEGER)
AS $$
DECLARE
    deleted_doctor_user_id INTEGER;
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Doctors WHERE doctor_id = p_doctor_id) THEN
        RAISE EXCEPTION 'Doctor % does not exists', p_doctor_id;
    END IF;

    DELETE FROM Doctors WHERE doctor_id = p_doctor_id RETURNING user_id INTO deleted_doctor_user_id;

    IF NOT EXISTS(SELECT 1 FROM Users WHERE user_id = deleted_doctor_user_id) THEN
        RAISE EXCEPTION 'User % related to doctor % does not exists', deleted_doctor_user_id, p_doctor_id;
    END IF;

    DELETE FROM Users WHERE user_id = deleted_doctor_user_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE delete_receptionists_account(
    p_receptionist_id INTEGER)
AS $$
DECLARE
    deleted_receptionist_user_id INTEGER;
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Receptionists WHERE receptionist_id = p_receptionist_id) THEN
        RAISE EXCEPTION 'Receptionist % does not exists', p_receptionist_id;
    END IF;

    DELETE FROM Receptionists WHERE receptionist_id = p_receptionist_id RETURNING user_id INTO deleted_receptionist_user_id;

    IF NOT EXISTS(SELECT 1 FROM Users WHERE user_id = deleted_receptionist_user_id) THEN
        RAISE EXCEPTION 'User % related to receptionists % does not exists', deleted_receptionist_user_id, p_receptionist_id;
    END IF;

    DELETE FROM Users WHERE user_id = deleted_receptionist_user_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE delete_patient_account(
    p_patient_id INTEGER)
AS $$
DECLARE
    deleted_patient_user_id INTEGER;
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Patients WHERE patient_id = p_patient_id) THEN
        RAISE EXCEPTION 'Patient % does not exists', p_patient_id;
    END IF;

    DELETE FROM Patients WHERE patient_id = p_patient_id RETURNING user_id INTO deleted_patient_user_id;

    IF NOT EXISTS(SELECT 1 FROM Users WHERE user_id = deleted_patient_user_id) THEN
        RAISE EXCEPTION 'User % related to patient % does not exists', deleted_patient_user_id, p_patient_id;
    END IF;

    DELETE FROM Users WHERE user_id = deleted_patient_user_id;
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

-- prodcedure for presccription
CREATE OR REPLACE PROCEDURE prescribe_medication(
    p_patient_id INTEGER,
    p_doctor_id INTEGER,
    p_medication VARCHAR(256),
    p_dosage VARCHAR(128),
    p_duration INTEGER
)
AS $$
DECLARE
    inserted_prescription_id INTEGER;
BEGIN
    INSERT INTO Prescriptions (patient_id, doctor_id, prescription_date, medication, dosage, duration)
    VALUES (p_patient_id, p_doctor_id, NOW(), p_medication, p_dosage, p_duration)
    RETURNING prescription_id INTO inserted_prescription_id;

    INSERT INTO Logs (user_id, action, action_date)
    VALUES (p_doctor_id, CONCAT('Prescribe prescription', ' ', inserted_prescription_id), now());
END;
$$ LANGUAGE plpgsql;

-- procedure for cancelling appointment
CREATE OR REPLACE PROCEDURE cancel_appointment(p_appointment_id INTEGER)
AS $$
DECLARE
BEGIN
    UPDATE Appointments
    SET is_approved = FALSE
    WHERE appointment_id = p_appointment_id;
END;
$$ LANGUAGE plpgsql;

-- procedure for creating Medical Result
CREATE OR REPLACE PROCEDURE create_medical_result(
    p_patient_id INTEGER,
    p_doctor_id INTEGER,
    p_appointment_id INTEGER,
    p_document_type VARCHAR(128),
    p_document_path TEXT,
    p_complaints TEXT,
    p_recommendations TEXT,
    p_conclusion TEXT
)
AS $$
DECLARE
    inserted_document_id INTEGER;
BEGIN
    INSERT INTO Documents (document_type, file_path)
    VALUES (p_document_type, p_document_path)
    RETURNING document_id INTO inserted_document_id;

    INSERT INTO Results (patient_id, doctor_id, document_id, appointment_id, complaints, recommendations, conclusion)
    VALUES (p_patient_id, p_doctor_id, p_appointment_id, p_complaints, p_recommendations, p_conclusion);

    INSERT INTO Logs (user_id, action, action_date)
    VALUES (p_doctor_id,'Created result', now());
END
$$ LANGUAGE plpgsql;

-- procedure for viewing procedures history of patient
CREATE OR REPLACE FUNCTION get_patient_procedures(p_patient_id INTEGER)
RETURNS TABLE(procedure_name VARCHAR, procedure_date DATE, status VARCHAR)
AS $$
BEGIN
    RETURN QUERY
        SELECT mp.procedure_name, ph.procedure_date, ph.status
        FROM ProceduresHistory ph
        JOIN MedicalProcedures mp ON ph.procedure_id = mp.procedure_id
        WHERE ph.patient_id = p_patient_id;
END;
$$ LANGUAGE plpgsql;

-- procedure for adding procedure in oricedures history
CREATE OR REPLACE PROCEDURE add_procedure_to_history(
    p_patient_id INTEGER,
    p_procedure_id INTEGER,
    p_procedure_date DATE,
    p_status VARCHAR(50)
)
AS $$
DECLARE
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Patients WHERE patient_id = p_patient_id) THEN
        RAISE EXCEPTION 'Patient with ID % does not exist.', p_patient_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM MedicalProcedures WHERE procedure_id = p_procedure_id) THEN
        RAISE EXCEPTION 'Procedure with ID % does not exist.', p_procedure_id;
    END IF;

    INSERT INTO ProceduresHistory (patient_id, procedure_id, procedure_date, status)
    VALUES (p_patient_id, p_procedure_id, p_procedure_date, p_status);
END;
$$ LANGUAGE plpgsql;

-- procedure for log_actions
CREATE OR REPLACE PROCEDURE log_user_action(p_user_id INTEGER, action TEXT)
AS $$
DECLARE
BEGIN
    INSERT INTO Logs (user_id, action, action_date)
    VALUES (p_user_id, action, now());
END;
$$ LANGUAGE plpgsql;

-- function for getting patient debt
CREATE OR REPLACE FUNCTION get_patient_debt(p_patient_id INTEGER)
RETURNS TABLE (total_debt NUMERIC, last_update TIMESTAMP)
AS $$
BEGIN
    RETURN QUERY
        SELECT total_debt, last_update
        FROM Debts
        WHERE patient_id = patient_id;
END;
$$ LANGUAGE plpgsql;

-- procedure for uploading documents for result
CREATE OR REPLACE PROCEDURE upload_document(document_type VARCHAR(128),
                                              file_path TEXT,
                                              p_result_id INTEGER)
AS $$
DECLARE
    inserted_document_id INTEGER;
BEGIN
    INSERT INTO Documents (document_type, file_path)
    VALUES (document_type, file_path)
    RETURNING document_id INTO inserted_document_id;

    UPDATE Results
    SET document_id = inserted_document_id
    WHERE result_id = p_result_id;
END;
$$ LANGUAGE plpgsql;

--function for getting statistics among service
CREATE OR REPLACE FUNCTION get_service_report(start_date DATE, end_date DATE)
RETURNS TABLE(service_name VARCHAR, total_usages BIGINT)
AS $$
BEGIN
    RETURN QUERY
        SELECT s.service_name as service_name, COUNT(a.appointment_id) as total_usages
        FROM Services s
        JOIN Appointments a ON s.service_id = a.service_id
        WHERE a.appointment_date BETWEEN start_date AND end_date
        GROUP BY s.service_name;
END;
$$ LANGUAGE plpgsql;

EXPLAIN SELECT * FROM get_service_report('2024-01-01', '2024-10-26');