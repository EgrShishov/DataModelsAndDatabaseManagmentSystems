DELETE FROM MedicalProcedures
WHERE procedure_id = 1;

DELETE FROM MedicalProcedures
WHERE procedure_date < CURRENT_DATE AND procedure_time < CURRENT_TIME;
