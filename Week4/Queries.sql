Упражнение 4 Съединения

I. За базата от данни Movies 
-- 1. Напишете заявка, която извежда името на продуцента и имената на филмите, продуцирани от продуцента на филма ‘Star Wars’. 
SELECT name, title
FROM movieexec JOIN movie ON cert#=PRODUCERC#
WHERE producerc# = (SELECT producerc# 
FROM movie 
WHERE title LIKE 'Star Wars')

-- 2. Напишете заявка, която извежда имената на продуцентите на филмите, в които е участвал ‘Harrison Ford’. 
SELECT DISTINCT name
FROM movieexec JOIN movie ON cert# = producerc#
JOIN STARSIN ON title = movietitle
WHERE starname LIKE 'Harrison Ford'

-- 3. Напишете заявка, която извежда името на студиото и имената на актьорите, участвали във филми, произведени от това студио, 
-- подредени по име на студио. 
SELECT distinct studioname, starname
FROM movie JOIN starsin ON title = movietitle
ORDER BY studioname

-- 4. Напишете заявка, която извежда имената на актьорите, участвали във филми на продуценти с най-големи нетни активи. 
SELECT starname, NETWORTH, title
FROM movie JOIN starsin ON title = movietitle
JOIN movieexec ON producerc#=cert#
WHERE NETWORTH = (
SELECT MAX(networth)
FROM movieexec)

-- 5. Напишете заявка, която извежда имената на актьорите, които не са участвали в нито един филм. 
SELECT name, movietitle
FROM starsin FULL JOIN moviestar ON starname = name
WHERE movietitle IS NULL

II. За базата от данни PC 
-- 1. Напишете заявка, която извежда производител, модел и тип на продукт за тези производители, за които съответният продукт не се продава 
-- (няма го в таблиците PC, Laptop или Printer) 
SELECT maker, p.model, p.type
FROM product AS p FULL JOIN pc ON p.model = pc.model
FULL JOIN laptop AS l ON l.model = p.model
FULL JOIN printer AS pr ON pr.model = p.model
WHERE pc.price IS NULL AND pr.price IS NULL AND l.price IS NULL

-- 2. Намерете всички производители, които правят както лаптопи, така и принтери. 
SELECT maker
FROM product JOIN printer ON product.model = printer.model
INTERSECT
SELECT maker 
FROM product JOIN laptop ON product.model = laptop.model

-- 3. Намерете размерите на тези твърди дискове, които се появяват в два или повече модела лаптопи. 
SELECT DISTINCT a.hd
FROM laptop AS a CROSS JOIN laptop AS b
WHERE a.code <> b.code AND a.hd = b.hd

-- 4. Намерете всички модели персонални компютри, които нямат регистриран производител.
SELECT pc.model
FROM pc JOIN product ON pc.model = product.model
WHERE maker IS NULL


III. За базата от данни SHIPS 
-- 1. Напишете заявка, която извежда цялата налична информация за всеки кораб, включително и данните за неговия клас. 
-- В резултата не трябва да се включват тези класове, които нямат кораби. 
SELECT *
FROM ships LEFT JOIN classes ON ships.class=classes.class
WHERE name IS NULL

-- 2. Повторете горната заявка, като този път включите в резултата и класовете, които нямат кораби, но съществуват кораби със същото име като тяхното. 
SELECT *
FROM ships RIGHT JOIN classes ON ships.class=classes.class
ORDER BY ships.name;

-- 3. За всяка страна изведете имената на корабите, които никога не са участвали в битка. 
SELECT country, name
FROM ships JOIN classes ON ships.class = classes.class
FULL JOIN outcomes ON name=ship
WHERE battle IS NULL
ORDER BY country

-- 4. Намерете имената на всички кораби с поне 7 оръдия, пуснати на вода през 1916, но наречете резултатната колона Ship Name. 
SELECT name AS "Ship Name"
FROM ships JOIN classes AS cl ON ships.class=cl.class
WHERE ships.launched = 1916 AND numguns >= 7

-- 5. Изведете имената на всички потънали в битка кораби, името и дата на провеждане на битките, в които те са потънали. 
-- Подредете резултата по име на битката. 
SELECT ship, battle, date
FROM outcomes JOIN battles ON outcomes.battle=battles.name
WHERE result LIKE 'sunk'
ORDER BY battle

-- 6. Намерете името, водоизместимостта и годината на пускане на вода на всички кораби, които имат същото име като техния клас. 
SELECT name, displacement, launched
FROM classes JOIN ships ON classes.class=ships.class
WHERE ships.name=classes.class

-- 7. Намерете всички класове кораби, от които няма пуснат на вода нито един кораб.
SELECT *
FROM classes AS cl LEFT JOIN ships ON cl.class=ships.class
WHERE name IS NULL
 
-- 8. Изведете името, водоизместимостта и броя оръдия на корабите, участвали в битката ‘North Atlantic’, а също и резултата от битката.
SELECT name, displacement, numguns, result
FROM classes AS cl JOIN ships AS sh ON cl.class=sh.class
JOIN outcomes AS ou ON sh.name=ou.ship
WHERE ou.battle LIKE 'North Atlantic'
