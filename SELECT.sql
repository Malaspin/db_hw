SELECT name, duration
FROM track
WHERE duration = (
    SELECT MAX(duration) FROM track
);

SELECT name
FROM track
WHERE duration > INTERVAL '3 minutes 30 seconds';

SELECT name
FROM collection
WHERE creation_date BETWEEN '2018-01-01' AND '2020-12-31';

SELECT name
FROM artist
WHERE name NOT LIKE '% %';

SELECT name
FROM track
WHERE name LIKE '%my%'
   OR name LIKE '%мой%';

SELECT g.name AS genre_name, COUNT(ag.id_artist) AS count_artist
FROM artist_genre AS ag
INNER JOIN genre AS g ON ag.id_genre = g.id_genre
GROUP BY g.name
ORDER BY g.name ASC;

SELECT COUNT(t.id_track) AS count_track
FROM track AS t
INNER JOIN album AS a ON t.id_album = a.id_album
WHERE a.creation_date BETWEEN '2019-01-01' AND '2020-12-31';

SELECT a.name AS name_album,
       justify_interval(
           make_interval(secs => ROUND(EXTRACT(EPOCH FROM AVG(t.duration))))
       ) AS avg_duration
FROM track AS t
INNER JOIN album AS a ON t.id_album = a.id_album
GROUP BY a.name;

SELECT ar.name
FROM album_artist AS aa
INNER JOIN album AS a ON a.id_album = aa.id_album
INNER JOIN artist AS ar ON ar.id_artist = aa.id_artist
WHERE a.creation_date NOT BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY ar.name;

SELECT c.name
FROM collection_track AS ct
INNER JOIN track AS t ON ct.id_track = t.id_track
INNER JOIN album_artist AS aa ON aa.id_album = t.id_album
INNER JOIN artist AS ar ON ar.id_artist = aa.id_artist
INNER JOIN collection AS c ON ct.id_collection = c.id_collection
WHERE ar.name LIKE 'Хелависа'
GROUP BY c.name;