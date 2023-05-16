Задача 1
-- а) Дефинирайте следните релации: 
-- Product (maker, model, type), където:  
--    модел е низ от точно 4 символа,  
--    производител е низ от точно 1 символ,  
--    тип е низ до 7 символа; 
-- Printer (code, model, price), където:  
--    код е цяло число,  
--    модел е низ от точно 4 символа,  
--    цена с точност до два знака след десетичната запетая;

CREATE TABLE Product1(
maker CHAR(1) NOT NULL,
model CHAR(4) NOT NULL,
type VARCHAR(7) NOT NULL
);

CREATE TABLE Printer1(
code INT NOT NULL,
model CHAR(4) NOT NULL,
price DECIMAL(5,2)
);


-- б) Добавете кортежи с примерни данни към новосъздадените релации. 
-- в) Добавете към релацията Printer атрибути:  
--    type - низ до 6 символа (забележка: type може да приема стойност 'laser', 'matrix' или 'jet'),  
--    color - низ от точно 1 символ, стойност по подразбиране 'n' (забележка: color може да приема стойност 'y' или 'n'). 

ALTER TABLE Printer1
ADD type VARCHAR(6) CONSTRAINT type_checker
CHECK (type IN ('laser', 'jet', 'matrix'));


ALTER TABLE Printer1
ADD color CHAR(1) NOT NULL DEFAULT 'n'
CONSTRAINT color_checker
CHECK (color IN ('y', 'n'));

-- г) Напишете заявка, която премахва атрибута price от релацията Printer. 
ALTER TABLE Printer
DROP COLUMN price;

-- д) Изтрийте релациите, които сте създали в Задача 1. 
DROP TABLE Printer1;
DROP TABLE Product1;
