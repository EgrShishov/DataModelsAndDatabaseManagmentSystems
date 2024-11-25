-- function for recalculating debts after adding new payment
CREATE OR REPLACE FUNCTION recalculate_patient_debt()
RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Debts
        SET total_debt = total_debt - NEW.amount
        WHERE patient_id = NEW.patient_id;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_on_insert_payment
AFTER INSERT OR UPDATE OR DELETE ON Payments
FOR EACH ROW
EXECUTE FUNCTION recalculate_patient_debt();

-- after payment update invoice status
CREATE OR REPLACE FUNCTION update_invoice_status()
    RETURNS TRIGGER AS $$
    BEGIN
        UPDATE invoice
        SET is_paid = TRUE
        WHERE invoice_id = NEW.invoice_id;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER after_payment_insert
AFTER INSERT ON payments
FOR EACH ROW
EXECUTE FUNCTION update_invoice_status();

-- function for confirming appointment after paying
CREATE OR REPLACE FUNCTION confirm_appointment_after_payment()
RETURNS TRIGGER AS $$
    BEGIN
        UPDATE Appointments
        SET is_approved = True
        WHERE appointment_id = NEW.appointment_id;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_on_inserting_payment
AFTER INSERT ON Payments
FOR EACH ROW
EXECUTE FUNCTION confirm_appointment_after_payment();

-- function for updating user prescriptions
CREATE OR REPLACE FUNCTION update_prescriptions()
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO Prescriptions (patient_id, doctor_id, prescription_date, medication, dosage, duration)
        VALUES (NEW.patient_id, NEW.doctor_id, NEW.prescription_date, NEW.medication, NEW.dosage, NEW.duration);

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_on_insert_prescription
AFTER UPDATE ON Prescriptions
FOR EACH ROW
EXECUTE FUNCTION update_prescriptions();

-- trigger for notifying patients about new prescriptions
CREATE OR REPLACE FUNCTION send_prescription_notification()
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO Notifications (message, sender_id, reciever_id)
        VALUES ('Вам назначили новый рецепт: ' || NEW.medication,
                (SELECT user_id FROM Doctors WHERE doctor_id = NEW.doctor_id),
                (SELECT user_id FROM Patients WHERE patient_id = NEW.patient_id));

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_prescription_insert
AFTER INSERT ON Prescriptions
FOR EACH ROW
EXECUTE FUNCTION send_prescription_notification();

-- trigger for notifying patients about new results
CREATE OR REPLACE FUNCTION send_results_notification()
RETURNS TRIGGER AS $$
    BEGIN
        INSERT INTO Notifications (message, sender_id, reciever_id)
        VALUES ('Появились результаты анализов: ' || NEW.conclusion,
                (SELECT user_id FROM Doctors WHERE doctor_id = NEW.doctor_id),
                (SELECT user_id FROM Patients WHERE patient_id = NEW.patient_id));

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER on_results_insert
    AFTER INSERT ON Results
    FOR EACH ROW
EXECUTE FUNCTION send_results_notification();

-- checking duplicate appointments
CREATE OR REPLACE FUNCTION check_appointment_duplicates()
RETURNS TRIGGER AS $$
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM Appointments
            WHERE doctor_id = NEW.doctor_id
              AND appointment_date = new.appointment_date
              AND appointment_time = new.appointment_time
        ) THEN RAISE EXCEPTION 'Найдена встреча на это же дату и время';
        END IF;

        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_on_insert_or_update_appointments
BEFORE INSERT OR UPDATE ON Appointments
FOR EACH ROW
EXECUTE FUNCTION check_appointment_duplicates();

-- cancel appointment if not paid
CREATE OR REPLACE FUNCTION cancel_appointment_if_unpaid()
    RETURNS TRIGGER AS $$
BEGIN
    IF (SELECT total_amount FROM Invoice WHERE patient_id = NEW.patient_id) > 0 THEN
        UPDATE Appointments
        SET is_approved = false
        WHERE appointment_id = NEW.appointment_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_on_unpaid
    AFTER UPDATE ON Invoice
    FOR EACH ROW
    WHEN (NEW.total_amount > 0)
EXECUTE FUNCTION cancel_appointment_if_unpaid();

--tests
SELECT * FROM Appointments;

UPDATE Appointments
SET is_approved = TRUE
WHERE appointment_id = 41;

SELECT * FROM Invoice;

CREATE OR REPLACE FUNCTION get_patient_procedures(patientId INTEGER)
RETURNS TABLE (
  procedure_name VARCHAR,
  procedure_date DATE,
  status VARCHAR) AS $$
DECLARE

BEGIN
    IF NOT EXISTS (SELECT 1 FROM Patients WHERE patient_id = patientId) THEN
        RAISE EXCEPTION 'Patient with ID % does not exist.', patientId;
    END IF;

    RETURN QUERY
        SELECT
            mp.procedure_name,
            ph.procedure_date,
            ph.status
        FROM
            ProceduresHistory ph
                INNER JOIN
            MedicalProcedures mp ON ph.procedure_id = mp.procedure_id
        WHERE
            ph.patient_id = patientId;
END;
$$ LANGUAGE plpgsql;