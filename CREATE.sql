CREATE TABLE IF NOT EXISTS genre (
    id_genre SERIAL PRIMARY KEY,
        name VARCHAR(80) NOT NULL
);

CREATE TABLE IF NOT EXISTS artist (
    id_artist SERIAL PRIMARY KEY,
    name VARCHAR(80) NOT NULL
);

CREATE TABLE IF NOT EXISTS album (
    id_album SERIAL PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    creation_date DATE NOT NULL CHECK (creation_date <= CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS track (
    id_track SERIAL PRIMARY KEY,
    id_album INTEGER REFERENCES album(id_album),
    name VARCHAR(80) NOT NULL,
    duration INTERVAL NOT NULL CHECK (duration > INTERVAL '0 seconds')
);

CREATE TABLE IF NOT EXISTS collection (
    id_collection SERIAL PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    creation_date DATE NOT NULL CHECK (creation_date <= CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS collection_track (
    id_collection INTEGER NOT NULL REFERENCES collection(id_collection) ON DELETE CASCADE,
    id_track INTEGER NOT NULL REFERENCES track(id_track) ON DELETE CASCADE,
    PRIMARY KEY (id_collection, id_track)
);

CREATE TABLE IF NOT EXISTS artist_genre (
    id_artist INTEGER NOT NULL REFERENCES artist(id_artist) ON DELETE CASCADE,
    id_genre INTEGER NOT NULL REFERENCES genre(id_genre) ON DELETE CASCADE,
    PRIMARY KEY (id_genre, id_artist)
);

CREATE TABLE IF NOT EXISTS album_artist (
    id_album INTEGER NOT NULL REFERENCES album(id_album) ON DELETE CASCADE,
    id_artist INTEGER NOT NULL REFERENCES artist(id_artist) ON DELETE CASCADE,
    PRIMARY KEY (id_album, id_artist)
);