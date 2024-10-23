/*payments for user*/
SELECT
    p.amount,
    p.payment_date,
    a.appointment_date
FROM Payments AS p JOIN Appointments AS a ON (p.appointment_id=a.appointment_id)
WHERE p.user_id = 1;

/*SELECT
    pt.patient_id,
    pt.last_name,
    pt.first_name,
    COALESCE(SUM(SELECT procedure_cost FROM MedicalProcedures WHERE patient_id=pt.patient_id) AS invoices), 0) as total_invoices
COALESCE(SUM(p.amount),0) as total_payments,
FROM Payments AS pm
    JOIN Patients AS p ON (pm.user_id=p.user_id)
    JOIN Appointments AS a ON (a.patient_id=p.patient_id)
    LEFT JOIN MedicalProcedures AS mp ON (mp.patient_id=p.patient_id)
SELECT
GROUP BY pt.patient_id, pt.first_name, pt.last_name;*/