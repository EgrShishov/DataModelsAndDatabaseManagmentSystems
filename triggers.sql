-- user creating and hashing password trigger
CREATE EXTENSION IF NOT EXISTS pgcrypto; --for bcrypt

CREATE OR REPLACE FUNCTION compare_passwords(id INTEGER, given_password TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    stored_password_hash TEXT;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Users WHERE user_id = id) THEN
        RAISE EXCEPTION 'User % does not exists', id;
    END IF;

    SELECT password_hash FROM Users WHERE user_id = id INTO stored_password_hash;

    IF crypt(given_password, stored_password_hash) = stored_password_hash THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION hash_password()
RETURNS TRIGGER AS $$
    BEGIN
        IF NEW.password_hash IS NOT NULL THEN
            NEW.password_hash:= crypt(NEW.password_hash, gen_salt('bf'));
        END IF;

    RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_user_created
BEFORE INSERT ON Users
FOR EACH ROW
EXECUTE FUNCTION hash_password();

--user logging triggers
CREATE OR REPLACE TRIGGER trigger_on_user_created
AFTER INSERT ON Users
FOR EACH ROW
EXECUTE FUNCTION log_action();

CREATE OR REPLACE TRIGGER trigger_on_user_updated
AFTER UPDATE ON Users
FOR EACH ROW
EXECUTE FUNCTION log_action();

CREATE OR REPLACE TRIGGER trigger_on_user_deleted
AFTER DELETE ON Users
FOR EACH ROW
EXECUTE FUNCTION log_action();

CREATE OR REPLACE FUNCTION log_action()
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO Logs (user_id, action, action_date)
        VALUES (NEW.user_id, NEW.action, NEW.action_date);

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;


--appointment created trigger
CREATE OR REPLACE FUNCTION log_appointment_creation()
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO Logs(user_id, action, action_date)
        VALUES (NEW.user_id, NEW.action, NEW.action_date);

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_on_appointment_created
AFTER INSERT ON Appointments
FOR EACH ROW
EXECUTE FUNCTION log_appointment_creation();

CREATE OR REPLACE FUNCTION refresh_patients_appointments_summary()
RETURNS TRIGGER AS $$
    BEGIN
        REFRESH MATERIALIZED VIEW patientsappointmentssummary;
        REFRESH MATERIALIZED VIEW patientlatestresults;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_view
AFTER INSERT OR UPDATE OR DELETE ON Appointments
FOR EACH ROW
EXECUTE FUNCTION refresh_patients_appointments_summary();

CREATE OR REPLACE FUNCTION refresh_patient_latest_results()
RETURNS TRIGGER AS $$
    BEGIN
        REFRESH MATERIALIZED VIEW patientsappointmentssummary;
        REFRESH MATERIALIZED VIEW patientlatestresults;
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER update_latest_results_view
AFTER INSERT OR UPDATE OR DELETE ON Patients
FOR EACH ROW
EXECUTE FUNCTION refresh_patient_latest_results();

CREATE OR REPLACE FUNCTION email_checking()
RETURNS TRIGGER AS $$
    BEGIN
        IF NOT EXISTS(SELECT * FROM users
        WHERE NEW.email ~* '%@') THEN RAISE EXCEPTION 'There must be incorrect email pattern';
        END IF;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER email_verify_trigger
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION email_checking();