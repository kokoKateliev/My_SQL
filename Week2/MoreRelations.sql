Упражнение 2, Заявки върху две или повече релации

I.За базата от данни Movies 
-- 1. Напишете заявка, която извежда имената на актьорите мъже, участвали във филма The Usual Suspects.
SELECT name
FROM moviestar JOIN starsin ON name = starname
WHERE gender = 'm' AND movietitle = 'The Usual Suspects';

-- 2. Напишете заявка, която извежда имената на актьорите, участвали във филми от 1995, продуцирани от студио MGM. 
SELECT starname 
FROM starsin JOIN movie ON movietitle = title
WHERE studioname = 'MGM' AND movieyear = 1995;
-- 3. Напишете заявка, която извежда имената на продуцентите, които са продуцирали филми на студио MGM.
SELECT DISTINCT name 
FROM movieexec JOIN movie ON cert# = producerc#
WHERE studioname = 'MGM';

-- 4. Напишете заявка, която извежда имената на всички филми с дължина, поголяма от дължината на филма Star Wars. 
SELECT title 
FROM movie 
WHERE movie.length > (SELECT length FROM movie WHERE title = 'Star Wars');
||
SELECT title 
FROM movie , (SELECT length FROM movie WHERE title = 'Star Wars') t
WHERE movie.length > t.length;

-- 5. Напишете заявка, която извежда имената на продуцентите с нетни активи поголеми от тези на Stephen Spielberg. 
SELECT name
FROM movieexec f, (SELECT networth FROM movieexec WHERE name = 'Stephen Spielberg') s
WHERE f.networth > s.networth

II.За базата от данни PC 
-- 1. Напишете заявка, която извежда производителя и честотата на лаптопите с размер на диска поне 9 GB. 
SELECT maker, speed
FROM product JOIN laptop ON product.model = laptop.model
WHERE hd > 9;
-- 2. Напишете заявка, която извежда модел и цена на продуктите, произведени от производител с име B. 
SELECT product.model, price
FROM product JOIN pc ON product.model=pc.model 
WHERE maker LIKE 'B'
UNION
SELECT product.model, price
FROM product JOIN laptop ON product.model=laptop.model
WHERE maker LIKE 'B'
UNION
SELECT product.model, price
FROM product JOIN printer ON product.model=printer.model
WHERE maker LIKE 'B'

-- 3. Напишете заявка, която извежда производителите, които произвеждат лаптопи, но не произвеждат персонални компютри. 
SELECT maker
FROM product JOIN laptop ON product.model = laptop.model
EXCEPT
SELECT maker
FROM product JOIN pc ON product.model = pc.model

-- 4. Напишете заявка, която извежда размерите на тези дискове, които се предлагат в поне два различни персонални компютъра (два компютъра с различен код). 
SELECT distinct a.hd
FROM pc AS a CROSS JOIN pc AS b
WHERE a.hd = b.hd AND a.code <> b.code

-- 5. Напишете заявка, която извежда двойките модели на персонални компютри, които имат еднаква честота и памет. Двойките трябва да се показват само по веднъж, например само (i, j), но не и (j, i). 
SELECT a.model, b.model
FROM pc AS a CROSS JOIN pc AS b
WHERE a.code < b.code AND a.speed = b.speed AND a.hd = b.hd

-- 6. Напишете заявка, която извежда производителите на поне два различни персонални компютъра с честота поне 400.
SELECT distinct maker
FROM product JOIN (
SELECT distinct a.model
FROM pc AS a CROSS JOIN pc AS b
WHERE a.speed > 400 AND b.speed > 400 AND a.model < b.model) t
ON product.model=t.model


III.За базата от данни SHIPS 
-- 1. Напишете заявка, която извежда името на корабите с водоизместимост над 50000. 
SELECT name
FROM ships JOIN classes ON ships.class = classes.class
WHERE displacement > 50000

-- 2. Напишете заявка, която извежда имената, водоизместимостта и броя оръдия на всички кораби, участвали в битката при Guadalcanal. 
SELECT name, displacement, numguns
FROM ships JOIN classes ON ships.class = classes.class
JOIN outcomes ON ships.name = outcomes.ship
WHERE battle LIKE 'Guadalcanal'

-- 3. Напишете заявка, която извежда имената на тези държави, които имат както бойни кораби, така и бойни крайцери. 
SELECT distinct a.country
FROM classes AS a CROSS JOIN classes as b 
WHERE b.type <> a.type AND a.country = b.country

-- 4. Напишете заявка, която извежда имената на тези кораби, които са били повредени в една битка, но по-късно са участвали в друга битка.
SELECT a.ship
FROM 
(SELECT ship, date
  FROM outcomes JOIN battles ON outcomes.battle = battles.name
  WHERE result LIKE 'damaged') a
      CROSS JOIN 
(SELECT ship, date
  FROM outcomes JOIN battles ON outcomes.battle = battles.name) b
WHERE a.date < b.date AND a.ship = b.ship
