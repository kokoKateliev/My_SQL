Тригери Задачи 
Като използвате базата от данни Flights: 
-- 1. Добавете нова колона num_pass към таблицата Flights, която ще съдържа броя на пътниците, потвърдили резервация за съответния полет. 
	ALTER TABLE FLIGHTS
ADD num_pass INT DEFAULT 0 WITH VALUES NOT NULL;

-- 2. Добавете нова колона num_book към таблицата Agencies, която ще съдържа броя на резервациите към съответната агенция. 
	ALTER TABLE Agencies 
ADD num_book INT DEFAULT 0 WITH VALUES NOT NULL;

-- 3. Създайте тригер за таблицата Bookings, който да се задейства при вмъкване на резервация в таблицата и да увеличава с единица броя на пътниците, 
-- потвърдили резервация за таблицата Flights, както и броя на резервациите към съответната агенция.
	CREATE TRIGGER trig_booking
ON Bookings
AFTER INSERT
AS
BEGIN
	UPDATE flights
	SET num_pass=num_pass+1
	WHERE fnumber IN ( SELECT flight_number FROM inserted WHERE status=1 );
	UPDATE agencies
	SET num_book= num_book+1
	WHERE name IN ( SELECT agency FROM inserted WHERE status = 1);
END;

-- 4. Създайте тригер за таблицата Bookings, който да се задейства при изтриване на резервация в таблицата и да намалява с единица броя на пътниците,
-- потвърдили резервация за таблицата Flights, както и броя на резервациите към съответната агенция. 


-- 5. Създайте тригер за таблицата Bookings, който да се задейства при обновяване на резервация в таблицата и да увеличава или намалява с единица броя 
-- на пътниците, потвърдили резервация за таблицата Flights при промяна на статуса на резервацията.
