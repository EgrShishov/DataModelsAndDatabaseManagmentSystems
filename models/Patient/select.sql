/*Patients */
SELECT
    first_name,
    last_name,
    middle_name,
    date_of_birth
FROM patients;

SELECT
    first_name,
    last_name,
    middle_name,
    date_of_birth,
    email,
    phone_number
FROM patients
JOIN users ON patients.user_id = users.user_id
WHERE patient_id = 1;
