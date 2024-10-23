SELECT * FROM Users;

SELECT * FROM Users
WHERE user_id = 1;

SELECT * FROM Users
WHERE email = 'johndoe@example.com';

SELECT
    user_id,
    role_name,
    user_name,
    email,
    phone_number
FROM Users
JOIN Roles USING(role_id)
WHERE user_id = 1;

SELECT
    user_id,
    role_name,
    user_name,
    email,
    phone_number
FROM Users
         JOIN Roles USING(role_id)
WHERE email = 'email@example.com';

SELECT
    user_id,
    role_name,
    user_name,
    email,
    phone_number
FROM Users
         JOIN Roles USING(role_id)
WHERE role_name = 'Doctor';
