/*change service status*/
UPDATE Services
SET is_active = NOT is_active
WHERE service_id = 1;

/*update service name*/
UPDATE Services
SET service_name = 'new service name'
WHERE service_id = 1;