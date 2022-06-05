UPDATE gis_osm_buildings_a_free_1
SET created_at = (created_at - INTERVAL '1 year')::date
WHERE gid IN (SELECT gid
              FROM gis_osm_buildings_a_free_1
              ORDER BY gid ASC
              LIMIT 100);

UPDATE gis_osm_buildings_a_free_1
SET created_at = (created_at - INTERVAL '2 year')::date
WHERE gid IN (SELECT gid
              FROM gis_osm_buildings_a_free_1
              ORDER BY gid ASC
              LIMIT 100 OFFSET 100);

UPDATE gis_osm_buildings_a_free_1
SET created_at = (created_at - INTERVAL '3 year')::date
WHERE gid IN (SELECT gid
              FROM gis_osm_buildings_a_free_1
              ORDER BY gid ASC
              LIMIT 100 OFFSET 200);