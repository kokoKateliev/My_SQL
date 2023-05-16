Извършете следните модификации в базата от данни Movies:
-- 1. Да се вмъкне информация за актрисата Nicole Kidman. За нея знаем само, че е родена на 20.06.1967. 
INSERT INTO moviestar(name,birthdate) VALUES ('Nicole Kidman', '1967-06-20');

-- 2. Да се изтрият всички продуценти с нетни активи под 30 милиона. 
DELETE FROM movieexec
WHERE networth < 30000000;

-- 3. Да се изтрие информацията за всички филмови звезди, за които не се знае адреса. 
DELETE FROM moviestar
WHERE address IS NULL;

Извършете следните модификации в базата от данни PC: 
-- 4. Използвайте две INSERT заявки. Съхранете в базата данни факта, че персонален компютър модел 1100 е направен от производителя C, има процесор 2400 MHz, RAM 2048 MB, твърд диск 500 GB, 52x оптично дисково устройство и струва $299. Нека новият компютър има код 12. Забележка: модел и CD са от тип низ. 
INSERT INTO pc VALUES(12,1100,2400,2048,500,'52x',299)
INSERT INTO product VALUES('C', 1100,'PC')

-- 5. Да се изтрие наличната информация в таблицата PC за компютри модел 1100. 
DELETE FROM pc
WHERE model = 1100;

-- 6. Да се изтрият от таблицата Laptop всички лаптопи, направени от производител, който не произвежда принтери. 
DELETE FROM laptop
WHERE model NOT IN (
SELECT model FROM product WHERE type = 'printer' AND maker IN (
SELECT DISTINCT maker FROM product WHERE type = 'PC'))

-- 7. Производител А купува производител B. На всички продукти на В променете производителя да бъде А.
UPDATE product 
SET maker='A'
WHERE maker='B'

-- 8. Да се намали наполовина цената на всеки компютър и да се добавят по 20 GB към всеки твърд диск. 
UPDATE pc
SET price=price/2, hd=hd+20

-- 9. За всеки лаптоп от производител B добавете по един инч към диагонала на екрана.
UPDATE laptop
SET screen=screen+1
WHERE model IN (SELECT model FROM product WHERE maker='B')

Извършете следните модификации в базата от данни Ships: 
-- 10. Два британски бойни кораба от класа Nelson - Nelson и Rodney - са били пуснати на вода едновременно през 1927 г. Имали са девет 16-инчови оръдия (bore) и водоизместимост от 34000 тона (displacement). Добавете тези факти към базата от данни. 
INSERT INTO ships VALUES('Nelson','Nelson',1927)
INSERT INTO ships VALUES('Rodney','Nelson',1927)
INSERT INTO classes VALUES ('Nelson', 'bb', 'Gt.Britan',9,16,34000)

-- 11. Изтрийте от таблицата Ships всички кораби, които са потънали в битка. 
DELETE FROM ships
WHERE name IN ( SELECT ship FROM outcomes WHERE result='sunk')

-- 12. Променете данните в релацията Classes така, че калибърът (bore) да се измерва в сантиметри (в момента е в инчове, 1 инч ~ 2.5 см) и водоизместимостта да се измерва в метрични тонове (1 м.т. = 1.1 т.)
UPDATE Classes
SET bore=(bore*2.5), displacement=(displacement*1.1)
