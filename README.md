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
- Просмотр и управление записями на приём
- Просмотр списка назначенных встреч с пациентами.
- Подтверждение или отмена приёма.
- Просмотр деталей приёма (история болезни, жалобы пациента).
- Просмотр медицинской истории пациента.
- Добавление, редактирование и обновление диагнозов, жалоб, заключений и рекомендаций.
- Загрузка результатов анализов и обследований.
- Назначение рецептов для пациента (с указанием дозировки, частоты и продолжительности лечения).
- Просмотр и управление ранее назначенными рецептами.
- Назначение и добавление медицинских процедур.
- Просмотр результатов анализов и обследований.
- Ввод результатов анализов, заключений и других документов в электронную историю болезни.
- Выгрузка PDF-результатов и документов для пациента.
- Просмотр расписания доступных докторов.
- Отмена или перенос запланированных встреч.
- Просмотр истории приёмов и их статусов (подтверждены или отменены).
- Просмотр собственной медицинской истории (записи, диагнозы, рекомендации врачей).
- Просмотр истории приёмов и обследований.
- Доступ к результатам анализов и обследований.
- Возможность скачивания медицинских документов (например, результаты анализов, заключения).
- Просмотр счетов за оказанные услуги.
- Регистрация новых пациентов, внесение их данных в систему (например, контактные данные, дата рождения, полис страхования).
<hr></hr>

