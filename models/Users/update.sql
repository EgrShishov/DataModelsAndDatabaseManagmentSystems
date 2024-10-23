UPDATE Users
SET user_name = 'John Smith',
    email = 'johnsmith@example.com',
    phone_number = '+0987654321',
    is_email_verified = TRUE
WHERE user_id = 1;

UPDATE Users
SET password_hash = 'new_hashed_password'
WHERE user_id = 1;

UPDATE Users
SET refresh_token = 'new_refresh_token'
WHERE user_id = 1;

UPDATE Users
SET role_id = 2
WHERE user_id = 1;

