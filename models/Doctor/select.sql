/* all doctors with specializations*/
SELECT
    doctors.first_name,
    doctors.last_name,
    doctors.middle_name,
    doctors.career_start_year,
    s.specialization_name
FROM Doctors as doctors
     JOIN Specializations as s ON doctors.specialization_id = s.specialization_id;

/*find by specialization*/
SELECT
    doctors.first_name,
    doctors.last_name,
    doctors.middle_name,
    doctors.career_start_year,
    s.specialization_name
FROM Doctors as doctors
         JOIN Specializations as s ON doctors.specialization_id = s.specialization_id
WHERE s.specialization_name = 'Cardilogist';

/*doctors with upcoming appointments*/
SELECT *
FROM Doctors
WHERE doctor_id IN (
    SELECT doctor_id
    FROM Appointments
    WHERE appointment_date >= current_date
);

SELECT
    d.first_name,
    d.last_name,
    d.middle_name,
    s.specialization_name
FROM Doctors as d
LEFT JOIN Specializations as s ON s.specialization_id = d.specialization_id;
