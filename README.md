# МДиСУБД, ШИШОВ Егор Павлович, 253505
## Тема рарзрабатываемого проекта: Система управления здравоохранением
СУБД: PostgresSQL
## Функциональные требования проекта:             
- Аутентификация\авторизация с ипользованием access\refresh токенов
- Система ролей: пациент, ресепшионист, доктор
- Журналирование действий пользователя
- CRUD операции для всех сущностей БД
- Возможность записи на приём к врачу
- Возможность выставления счетов пациентам за медицинские услуги и процедуры.
- Возможность пациента видеть все свои платежи и задолженности.

## Список таблиц: 
## 1. Таблица `Roles`:
- `RoleId`: SERIAL PRIMARY KEY - Уникальный идентификатор роли.
- `RoleName`: VARCHAR(128) UNIQUE NOT NULL - Название роли (например, "Пациент", "Доктор", "Ресепшионист").

## 2. Таблица `Users`:
- `UserId`: SERIAL PRIMARY KEY - Уникальный идентификатор пользователя.
- `UserName`: VARCHAR(128) NOT NULL - Имя пользователя.
- `Email`: VARCHAR(128) UNIQUE NOT NULL - Адрес электронной почты пользователя.
- `PhoneNumber`: VARCHAR(20) NOT NULL - Мобильный телефон пользователя.
- `IsEmailVerified`: BOOLEAN DEFAULT FALSE - Подтверждена ли почта пользователя.
- `PasswordHash`: TEXT NOT NULL - Хэш пароля.
- `RefreshToken`: TEXT - Токен для обновления сеансов.

## 3. Таблица `Appointments`:
- `AppointmentId`: SERIAL PRIMARY KEY - Уникальный идентификатор записи.
- `PatientId`: INTEGER REFERENCES Users(UserId) ON DELETE CASCADE - Идентификатор пациента.
- `DoctorId`: INTEGER REFERENCES Users(UserId) ON DELETE CASCADE - Идентификатор доктора.
- `OfficeId`: INTEGER REFERENCES Offices(OfficeId) ON DELETE CASCADE - Идентификатор офиса.
- `Time`: TIMESTAMP NOT NULL - Время приема.
- `IsApproved`: BOOLEAN DEFAULT FALSE - Статус одобрения заявки.

## 4. Таблица `Offices`:
- `OfficeId`: SERIAL PRIMARY KEY - Уникальный идентификатор офиса.
- `Address`: VARCHAR(256) NOT NULL - Адрес офиса.
- `PhoneNumber`: VARCHAR(20) NOT NULL - Номер телефона офиса.

## 5. Таблица `Services`:
- `ServiceId`: SERIAL PRIMARY KEY - Уникальный идентификатор услуги.
- `ServiceName`: VARCHAR(128) NOT NULL - Название услуги.
- `IsActive`: BOOLEAN DEFAULT TRUE - Доступна ли услуга в данный момент.

## 6. Таблица `Doctors`:
- `DoctorId`: SERIAL PRIMARY KEY - Уникальный идентификатор доктора.
- `UserId`: INTEGER REFERENCES Users(UserId) ON DELETE CASCADE - Идентификатор пользователя.
- `FirstName`: VARCHAR(128) NOT NULL - Имя доктора.
- `LastName`: VARCHAR(128) NOT NULL - Фамилия доктора.
- `MiddleName`: VARCHAR(128) NOT NULL - Отчество доктора.
- `DateOfBirth`: DATE NOT NULL - Дата рождения доктора.
- `SpecializationId`: INTEGER REFERENCES Specializations(SpecializationId) ON DELETE CASCADE - Идентификатор специальности доктора.
- `CareerStartYear`: INTEGER NOT NULL - Год начала карьеры.

## 7. Таблица `Patients`:
- `PatientId`: SERIAL PRIMARY KEY - Уникальный идентификатор пациента.
- `UserId`: INTEGER REFERENCES Users(UserId) ON DELETE CASCADE - Идентификатор пользователя.
- `FirstName`: VARCHAR(128) NOT NULL - Имя пациента.
- `LastName`: VARCHAR(128) NOT NULL - Фамилия пациента.
- `MiddleName`: VARCHAR(128) NOT NULL - Отчество пациента.
- `DateOfBirth`: DATE NOT NULL - Дата рождения пациента.

