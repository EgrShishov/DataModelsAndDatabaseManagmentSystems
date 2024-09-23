# МДиСУБД, ШИШОВ Егор Павлович, 253505
## Тема рарзрабатываемого проекта: Система управления здравоохранением
СУБД: PostgresSQL
## Функциональные требования проекта:             
- Аутентификация\авторизация с ипользованием access\refresh токенов
- Система ролей: пациент, ресепшионист, доктор
- Журналирование действий пользователя
- CRUD операции по управлению сущностями бд
- Хранение фотографий и blob-контента?
- Возможность записи на приём к врачу
- 

## Список таблиц: 
Таблица `Roles`:
 - `RoleId`: PRIMARY KEY: Уникальный идентификатор роли.
 - `RoleName`: VARCHAR(64) UNIQUE NOT NULL: Название роли (например, "Пациент", "Доктор", "Ресепшионист", "Администратор").
<hr></hr>

1. Таблица `Users`:
 - `UserName`: string, NOT_NULL
 - `Email`: string, UNIQUE, NOT_NULL
 - `PhoneNumber`: string, NOT_NULL
 - `IsEmailVerified`: BOOLEAN
 - `UserId`: string, PRIMARY_KEY
 - `PasswordHash`: string, NOT_NULL
 - `RefreshToken`: string

2. Таблица `Appointments`:
 - `AppointmentId`: string, PRIMARY_KEY
 - `PatientId`: string, FOREIGN_KEY
 - `DoctorId`: string, FOREIGN_KEY 
 - `OfficeId`: string, FOREIGN_KEY
 - `Time`: DateField, NOT_NULL
 - `IsApprooved`: BOOLEAN

3. Таблица `Offices`:
 - `OfficeId`: string, PRIMARY_KEY
 - `Adress`: string, NOT_NULL
 - `PhoneNumber`: string, NOT_NULL

4. Таблица `Services`:
 - `ServiceId`: string, PRIMARY_KEY
 - `ServiceName`: string, NOT_NULL
 - `IsActive`: BOOLEAN

5. Таблица `Doctors`:
 - `DoctorId`: string, PRIMARY_KEY
 - `UserId`: string, FOREIGN_KEY ON DELETE CASCADE
 - `FirstName`: string, NOT_NULL
 - `LastName`: string, NOT_NULL
 - `MiddleName`: string, NOT_NULL
 - `DateOfBirth`: Time, NOT_NULL
 - `SpecializationId`: string, FOREIGN_KEY
 - `CareerStartYear`: integer, NOT_NULL

6. Таблица `Patients`:
 - `PatientId`: string, PRIMARY_KEY
 - `UserId`: string, FOREIGN_KEY ON DELETE CASCADE
 - `FirstName`: string, NOT_NULL
 - `LastName`: string, NOT_NULL
 - `MiddleName`: string, NOT_NULL
 - `DateOfBirth`: Time, NOT_NULL

7. Таблица `Receptionists`:
 - `ReceptionistId`: string, PRIMARY_KEY
 - `UserId`: string, FOREIGN_KEY ON DELETE CASCADE
 - `FirstName`: string, NOT_NULL
 - `LastName`: string, NOT_NULL
 - `MiddleName`: string, NOT_NULL
 - `DateOfBirth`: Time, NOT_NULL

8. Таблица `Results`:
 - `ResultId`: string, PRIMARY_KEY
 - `PatientId`: string, FOREIGN_KEY 
 - `DoctorID`: string, FOREIGN_KEY
 - `Description`: string, NOT_NULL
 - `ResultDate`: Time, NOT_NULL

9. Таблица `Specializations`:
 - `SpecializationId`: string, PRIMARY_KEY
 - `SpecializationName`: string, NOT_NULL

10. Таблица `Logs`:
 - `LogId`: string, PRIMARY_KEY
 - `UserId`: string, FOREUGN_KEY
 - `Action`: string, NOT_NULL
 - `ActiodDate`: Time, NOT_NULL

11. Таблица `MedicalRecords`:
 - `RecordId`: string, PRIMARY_KEY
 - `PatientId`: string, FOREIGN_KEY ON DELETE CASCADE
 - `DoctorId`: string, FOREIGN_KEY
 - `AppointmentId`: string, FOREIGN_KEY
 - `Complaints`: string, NOT_NULL
 - `Recomendations`: string, NOT_NULL
 - `Conclusion`: string, NOT_NULL

12. Таблица `Payments`: 
- `PaymentId`: string, PRIMARY_KEY
- `Amount`: decimal(10,2), NOT_NULL
- `UserId`: string, FOREIGN_KEY ON DELETE CASCADE
- `PaymentDate`: Time, NOT_NULL 
 
13. Таблица `Prescriptions`:
- `PrescriptionId` (SERIAL PRIMARY KEY): Уникальный идентификатор рецепта.
- `PatientId` (INTEGER REFERENCES Patients(PatientId) ON DELETE CASCADE): Идентификатор пациента.
- `DoctorId` (INTEGER REFERENCES Doctors(DoctorId) ON DELETE CASCADE): Идентификатор врача, выписавшего рецепт.
- `PrescriptionDate` (TIMESTAMP NOT NULL): Дата и время выписки рецепта.
- `Medication` (TEXT NOT NULL): Название препарата.
- `Dosage` (TEXT NOT NULL): Информация о дозировке (например, 1 таблетка 2 раза в день).
- `Duration` (INTEGER NOT NULL): Длительность приема (например, 10 дней).

14. Таблица `Documents`:
 - `DocumentId`: string, PRIMARY_KEY
 - `FilePath`: string, NOT_NULL 

15. Таблица ``:
 - ``:

... TBA

