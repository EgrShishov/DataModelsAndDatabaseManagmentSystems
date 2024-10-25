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