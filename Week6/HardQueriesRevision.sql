Упражнение 6 - ОБЩИ ЗАЯВКИ

I. За базата от данни MOVIES 
-- 1. Напишете заявка, която извежда заглавие и година на всички филми, които са по-дълги от 120 минути и са снимани преди 2000 г. Ако дължината на филма е неизвестна, заглавието и годината на този филм също да се изведат. 
SELECT title, year, length
FROM movie
WHERE (length > 120 OR length IS NULL) AND year < 2000

-- 2. Напишете заявка, която извежда име и пол на всички актьори (мъже и жени), чието име започва с 'J' и са родени след 1948 година. Резултатът да бъде подреден по име в намаляващ ред. 
SELECT name, gender
FROM moviestar
WHERE name LIKE 'J%' AND YEAR(birthdate) > 1948
ORDER BY name DESC

-- 3. Напишете заявка, която извежда име на студио и брой на актьорите, участвали във филми, които са създадени от това студио. 
	SELECT studioname, COUNT(DISTINCT starname) AS num_actors
FROM movie JOIN starsin ON title=movietitle
GROUP BY studioname

-- 4. Напишете заявка, която за всеки актьор извежда име на актьора и броя на филмите, в които актьорът е участвал. 
SELECT starname, COUNT(starname) AS film_count
FROM starsin
GROUP BY starname

-- 5. Напишете заявка, която за всяко студио извежда име на студиото и заглавие на филма, излязъл последно на екран за това студио. 
	SELECT studioname, title, year
FROM movie AS m
WHERE year = (SELECT MAX(year) FROM movie AS s WHERE m.studioname=s.studioname)

-- 6. Напишете заявка, която извежда името на най-младия актьор (мъж). 
SELECT name
FROM moviestar
WHERE birthdate = (SELECT MAX(birthdate) FROM moviestar WHERE gender LIKE 'M')

-- 7. Напишете заявка, която извежда име на актьор и име на студио за тези актьори, участвали в най-много филми на това студио. 
SELECT studioname, starname, COUNT(title) as count_movies
FROM starsin AS f JOIN movie AS s ON f.movietitle=s.title
GROUP BY studioname, starname
HAVING COUNT(title) >= ALL(
SELECT COUNT(title) 
FROM movie JOIN starsin ON title=movietitle 
GROUP BY starname)

-- 8. Напишете заявка, която извежда заглавие и година на филма, и брой на актьорите, участвали в този филм за тези филми с повече от двама актьори. 
SELECT title, year, COUNT(starname) AS num_actors
FROM movie JOIN starsin ON title=movietitle
GROUP BY title, year
HAVING COUNT(starname) > 2



II. За базата от данни SHIPS 
-- 1. Напишете заявка, която извежда имената на всички кораби без повторения, които са участвали в поне една битка и чиито имена започват с C или K. 
SELECT ship
FROM outcomes
WHERE ship LIKE 'C%' OR ship LIKE 'K%'
GROUP BY ship
HAVING COUNT(ship) >= 1

-- 2. Напишете заявка, която извежда име и държава на всички кораби, които никога не са потъвали в битка (може и да не са участвали). 
SELECT distinct name, country
FROM classes JOIN ships ON classes.class = ships.class
LEFT JOIN outcomes ON name = ship
WHERE result IS NULL OR result <> 'sunk'

-- 3. Напишете заявка, която извежда държавата и броя на потъналите кораби за тази държава. Държави, които нямат кораби или имат кораб, но той не е участвал в битка, също да бъдат изведени. 
	SELECT country, COUNT(ship) AS sunk_ships
FROM classes 
LEFT JOIN ships ON classes.class = ships.class
LEFT JOIN outcomes ON ship = name AND result = 'sunk'
GROUP BY country

-- 4. Напишете заявка, която извежда име на битките, които са по-мащабни (с повече участващи кораби) от битката при Guadalcanal. 
SELECT battle
FROM outcomes
GROUP BY battle
HAVING count(battle) > (
SELECT count(battle) 
FROM outcomes 
WHERE battle LIKE 'Guadalcanal')

-- 5. Напишете заявка, която извежда име на битките, които са по-мащабни (с повече участващи страни) от битката при Surigao Strait. 
SELECT battle
FROM outcomes
GROUP BY battle
HAVING count(battle) > (
SELECT count(battle)
 FROM outcomes 
WHERE battle LIKE 'Surigao Strait')

-- 6. Напишете заявка, която извежда имената на най-леките кораби с най-много оръдия. 
SELECT name, displacement, numguns
FROM ships AS s JOIN classes AS c ON s.class=c.class
WHERE displacement < ALL (
SELECT displacement
 FROM classes 
WHERE numguns >= ALL(
SELECT numguns FROM classes))

-- 7. Изведете броя на корабите, които са били увредени в битка, но са били поправени и по-късно са победили в друга битка. 
SELECT COUNT(name) AS winners
FROM ships
WHERE name IN (SELECT ship FROM outcomes WHERE result LIKE 'damaged'
        INTERSECT
       SELECT ship FROM outcomes WHERE result LIKE 'ok')


-- 8. Изведете име на корабите, които са били увредени в битка, но са били поправени и по-късно са победили в по-мащабна битка (с повече кораби). 
SELECT name
FROM ships
WHERE name IN (SELECT ship FROM outcomes WHERE result LIKE 'damaged'
    			        INTERSECT
       SELECT ship FROM outcomes WHERE result LIKE 'ok')


III. За базата от данни PC 
-- 1. Напишете заявка, която извежда всички модели лаптопи, за които се предлагат както разновидности с 15" екран, така и с 11" екран. 
SELECT model, code, screen
FROM laptop
WHERE screen=11 OR screen=15 AND model IN (
SELECT model FROM laptop WHERE screen=15 
INTERSECT 
SELECT model FROM laptop WHERE screen=11)

-- 2. Да се изведат различните модели компютри, чиято цена е по-ниска от най-евтиния лаптоп, произвеждан от същия производител. 
SELECT distinct pr.model
FROM pc AS p JOIN product AS pr ON p.model=pr.model
WHERE price < (
SELECT MIN(price)
FROM laptop JOIN product AS prod ON prod.model = laptop.model  
WHERE pr.maker=prod.maker)

-- 3. Един модел компютри може да се предлага в няколко разновидности с различна цена. Да се изведат тези модели компютри, чиято средна цена (на различните му разновидности) е по-ниска от най-евтиния лаптоп, произвеждан от същия производител. 
SELECT pc.model, AVG(price) AS avg_price
FROM pc JOIN product AS pr1 ON pc.model=pr1.model
GROUP BY pc.model, pr1.maker
HAVING AVG(price) < (
SELECT MIN(price)
FROM laptop JOIN product AS pr2 ON laptop.model=pr2.model AND pr1.maker=pr2.maker)

-- 4. Напишете заявка, която извежда за всеки компютър код на продукта, производител и брой компютри, които имат цена, по-голяма или равна на неговата.
SELECT p1.code, maker, COUNT(p2.code) AS more_expensive_pcs
FROM pc AS p1 CROSS JOIN pc AS p2 JOIN product ON p1.model=product.model 
AND p2.model=product.model
WHERE p1.price <= p2.price 
GROUP BY p1.code, maker