## 8. Таблица `Receptionists`:
- `ReceptionistId`: SERIAL PRIMARY KEY - Уникальный идентификатор ресепшиониста.
- `UserId`: INTEGER REFERENCES Users(UserId) ON DELETE CASCADE - Идентификатор пользователя.
- `FirstName`: VARCHAR(128) NOT NULL - Имя ресепшиониста.
- `LastName`: VARCHAR(128) NOT NULL - Фамилия ресепшиониста.
- `MiddleName`: VARCHAR(128) NOT NULL - Отчество ресепшиониста.
- `DateOfBirth`: DATE NOT NULL - Дата рождения ресепшиониста.

## 9. Таблица `Results`:
- `ResultId`: SERIAL PRIMARY KEY - Уникальный идентификатор результата обследования.
- `PatientId`: INTEGER REFERENCES Patients(PatientId) - Идентификатор пациента.
- `DoctorId`: INTEGER REFERENCES Doctors(DoctorId) - Идентификатор доктора.
- `AppointmentId`: INTEGER REFERENCES Appointments(AppointmentId) - Идентификатор приёма.
- `Complaints`: TEXT NOT NULL - Жалобы пациента.
- `Recommendations`: TEXT NOT NULL - Рекомендации врача.
- `Conclusion`: TEXT NOT NULL - Заключение врача.

## 10. Таблица `Specializations`:
- `SpecializationId`: SERIAL PRIMARY KEY - Уникальный идентификатор специальности.
- `SpecializationName`: VARCHAR(128) NOT NULL - Название медицинской специальности.

## 11. Таблица `Logs`:
- `LogId`: SERIAL PRIMARY KEY - Уникальный идентификатор лог-записи.
- `UserId`: INTEGER REFERENCES Users(UserId) - Идентификатор пользователя.
- `Action`: TEXT NOT NULL - Описание действия (например, запись на прием, добавление результатов и т.д.).
- `ActionDate`: TIMESTAMP NOT NULL - Время, когда произошло действие.

## 12. Таблица `MedicalProcedures`:
- `ProcedureId`: SERIAL PRIMARY KEY - Уникальный идентификатор медицинской процедуры.
- `ProcedureName`: VARCHAR(128) NOT NULL - Название медицинской процедуры (например, "Удаление аппендикса").
- `Description`: TEXT NOT NULL - Описание процедуры.
- `ProcedureCost`: NUMERIC(10, 2) NOT NULL - Стоимость процедуры.
- `DoctorId`: INTEGER REFERENCES Doctors(DoctorId) ON DELETE CASCADE - Идентификатор врача, который проводит процедуру.
- `PatientId`: INTEGER REFERENCES Patients(PatientId) ON DELETE CASCADE - Идентификатор пациента, которому выполняется процедура.
- `ProcedureDate`: TIMESTAMP NOT NULL - Дата и время проведения процедуры.

## 13. Таблица `Payments`:
- `PaymentId`: SERIAL PRIMARY KEY - Уникальный идентификатор платежа.
- `AppointmentId`: INTEGER REFERENCES Appointments(AppointmentId) - Идентификатор платного приёма\консультации.
- `Amount`: NUMERIC(10, 2) NOT NULL - Сумма платежа.
- `UserId`: INTEGER REFERENCES Users(UserId) ON DELETE CASCADE - Идентификатор пользователя.
- `PaymentDate`: TIMESTAMP NOT NULL - Дата и время платежа.

## 14. Таблица `Prescriptions`:
- `PrescriptionId`: SERIAL PRIMARY KEY - Уникальный идентификатор рецепта.
- `PatientId`: INTEGER REFERENCES Patients(PatientId) ON DELETE CASCADE - Идентификатор пациента.
- `DoctorId`: INTEGER REFERENCES Doctors(DoctorId) ON DELETE CASCADE - Идентификатор врача, выписавшего рецепт.
- `PrescriptionDate`: TIMESTAMP NOT NULL - Дата и время выписки рецепта.
- `Medication`: VARCHAR(256) NOT NULL - Название препарата.
- `Dosage`: VARCHAR(128) NOT NULL - Информация о дозировке (например, 1 таблетка 2 раза в день).
- `Duration`: INTEGER NOT NULL - Длительность приема (например, 10 дней).

## 15. Таблица `Documents`:
- `DocumentId`: SERIAL PRIMARY KEY - Уникальный идентификатор документов.
- `DocumentType`: VARCHAR(128) NOT NULL - Тип документа (например, результаты анализов).
- `FilePath`: TEXT NOT NULL - Путь к документам в файловой системе.

## 16. Таблица `ServiceCategories`:
- `ServiceCategoryId`: SERIAL PRIMARY KEY - Уникальный идентификатор категории.
- `CategoryName`: VARCHAR(128) NOT NULL - Название категории.