## Таблицы базы данных: 
![alt text](https://github.com/EgrShishov/DataModelsAndDatabaseManagmentSystems/blob/main/diagram_normalized.png)

## 1. Таблица `Roles`:
- `RoleId`: SERIAL PRIMARY KEY - Уникальный идентификатор роли.
- `RoleName`: VARCHAR(128) UNIQUE NOT NULL - Название роли (например, "Пациент", "Доктор", "Ресепшионист").

## 2. Таблица `Users`:
- `UserId`: SERIAL PRIMARY KEY - Уникальный идентификатор пользователя.
- `RoleId`: INTEGER REFERENCES Roles(RoleId) - Идентификатор роли пользователя.
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
- `ServiceId`: INTEGER REFRENCES Services(ServiceId) ON DELEET CASCADE - Идентификатор сервиса.
- `AppointmentDate`: DATE NOT NULL - Дата приёма.
- `AppointmentTime`: TIME NOT NULL - Время приема.
- `IsApproved`: BOOLEAN DEFAULT FALSE - Статус одобрения заявки.

## 4. Таблица `Offices`:
- `OfficeId`: SERIAL PRIMARY KEY - Уникальный идентификатор офиса.
- `Country`: VARCHAR(256) NOT NULL - Страна нахождения оффиса.
- `Region`: VARCHAR(256) NOT NULL - Область.
- `City`: VARCHAR(256) NOT NULL - Город.
- `Street`: VARCHAR(256) NOT NULL - Улица оффиса.
- `StreetNumber`: INTEGER NOT NULL - Номер дома.
- `OfficeNumber`: INTEGER NOT NULL - Номер оффисного блока.
- `PhoneNumber`: VARCHAR(20) NOT NULL - Номер телефона офиса.

## 5. Таблица `Services`:
- `ServiceId`: SERIAL PRIMARY KEY - Уникальный идентификатор услуги.
- `ServiceCategoryId`: INTEGER REFERENCES ON ServiceCategory(ServiceCategoryId) - Идентификатор категории сервиса (например, анализы)
- `ServiceName`: VARCHAR(128) NOT NULL - Название услуги.
- `IsActive`: BOOLEAN DEFAULT TRUE - Доступна ли услуга в данный момент.

## 6. Таблица `Doctors`:
- `DoctorId`: SERIAL PRIMARY KEY - Уникальный идентификатор доктора.
- `UserId`: INTEGER UNIQUE REFERENCES Users(UserId) ON DELETE CASCADE - Идентификатор пользователя.
- `FirstName`: VARCHAR(128) NOT NULL - Имя доктора.
- `LastName`: VARCHAR(128) NOT NULL - Фамилия доктора.
- `MiddleName`: VARCHAR(128) NOT NULL - Отчество доктора.
- `DateOfBirth`: DATE NOT NULL - Дата рождения доктора.
- `SpecializationId`: INTEGER REFERENCES Specializations(SpecializationId) ON DELETE CASCADE - Идентификатор специальности доктора.
- `CareerStartYear`: INTEGER NOT NULL - Год начала карьеры.

## 7. Таблица `Patients`:
- `PatientId`: SERIAL PRIMARY KEY - Уникальный идентификатор пациента.
- `UserId`: INTEGER UNIQUE REFERENCES Users(UserId) ON DELETE CASCADE - Идентификатор пользователя.
- `FirstName`: VARCHAR(128) NOT NULL - Имя пациента.
- `LastName`: VARCHAR(128) NOT NULL - Фамилия пациента.
- `MiddleName`: VARCHAR(128) NOT NULL - Отчество пациента.
- `DateOfBirth`: DATE NOT NULL - Дата рождения пациента.

## 8. Таблица `Receptionists`:
- `ReceptionistId`: SERIAL PRIMARY KEY - Уникальный идентификатор ресепшиониста.
- `UserId`: INTEGER UNIQUE REFERENCES Users(UserId) ON DELETE CASCADE - Идентификатор пользователя.
- `FirstName`: VARCHAR(128) NOT NULL - Имя ресепшиониста.
- `LastName`: VARCHAR(128) NOT NULL - Фамилия ресепшиониста.
- `MiddleName`: VARCHAR(128) NOT NULL - Отчество ресепшиониста.
- `DateOfBirth`: DATE NOT NULL - Дата рождения ресепшиониста.

## 9. Таблица `Results`:
- `ResultId`: SERIAL PRIMARY KEY - Уникальный идентификатор результата обследования.
- `PatientId`: INTEGER REFERENCES Patients(PatientId) - Идентификатор пациента.
- `DoctorId`: INTEGER REFERENCES Doctors(DoctorId) - Идентификатор доктора.
- `DocumentId`: INTEGER REFERENCES Documents(DocumentId) - Идентификатор результатов анализов в PDF формате.
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
- `ProcedureTime`: TIME NOT NULL - Время проведения процедуры.
- `ProcedureDate`: DATE NOT NULL - Дата проведения процедуры.

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

## 17. Таблица `AppointmentProcedures`:
- `AppointmentId`: INTEGER REFERENCES Appointments(AppointmentId) ON DELETE CASCADE - Идентификатор приёма.
- `ProcedureId`: INTEGER REFERENCES Procedures(ProcedureId) ON DELETE CASCADE - Идентификатор процедуры
PRIMARY KEY(appointment_id, procedure_id) - Для обеспечения  уникальности двух записей.
Таблица Invoices

## 18. Таблица `Invoices`:
### Хранит информацию о счетах-фактурах, выставленных пациентам за медицинские услуги. Каждый счёт связан с конкретным приёмом и пациентом.
- `InvoiceId`: SERIAL PRIMARY KEY - Уникальный идентификатор счёта.
- `PatientId`: INTEGER REFERENCES Patients(PatientId) ON DELETE CASCADE - Идентификатор пациента.
- `AppointmentId`: INTEGER REFERENCES Appointments(AppointmentId) - Идентификатор приёма, за который выставлен счёт.
- `TotalAmount`: NUMERIC(10, 2) NOT NULL - Общая сумма счёта.
- `IsPaid`: BOOLEAN DEFAULT FALSE - Статус оплаты (оплачено/не оплачено).
- `InvoiceDate`: TIMESTAMP DEFAULT NOW() - Дата и время выставления счёта.

## 19. Таблица `Debts`:
### Отслеживает задолженность пациентов перед клиникой. Она хранит общую сумму задолженности и дату последнего обновления.
- `DebtId`: SERIAL PRIMARY KEY - Уникальный идентификатор задолженности.
- `PatientId`: INTEGER REFERENCES Patients(PatientId) ON DELETE CASCADE - Идентификатор пациента.
- `TotalDebt`: NUMERIC(10, 2) NOT NULL DEFAULT 0 - Общая сумма задолженности.
- `LastUpdate`: TIMESTAMP DEFAULT NOW() - Дата последнего обновления записи о задолженности.

## 20. Таблица `Notifications`:
### Хранит уведомления о действиях в системе, отправленных пользователям (например, о назначении нового рецепта, обновлении результатов анализов и т.д.).
- `NotificationId`: SERIAL PRIMARY KEY - Уникальный идентификатор уведомления.
- `SenderId`: INTEGER REFERENCES Users(UserId) ON DELETE SET NULL - Идентификатор отправителя уведомления.
- `ReceiverId`: INTEGER REFERENCES Users(UserId) ON DELETE CASCADE - Идентификатор получателя уведомления.
- `Message`: TEXT NOT NULL - Текст уведомления.
- `IsRead`: BOOLEAN DEFAULT FALSE - Статус прочтения уведомления (прочитано/не прочитано).
- `NotificationDate`: TIMESTAMP DEFAULT NOW() - Дата и время отправки уведомления.

## 21. Таблица `ProceduresHistory`:
- `HistoryId`: SERIAL PRIMARY KEY - Уникальный идентификатор записи.
- `PatientId`: INTEGER REFERENCES Patients(patient_id) ON DELETE CASCADE - Идентификатор пациента.
- `ProcedureId`: INTEGER REFERENCES MedicalProcedures(procedure_id) ON DELETE CASCADE - Идентификатор процедуры.
- `ProcedureDate`: DATE NOT NULL - Дата проведения процедуры.
- `Status`: VARCHAR(50) NOT NULL - Статус процедуры
