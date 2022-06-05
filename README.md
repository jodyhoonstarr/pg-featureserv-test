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
or
[web map (localhost:8000)](http://localhost:9000)

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
For testing: set top 100 rows to last year timestamp, 100-200 to 2 years ago, 200-300 to 3 years ago.
```shell
psql $DATABASE_URL -c -f ./sql/modify_created_at.sql
```

## Feature Layer Functions

Expose a [buildings by year function](http://localhost:9000/functions.html) that queries 
on the timestamp set above.
```shell
psql $DATABASE_URL -f ./sql/buildings_by_year.sql
```