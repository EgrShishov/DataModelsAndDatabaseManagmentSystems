CREATE DATABASE Clinic;

CREATE TABLE IF NOT EXISTS Roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(128) UNIQUE NOT NULL);

CREATE TABLE IF NOT EXISTS Users (
    user_id SERIAL PRIMARY KEY,
    role_id INTEGER REFERENCES Roles(role_id),
    user_name VARCHAR(128) NOT NULL,
    email VARCHAR(128) UNIQUE  NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    is_email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    password_hash TEXT,
    refresh_token TEXT);

CREATE TABLE IF NOT EXISTS Patients (
    patient_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id) ON DELETE CASCADE,
    first_name VARCHAR(128) NOT NULL,
    last_name VARCHAR(128) NOT NULL,
    middle_name VARCHAR(128),
    date_of_birth DATE NOT NULL);

CREATE TABLE IF NOT EXISTS Specializations (
    specialization_id SERIAL PRIMARY KEY,
    specialization_name VARCHAR(128) NOT NULL);

CREATE TABLE IF NOT EXISTS Doctors (
    doctor_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id) ON DELETE CASCADE,
    first_name VARCHAR(128) NOT NULL,
    last_name VARCHAR(128) NOT NULL,
    middle_name VARCHAR(128),
    date_of_birth DATE NOT NULL,
    specialization_id INTEGER REFERENCES Specializations(specialization_id) ON DELETE CASCADE,
    career_start_year INTEGER NOT NULL);

CREATE TABLE IF NOT EXISTS Receptionists (
    receptionist_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id) ON DELETE CASCADE ,
    first_name VARCHAR(128) NOT NULL,
    last_name VARCHAR(128) NOT NULL,
    middle_name VARCHAR(128),
    date_of_birth DATE NOT NULL);

CREATE TABLE IF NOT EXISTS ServiceCategory (
    service_category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(128) NOT NULL);

CREATE TABLE IF NOT EXISTS Services (
    service_id SERIAL PRIMARY KEY,
    service_category_id INTEGER REFERENCES ServiceCategory(service_category_id) ON DELETE SET NULL,
    service_name VARCHAR(128) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE);

CREATE TABLE IF NOT EXISTS Offices (
    office_id SERIAL PRIMARY KEY,
    country VARCHAR(256) NOT NULL,
    region VARCHAR(256) NOT NULL,
    city VARCHAR(256) NOT NULL,
    street VARCHAR(256) NOT NULL,
    street_number INTEGER NOT NULL,
    office_number INTEGER NOT NULL,
    phone_number VARCHAR(20) NOT NULL);

CREATE TABLE IF NOT EXISTS Appointments (
    appointment_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES Patients(patient_id) ON DELETE CASCADE,
    doctor_id INTEGER REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
    office_id INTEGER REFERENCES Offices(office_id) ON DELETE CASCADE,
    service_id INTEGER REFERENCES Services(service_id) ON DELETE CASCADE,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    is_approved BOOLEAN DEFAULT FALSE);

CREATE TABLE IF NOT EXISTS Documents (
    document_id SERIAL PRIMARY KEY,
    document_type VARCHAR(128) NOT NULL,
    file_path TEXT NOT NULL);

CREATE TABLE IF NOT EXISTS Results (
    result_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES Patients(patient_id),
    doctor_id INTEGER REFERENCES Doctors(doctor_id),
    document_id INTEGER REFERENCES Documents(document_id),
    appointment_id INTEGER REFERENCES Appointments(appointment_id),
    complaints TEXT NOT NULL,
    recommendations TEXT NOT NULL,
    conclusion TEXT NOT NULL);

CREATE TABLE IF NOT EXISTS Logs (
    log_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(user_id),
    action TEXT NOT NULL,
    action_date TIMESTAMP NOT NULL);

CREATE TABLE IF NOT EXISTS MedicalProcedures (
    procedure_id SERIAL PRIMARY KEY,
    procedure_name VARCHAR(128) NOT NULL,
    description TEXT NOT NULL,
    procedure_cost NUMERIC(10, 2) NOT NULL,
    procedure_time TIME NOT NULL,
    procedure_date DATE NOT NULL);

CREATE TABLE IF NOT EXISTS Payments (
    payment_id SERIAL PRIMARY KEY,
    appointment_id INTEGER REFERENCES Appointments(appointment_id),
    amount NUMERIC(10, 2) NOT NULL,
    invoice_id INTEGER REFERENCES Invoice(invoice_id) ON DELETE CASCADE,
    payment_date TIMESTAMP NOT NULL);

CREATE TABLE IF NOT EXISTS Prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES Patients(patient_id) ON DELETE CASCADE,
    doctor_id INTEGER REFERENCES Doctors(doctor_id) ON DELETE CASCADE,
    prescription_date TIMESTAMP NOT NULL,
    medication VARCHAR(256) NOT NULL,
    dosage VARCHAR(128) NOT NULL,
    duration INTEGER NOT NULL);

CREATE TABLE IF NOT EXISTS AppointmentProcedures (
    appointment_id INTEGER NOT NULL REFERENCES Appointments(appointment_id) ON DELETE CASCADE,
    procedure_id INTEGER NOT NULL REFERENCES MedicalProcedures(procedure_id) ON DELETE CASCADE,
    PRIMARY KEY(appointment_id, procedure_id)
);

-- new tables (need to think)
CREATE TABLE IF NOT EXISTS Invoice (
    invoice_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES Patients(patient_id) ON DELETE SET NULL,
    appointment_id INTEGER REFERENCES Appointments(appointment_id) ON DELETE SET NULL,
    total_amount NUMERIC(10, 2) NOT NULL DEFAULT 0,
    is_paid BOOLEAN NOT NULL DEFAULT FALSE,
    invoice_date DATE NOT NULL DEFAULT now(),
    invoice_time TIME NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS Debts (
    debt_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES Patients(patient_id) ON DELETE SET NULL,
    total_debt NUMERIC(10, 2) NOT NULL DEFAULT 0,
    last_update TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS Notifications (
    notification_id SERIAL PRIMARY KEY,
    message TEXT NOT NULL,
    sender_id INTEGER REFERENCES Users(user_id) ON DELETE SET NULL,
    reciever_id INTEGER REFERENCES Users(user_id) ON DELETE CASCADE,
    notification_date TIMESTAMP NOT NULL DEFAULT(now()),
    is_read BOOLEAN NOT NULL DEFAULT FALSE
);

-- for integration with oAuthServices
ALTER TABLE Users ADD COLUMN google_id TEXT;
ALTER TABLE Users ADD COLUMN facebook_ud TEXT;
-- alter table history
ALTER TABLE Payments ADD COLUMN invoice_id INTEGER REFERENCES Invoice(invoice_id);
ALTER TABLE Payments DROP COLUMN user_id;

--new tables
CREATE TABLE IF NOT EXISTS ProceduresHistory(
    history_id SERIAL PRIMARY KEY,
    patient_id INTEGER REFERENCES Patients(patient_id) ON DELETE CASCADE,
    procedure_id INTEGER REFERENCES MedicalProcedures(procedure_id) ON DELETE CASCADE,
    procedure_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL --'completed', 'pending', 'cancelled'
);