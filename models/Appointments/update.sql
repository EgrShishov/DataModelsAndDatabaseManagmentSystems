UPDATE Appointments
SET is_approved = true
WHERE appointment_id = 1;

UPDATE Appointments
SET is_approved = false
WHERE appointment_id = 1;

UPDATE Appointments
SET (appointment_date, appointment_time) = ('2024-01-12', '09:30:00')
WHERE appointment_id = 1 AND is_approved = false;