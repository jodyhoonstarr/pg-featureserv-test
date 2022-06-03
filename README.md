# pg-featuresrc/tileserv

Testing the pg_featureserv and pg_tileserv packages

## Start db and pg-featureserv/tileserv

```shell
docker-compose up
```

Open browser to
[featureserv (localhost:9000)](http://localhost:5000)
or
[tileserv (localhost:7800)](http://localhost:7800)

To access the db directly:
```shell
export DATABASE_URL=postgres://postgres:password@localhost:5433/postgres
psql $DATABASE_URL
```

## Load Test data

Natural Earth (WGS84) [link](https://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip)
```shell
shp2pgsql -D -I -s 4326 ne_50m_admin_0_countries | psql $DATABASE_URL
```

DC TIGER 21 Tabblocks (NAD83) [link](https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=Blocks+%282020%29)
```shell
shp2pgsql -D -I -s 4269 tl_2021_11_tabblock20 | psql $DATABASE_URL
```

US TIGER 21 States (NAD83) [link](https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=States+%28and+equivalent%29)
```shell
# save archive to the testdata directory
shp2pgsql -D -I -s 4269 tl_2021_us_state | psql $DATABASE_URL
```

DC OSM Buildings (WGS84) [link](https://download.geofabrik.de/north-america/us/district-of-columbia-latest-free.shp.zip)
```shell
shp2pgsql -D -I -s 4326 gis_osm_buildings_a_free_1 | psql $DATABASE_URL
```

## Test time filter on gis_osm_buildings_a_free_1 table

Add datetime column
```shell
psql $DATABASE_URL -c "ALTER TABLE gis_osm_buildings_a_free_1 ADD COLUMN created_at TIMESTAMP DEFAULT NOW()"
```
Set top 100 rows timestamp to yesterday
```shell
psql $DATABASE_URL -c "
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
             LIMIT 100 OFFSET 200);"
```

## TODO 
- [ ] test datetime/filtering