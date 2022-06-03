# pg-featuresrc/tileserv

## Start db and pg-featureserv/tileserv

```shell
docker-compose up
```


To access the db directly:
```shell
export PGPASSWORD=password
psql -h localhost -p 5433 -U postgres postgres 
```

## Load Test data

Load dc 2021 tabblocks from [TIGER](https://www.census.gov/cgi-bin/geo/shapefiles/index.php?year=2021&layergroup=Blocks+%282020%29)
```shell
# save archive to the testdata directory
cd testdata
unar ./tl_2021_dc_tabblock20.zip
shp2pgsql -s 4269 -g the_geom ./tl_2021_11_tabblock20/tl_2021_11_tabblock20.shp blocks | psql -h localhost -p 5433 -U postgres postgres
```

Load an osm shapefile that's more complex
Pulled from [geofabrik](https://download.geofabrik.de/north-america/us/district-of-columbia-latest-free.shp.zip)
```shell
# save archive to the testdata directory
cd testdata
unar ./district-of-columbia-latest-free.shp.zip
shp2pgsql -s 4269 -g the_geom ./district-of-columbia-latest-free.shp/gis_osm_buildings_a_free_1.shp buildings | psql -h localhost -p 5433 -U postgres postgres
```

Add datetime column
```shell
psql -h localhost -p 5433 -U postgres postgres -c "
ALTER TABLE buildings ADD COLUMN created_at TIMESTAMP DEFAULT NOW()"
```
Set top 100 rows timestamp to yesterday
```shell
psql -h localhost -p 5433 -U postgres postgres -c "
UPDATE buildings
SET created_at = (created_at - INTERVAL '1 day')::date
WHERE gid IN (SELECT gid
             FROM buildings
             ORDER BY gid ASC
             LIMIT 100);"
```

Open browser to 
[featureserv (localhost:9000)](http://localhost:5000) 
or 
[tileserv (localhost:7800)](http://localhost:7800)

## TODO 
- [ ] test datetime/filtering