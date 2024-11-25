SELECT * FROM Users;

SELECT * FROM Users
WHERE user_id = 1;

SELECT * FROM Users
WHERE email = 'johndoe@example.com';

ALTER TABLE Users ADD COLUMN photo_url VARCHAR NOT NULL DEFAULT 'http://localhost:${process.env.PORT || 5000}/uploads/default-profile-image.png';
ALTER TABLE Users ADD COLUMN google_id VARCHAR UNIQUE;

SELECT
    user_id,
    role_name,
    user_name,
    email,
    phone_number,
    photo_url
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
