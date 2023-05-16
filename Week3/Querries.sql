Упражнение 3 Подзаявки

I.За базата от данни Movies 
-- 1. Напишете заявка, която извежда имената на актрисите, които са също и продуценти с нетни активи над 10 милиона. 
SELECT moviestar.name
FROM moviestar 
WHERE gender LIKE 'F' AND moviestar.name IN 
(SELECT name FROM movieexec WHERE networth > 10000000)

-- 2. Напишете заявка, която извежда имената на тези актьори (мъже и жени), които не са продуценти. 
SELECT moviestar.name
FROM moviestar 
WHERE moviestar.name NOT IN (SELECT name FROM movieexec)

-- 3. Напишете заявка, която извежда имената на всички филми с дължина, по-голяма от дължината на филма ‘Star Wars’ 
SELECT title
FROM movie 
WHERE length > (SELECT length FROM movie WHERE title LIKE 'Star Wars')

-- 4. Напишете заявка, която извежда имената на продуцентите и имената на филмите за всички филми, 
-- които са продуцирани от продуценти с нетни активи по-големи от тези на ‘Merv Griffin’
SELECT movieexec.name, title
FROM movieexec JOIN movie ON cert#=producerc#
WHERE networth > (SELECT networth FROM movieexec WHERE name LIKE 'Merv Griffin')

II.За базата от данни PC 
-- 1. Напишете заявка, която извежда производителите на персонални компютри с честота над 500.
SELECT maker 
FROM product 
WHERE model IN (SELECT model FROM pc WHERE speed > 500)

-- 2. Напишете заявка, която извежда код, модел и цена на принтерите с най-висока цена. 
SELECT code, model, price  
FROM printer
WHERE price >= ALL (SELECT price FROM printer)

-- 3. Напишете заявка, която извежда лаптопите, чиято честота е по-ниска от честотата на всички персонални компютри. 
SELECT *
FROM laptop
WHERE speed < ALL  (SELECT speed FROM pc)

-- 4. Напишете заявка, която извежда модела и цената на продукта (PC, лаптоп или принтер) с най-висока цена. 
SELECT model, price
FROM laptop
WHERE price >= ALL(SELECT price FROM printer)
AND price >= ALL(SELECT price FROM laptop)
AND price >= ALL(SELECT price FROM pc)
UNION 
SELECT model, price
FROM pc
WHERE price >= ALL(SELECT price FROM printer)
AND price >= ALL(SELECT price FROM laptop)
AND price >= ALL(SELECT price FROM pc)
UNION 
SELECT model, price
FROM printer
WHERE price >= ALL(SELECT price FROM printer)
AND price >= ALL(SELECT price FROM laptop)
AND price >= ALL(SELECT price FROM pc);


-- 5. Напишете заявка, която извежда производителя на цветния принтер с най-ниска цена. 
SELECT maker 
FROM product JOIN printer ON product.model = printer.model
WHERE color LIKE 'y' AND price <= ALL(
SELECT price FROM printer WHERE color LIKE 'y')

-- 6. Напишете заявка, която извежда производителите на тези персонални компютри с най-малко RAM памет, които имат най-бързи процесори. 
SELECT pd.maker
FROM pc AS pc JOIN product AS pd ON pc.model = pd.model
WHERE pc.ram <= ALL(SELECT ram FROM pc)
AND pc.speed >= ALL
(SELECT speed FROM pc WHERE pc.ram <= ALL(SELECT ram FROM pc));

III.За базата от данни SHIPS 
-- 1. Напишете заявка, която извежда страните, чиито кораби са с най-голям брой оръдия. 
SELECT distinct country
FROM classes
WHERE numguns >= ALL(SELECT numguns FROM classes)

-- 2. Напишете заявка, която извежда класовете, за които поне един от корабите е потънал в битка. 
SELECT distinct class
FROM SHIPS JOIN outcomes ON name=ship
WHERE result = 'sunk'
-- 3. Напишете заявка, която извежда името и класа на корабите с 16 инчови оръдия. 
SELECT name, ships.class
FROM ships JOIN classes ON ships.class=classes.class
WHERE bore = 16

-- 4. Напишете заявка, която извежда имената на битките, в които са участвали кораби от клас ‘Kongo’. 
SELECT battle
FROM outcomes JOIN ships ON outcomes.ship=ships.name
WHERE class LIKE 'Kongo'

-- 5. Напишете заявка, която извежда класа и името на корабите, чиито брой оръдия е по-голям или равен на този на корабите със същия калибър оръдия.
SELECT ships.class, name
FROM ships JOIN classes AS cl ON ships.class = cl.class
WHERE numguns >= ALL(SELECT numguns FROM classes WHERE bore=cl.bore)
