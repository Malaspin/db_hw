-- Название и продолжительность самого длительного трека
SELECT
    name,
    duration
FROM
    track
WHERE
    duration = (
        SELECT MAX(duration)
        FROM track
    );

-- Название треков, продолжительность которых не менее 3,5 минут
SELECT
    name
FROM
    track
WHERE
    duration > INTERVAL '3 minutes 30 seconds';

-- Названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT
    name
FROM
    collection
WHERE
    creation_date >= '2018-01-01'
    AND creation_date < '2021-01-01';  -- Используем >= и < вместо BETWEEN

-- Исполнители, чьё имя состоит из одного слова
SELECT
    name
FROM
    artist
WHERE
    name NOT LIKE '% %';

-- Название треков, содержащих слово «мой» или «my»
SELECT
    name
FROM
    track
WHERE
    name ILIKE '%my%'
    OR name ILIKE '%мой%';

-- Количество исполнителей в каждом жанре
SELECT
    g.name AS genre_name,
    COUNT(ag.id_artist) AS count_artist
FROM
    artist_genre AS ag
    INNER JOIN genre AS g ON ag.id_genre = g.id_genre
GROUP BY
    g.name
ORDER BY
    g.name ASC;

-- Количество треков, вошедших в альбомы 2019–2020 годов
SELECT
    COUNT(t.id_track) AS count_track
FROM
    track AS t
    INNER JOIN album AS a ON t.id_album = a.id_album
WHERE
    a.creation_date >= '2019-01-01'
    AND a.creation_date < '2021-01-01';

-- Средняя продолжительность треков по каждому альбому
SELECT
    a.name AS name_album,
    justify_interval(
        make_interval(
            secs => ROUND(EXTRACT(EPOCH FROM AVG(t.duration)))
        )
    ) AS avg_duration
FROM
    track AS t
    INNER JOIN album AS a ON t.id_album = a.id_album
GROUP BY
    a.name;

-- Все исполнители, которые не выпустили альбомы в 2020 году
SELECT
    ar.name
FROM
    artist AS ar
WHERE
    NOT EXISTS (
        SELECT 1
        FROM album_artist AS aa
            INNER JOIN album AS a ON aa.id_album = a.id_album
        WHERE
            aa.id_artist = ar.id_artist
            AND a.creation_date >= '2020-01-01'
            AND a.creation_date < '2021-01-01'
    );

-- Названия сборников, в которых присутствует конкретный исполнитель (пример: Хелависа)
SELECT DISTINCT
    c.name
FROM
    collection_track AS ct
    INNER JOIN track AS t ON ct.id_track = t.id_track
    INNER JOIN album_artist AS aa ON aa.id_album = t.id_album
    INNER JOIN artist AS ar ON ar.id_artist = aa.id_artist
    INNER JOIN collection AS c ON ct.id_collection = c.id_collection
WHERE
    ar.name = 'Хелависа';

-- Названия альбомов, в которых присутствуют исполнители более чем одного жанра
SELECT
    a.name
FROM
    album AS a
    INNER JOIN album_artist AS aa ON aa.id_album = a.id_album
    INNER JOIN artist_genre AS ag ON ag.id_artist = aa.id_artist
GROUP BY
    a.name
HAVING
    COUNT(DISTINCT ag.id_genre) > 1;

-- Наименования треков, которые не входят в сборники
SELECT DISTINCT
    t.name
FROM
    track AS t
    LEFT JOIN collection_track AS ct ON t.id_track = ct.id_track
WHERE
    ct.id_track IS NULL;

-- Исполнители, написавшие самый короткий по продолжительности трек
WITH min_duration AS (
    SELECT MIN(duration) AS min_dur FROM track
)
SELECT DISTINCT
    a.name
FROM
    artist AS a
    INNER JOIN album_artist AS aa ON a.id_artist = aa.id_artist
    INNER JOIN track AS t ON t.id_album = aa.id_album
    INNER JOIN min_duration AS md ON t.duration = md.min_dur;

-- Названия альбомов, содержащих наименьшее количество треков
WITH track_count AS (
    SELECT id_album, COUNT(*) AS cnt_track FROM track GROUP BY id_album
),
min_track_count AS (
    SELECT MIN(cnt_track) AS min_cnt FROM track_count
)
SELECT DISTINCT
    a.name
FROM
    album AS a
    INNER JOIN track_count AS tc ON a.id_album = tc.id_album
    INNER JOIN min_track_count AS mtc ON tc.cnt_track = mtc.min_cnt;
>>>>>>> 4b66e5a (InitialCommit)
