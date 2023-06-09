Упражнение 1, Прости заявки

I.За базата от данни Movies 

-- 1. Напишете заявка, която извежда адреса на студио ‘Disney’ 
SELECT address
FROM Studio
WHERE name LIKE 'Disney';

-- 2. Напишете заявка, която извежда рождената дата на актьора Jack Nicholson
SELECT birthdate
FROM moviestar
WHERE name LIKE 'Jack Nicholson';

-- 3. Напишете заявка, която извежда имената на актьорите, които са участвали във филм от 1980 или във филм, в чието заглавие има думата ‘Knight’ 
SELECT starname
FROM starsin
WHERE movieyear = 1980 or movietitle LIKE '%Knight%';

-- 4. Напишете заявка, която извежда имената на продуцентите с нетни активи над 10 000 000 долара
SELECT name
FROM movieexec
WHERE networth > 10000000;

-- 5. Напишете заявка, която извежда имената на актьорите, които са мъже или живеят на Prefect Rd.
SELECT name
FROM moviestar
WHERE gender = 'M' or address = 'Perfect Rd.'



II.За базата от данни PC 

-- 1. Напишете заявка, която извежда модел, честота и размер на диска за всички персонални компютри с цена под 1200 долара. 
-- Задайте псевдоними за атрибутите честота и размер на диска, съответно MHz и GB 
SELECT model, speed AS MHz, hd AS GB
FROM pc
WHERE price < 1200

-- 
-- 2. Напишете заявка, която извежда производителите на принтери без повторения 
SELECT DISTINCT maker
FROM product
WHERE type = 'Printer'

-- 3. Напишете заявка, която извежда модел, размер на паметта, размер на екран за лаптопите, чиято цена е над 1000 долара 
SELECT model, hd, screen
FROM laptop
WHERE price > 1000;

-- 4. Напишете заявка, която извежда всички цветни принтери 
SELECT *
FROM printer
WHERE color = 'y';

-- 5. Напишете заявка, която извежда модел, честота и размер на диска за тези персонални компютри със CD 12x или 16x и цена под 2000 долара.
SELECT model, speed, hd
FROM pc
WHERE (cd = '12x' OR cd = '16x') AND price < 2000;


III.За базата от данни SHIPS 

-- 1. Напишете заявка, която извежда класа и страната за всички класове с помалко от 10 оръдия. 
SELECT class, country
FROM classes
WHERE numguns < 10;

-- 2. Напишете заявка, която извежда имената на корабите, пуснати на вода преди 1918. Задайте псевдоним shipName на колоната. 
SELECT name AS shipName
FROM ships
WHERE launched < 1918;

-- 3. Напишете заявка, която извежда имената на корабите потънали в битка и имената на съответните битки. 
SELECT ship, battle
FROM outcomes
WHERE result LIKE 'sunk';

-- 4. Напишете заявка, която извежда имената на корабите с име, съвпадащо с името на техния клас. 
SELECT name
FROM ships
WHERE name = class;

-- 5. Напишете заявка, която извежда имената на корабите, които започват с буквата R. 
SELECT name
FROM ships
WHERE name LIKE 'R%';

-- 6. Напишете заявка, която извежда имената на корабите, които съдържат 2 или повече думи.
SELECT name
FROM ships
WHERE name LIKE '% %';
