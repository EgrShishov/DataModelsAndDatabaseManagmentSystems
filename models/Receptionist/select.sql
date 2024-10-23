SELECT
    first_name,
    last_name,
    middle_name,
    date_of_birth
FROM Receptionists
ORDER BY last_name;

SELECT
    first_name,
    last_name,
    middle_name,
    phone_number,
    email
FROM receptionists
JOIN users ON receptionists.user_id = users.user_id
WHERE receptionist_id = 1;

