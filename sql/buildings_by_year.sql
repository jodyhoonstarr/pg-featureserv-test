
CREATE SCHEMA IF NOT EXISTS postgisftw;

CREATE
    OR REPLACE
    FUNCTION postgisftw.buildings_by_year(
    year TEXT DEFAULT '2022')
    RETURNS
        TABLE
        (
            gid        INTEGER,
            osm_id     VARCHAR(10),
            code       SMALLINT,
            fclass     VARCHAR(28),
            name       VARCHAR(100),
            type       VARCHAR(20),
            geom       geometry,
            created_at TIMESTAMP
        )
AS
$$
DECLARE
    year_ts TIMESTAMP;
BEGIN
    year_ts := TO_TIMESTAMP(year, 'YYYY');

    RETURN QUERY
        SELECT *
        FROM public.gis_osm_buildings_a_free_1 l
        WHERE l.created_at
                  BETWEEN year_ts AND
                      year_ts + (INTERVAL '1 year');

END;
$$
    LANGUAGE 'plpgsql'
    STABLE
    STRICT
    PARALLEL SAFE;