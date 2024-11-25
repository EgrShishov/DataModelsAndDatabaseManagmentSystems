CREATE OR REPLACE PROCEDURE update_medical_procedure(
    p_procedure_id INTEGER,
    p_procedure_cost NUMERIC(10, 2),
    p_procedure_name VARCHAR(128),
    p_description TEXT,
    p_service_id INTEGER)
AS $$
DECLARE
BEGIN
    IF NOT EXISTS (SELECT 1 FROM MedicalProcedures WHERE procedure_id = p_procedure_id) THEN
        RAISE EXCEPTION 'Procedure with ID % does not exist.', p_procedure_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Services WHERE service_id = p_service_id) THEN
        RAISE EXCEPTION 'Service with ID % does not exist.', p_service_id;
    END IF;

    UPDATE MedicalProcedures
    SET procedure_cost = p_procedure_cost, description = p_description, procedure_name = p_procedure_name, service_id = p_service_id
    WHERE procedure_id = p_procedure_id;
END;
$$ LANGUAGE plpgsql