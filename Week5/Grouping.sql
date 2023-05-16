Упражнение 5 Групиране
I. За базата от данни PC 
-- 1. Напишете заявка, която извежда средната честота на персоналните компютри. 
SELECT convert(decimal(9,2),AVG(speed)) AS avg_speed
FROM PC

-- 2. Напишете заявка, която извежда средния размер на екраните на лаптопите за всеки производител. 
SELECT maker, AVG(screen) AS avg_screen
FROM laptop JOIN product ON laptop.model=product.model
GROUP BY maker

-- 3. Напишете заявка, която извежда средната честота на лаптопите с цена над 1000.
SELECT convert(decimal(9,2),AVG(speed)) AS avg_speed
FROM laptop
WHERE price > 1000
 
-- 4. Напишете заявка, която извежда средната цена на персоналните компютри, произведени от производител ‘A’. 
SELECT convert(decimal(9,2),AVG(price)) AS avg_price
FROM pc JOIN product ON pc.model=product.model
WHERE maker LIKE 'A'

-- 5. Напишете заявка, която извежда средната цена на персоналните компютри и лаптопите за производител ‘B’. 
SELECT maker, avg(t.price) AS avg_price
FROM product JOIN (
SELECT model,price FROM laptop
UNION ALL 
SELECT pc.model,price FROM pc) t
ON product.model = t.model
WHERE maker LIKE 'B'
GROUP BY maker

-- 6. Напишете заявка, която извежда средната цена на персоналните компютри според различните им честоти. 
SELECT speed, AVG(price)
FROM pc
GROUP BY speed

-- 7. Напишете заявка, която извежда производителите, които са произвели поне 3 различни персонални компютъра (с различен код). 
SELECT maker, COUNT(code) AS num_of_pc
FROM product JOIN pc ON product.model=pc.model
GROUP BY maker
HAVING COUNT(code) >= 3

-- 8. Напишете заявка, която извежда производителите с най-висока цена на персонален компютър. 
SELECT maker, price
FROM product JOIN pc ON product.model=pc.model
WHERE price = (SELECT MAX(price) FROM pc)

-- 9. Напишете заявка, която извежда средната цена на персоналните компютри за всяка честота по-голяма от 800. 
SELECT AVG(price) AS price, speed 
FROM pc
GROUP BY speed
HAVING speed > 800

-- 10.Напишете заявка, която извежда средния размер на диска на тези персонални компютри, произведени от производители, които произвеждат и принтери. Резултатът да се изведе за всеки отделен производител. 
SELECT convert(decimal(9,2),AVG(hd)) AS avg_hd, maker 
FROM product JOIN pc ON product.model=pc.model
GROUP BY maker
HAVING maker IN (
SELECT maker 
FROM product JOIN printer ON product.model = printer.model)





II. За базата от данни SHIPS 
-- 1. Напишете заявка, която извежда броя на класовете бойни кораби. 
SELECT COUNT(class) AS count_of_bb
FROM classes
WHERE type LIKE 'bb'

-- 2. Напишете заявка, която извежда средния брой оръдия за всеки клас боен кораб. 
SELECT class, AVG(numguns) AS avg_numguns
FROM classes
WHERE type LIKE 'bb'
GROUP BY class

-- 3. Напишете заявка, която извежда средния брой оръдия за всички бойни кораби. 
SELECT AVG(numguns) AS avg_numguns
FROM classes
WHERE type LIKE 'bb'

-- 4. Напишете заявка, която извежда за всеки клас първата и последната година, в която кораб от съответния клас е пуснат на вода. 
SELECT classes.class, MIN(launched) AS first, MAX(launched) AS last
FROM classes JOIN ships ON classes.class = ships.class
GROUP BY classes.class

-- 5. Напишете заявка, която извежда броя на корабите, потънали в битка според класа.
SELECT class, COUNT(ship) AS count
FROM ships JOIN outcomes ON name = ship
WHERE result LIKE 'sunk'
GROUP BY class

-- 6. Напишете заявка, която извежда броя на корабите, потънали в битка според класа, за тези класове с повече от 2 кораба. 
SELECT class, COUNT(ship) AS count
FROM ships JOIN outcomes ON name = ship
WHERE result LIKE 'sunk' 
GROUP BY class
HAVING (SELECT COUNT(class) FROM ships) > 2

-- 7. Напишете заявка, която извежда средния калибър на оръдията на корабите за всяка страна
SELECT convert(decimal(9,2), AVG(bore)) AS avg_bore, country
FROM classes JOIN ships ON classes.class = ships.class
GROUP BY country
