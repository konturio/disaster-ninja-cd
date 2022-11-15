.PHONY: insights-api #TODO others

#testing goals
generate-all: delete-files flux dev test prod local

delete-files:
	rm -f dev.yaml
	rm -f test.yaml
	rm -f prod.yaml
	rm -f local.yaml
	rm -f ../flux/clusters/k8s-01/flux.yaml

flux:
	kustomize build ../flux/clusters/k8s-01 > ../flux/clusters/k8s-01/flux.yaml

dev:
	helm template $@-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-$@.yaml >> $@.yaml
	helm template $@-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml -f disaster-ninja-fe/values/values-$@.yaml >> $@.yaml
	helm template $@-epig epig -f epig/values.yaml -f epig/values/values-$@.yaml >> $@.yaml
	helm template $@-event-api event-api -f event-api/values.yaml -f event-api/values/values-$@.yaml >> $@.yaml
	helm template $@-insights-api insights-api -f insights-api/values.yaml -f insights-api/values/values-$@.yaml >> $@.yaml
	helm template $@-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-$@.yaml >> $@.yaml
	helm template $@-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-$@.yaml >> $@.yaml
	helm template $@-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-$@.yaml >> $@.yaml
	helm template $@-osrm osrm -f osrm/values.yaml -f osrm/values/values-$@.yaml >> $@.yaml
	helm template $@-raster-tiler raster-tiler -f raster-tiler/values.yaml -f raster-tiler/values/values-$@.yaml >> $@.yaml
	helm template $@-titiler titiler -f titiler/values.yaml -f titiler/values/values-$@.yaml >> $@.yaml
	helm template $@-user-profile-api user-profile-api -f user-profile-api/values.yaml -f user-profile-api/values/values-$@.yaml >> $@.yaml

test:
	helm template $@-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-$@.yaml >> $@.yaml
	helm template $@-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml -f disaster-ninja-fe/values/values-$@.yaml >> $@.yaml
	helm template $@-epig epig -f epig/values.yaml -f epig/values/values-$@.yaml >> $@.yaml
	helm template $@-event-api event-api -f event-api/values.yaml -f event-api/values/values-$@.yaml >> $@.yaml
	helm template $@-insights-api insights-api -f insights-api/values.yaml -f insights-api/values/values-$@.yaml >> $@.yaml
	helm template $@-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-$@.yaml >> $@.yaml
	helm template $@-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-$@.yaml >> $@.yaml
	helm template $@-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-$@.yaml >> $@.yaml
	#helm template $@-osrm osrm -f osrm/values.yaml -f osrm/values/values-$@.yaml >> $@.yaml
	helm template $@-raster-tiler raster-tiler -f raster-tiler/values.yaml -f raster-tiler/values/values-$@.yaml >> $@.yaml
	helm template $@-titiler titiler -f titiler/values.yaml -f titiler/values/values-$@.yaml >> $@.yaml
	helm template $@-user-profile-api user-profile-api -f user-profile-api/values.yaml -f user-profile-api/values/values-$@.yaml >> $@.yaml

prod:
	helm template $@-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-$@.yaml >> $@.yaml
	helm template $@-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml -f disaster-ninja-fe/values/values-$@.yaml >> $@.yaml
	helm template $@-epig epig -f epig/values.yaml -f epig/values/values-$@.yaml >> $@.yaml
	helm template $@-event-api event-api -f event-api/values.yaml -f event-api/values/values-$@.yaml >> $@.yaml
	helm template $@-insights-api insights-api -f insights-api/values.yaml -f insights-api/values/values-$@.yaml >> $@.yaml
	helm template $@-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-$@.yaml >> $@.yaml
	helm template $@-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-$@.yaml >> $@.yaml
	helm template $@-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-$@.yaml >> $@.yaml
	#helm template $@-osrm osrm -f osrm/values.yaml -f osrm/values/values-$@.yaml >> $@.yaml
	helm template $@-raster-tiler raster-tiler -f raster-tiler/values.yaml -f raster-tiler/values/values-$@.yaml >> $@.yaml
	helm template $@-titiler titiler -f titiler/values.yaml -f titiler/values/values-$@.yaml >> $@.yaml
	helm template $@-user-profile-api user-profile-api -f user-profile-api/values.yaml -f user-profile-api/values/values-$@.yaml >> $@.yaml

local:
	helm template $@-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-$@.yaml >> $@.yaml
	helm template $@-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml >> $@.yaml
	helm template $@-epig epig -f epig/values.yaml -f epig/values/values-$@.yaml >> $@.yaml
	helm template $@-event-api event-api -f event-api/values.yaml >> $@.yaml
	helm template $@-insights-api insights-api -f insights-api/values.yaml >> $@.yaml
	helm template $@-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-$@.yaml >> $@.yaml
	helm template $@-layers-api layers-api -f layers-api/values.yaml >> $@.yaml
	helm template $@-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-$@.yaml >> $@.yaml
	#helm template $@-osrm osrm -f osrm/values.yaml -f osrm/values/values-$@.yaml >> $@.yaml
	helm template $@-raster-tiler raster-tiler -f raster-tiler/values.yaml >> $@.yaml
	helm template $@-titiler titiler -f titiler/values.yaml >> $@.yaml
	helm template $@-user-profile-api user-profile-api -f user-profile-api/values.yaml >> $@.yaml

#end of testing goals

#Makefile for local installation

install-local: create-psql-databases helm-install-local-all

##CLEANUP#
#cleandup-databases:
#	psql -d postgres -c "DROP DATABASE event_api;";
#	psql -d postgres -c "DROP DATABASE \"insights-api\";";
#	psql -d postgres -c "DROP DATABASE gis;";
#	psql -d postgres -c "DROP DATABASE \"layers-db\";";
#	psql -d postgres -c "DROP DATABASE \"user-profile-api\";";
#	psql -d postgres -c "DROP ROLE \"event_api_user01\";";
#	psql -d postgres -c "DROP ROLE \"insights-api\";";
#	psql -d postgres -c "DROP ROLE \"isochrone-api\";";
#	psql -d postgres -c "DROP ROLE \"layers-db\";";
#	psql -d postgres -c "DROP ROLE \"layers-api\";";
#	psql -d postgres -c "DROP ROLE \"layers-tiles-api\";";
#	psql -d postgres -c "DROP ROLE \"mosaic\";";
#	psql -d postgres -c "DROP ROLE \"user-profile-api\";";

create-psql-databases: create-event-api-db create-insights-api-db create-isochrone-api-db create-layers-db create-layers-api-user create-layers-tiles-api-user create-mosaic-user create-user-profile-api-db

create-event-api-db:
	psql -d postgres -c "CREATE USER event_api_user01 WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE event_api WITH OWNER event_api_user01;";

create-insights-api-db:
	psql -d postgres -c "CREATE USER \"insights-api\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE \"insights-api\" WITH OWNER \"insights-api\";";
	psql -d "insights-api" -c "CREATE EXTENSION postgis;";

create-isochrone-api-db:
	psql -d postgres -c "CREATE USER \"isochrone-api\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE gis WITH OWNER \"isochrone-api\";";

create-layers-db:
	psql -d postgres -c "CREATE USER \"layers-db\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE \"layers-db\" WITH OWNER \"layers-db\";";

create-layers-api-user: create-layers-db
	psql -d postgres -c "CREATE USER \"layers-api\" WITH PASSWORD 'password';"
	psql -d "layers-db" -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"layers-api\";" #TODO other privileges
	psql -d "layers-db" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO \"layers-api\";"

create-layers-tiles-api-user: create-layers-db
	psql -d postgres -c "CREATE USER \"layers-tiles-api\" WITH PASSWORD 'password';"
	psql -d "layers-db" -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"layers-tiles-api\";"
	psql -d "layers-db" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO \"layers-tiles-api\";"

create-mosaic-user: create-layers-db
	psql -d postgres -c "CREATE USER \"mosaic\" WITH PASSWORD 'password';"
	psql -d "layers-db" -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"mosaic\";"
	psql -d "layers-db" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO \"mosaic\";"

create-user-profile-api-db:
	psql -d postgres -c "CREATE USER \"user-profile-api\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE \"user-profile-api\" WITH OWNER \"user-profile-api\";";

helm-install-local-all: disaster-ninja-be disaster-ninja-fe epig event-api insights-api isochrone-api layers-api layers-tiles-api osrm raster-tiler titiler user-profile-api keycloak

#TODO dependencies below are very rough

disaster-ninja-be: #user-profile-api keycloak event-api insights-api layers-api
	helm install local-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-local.yaml
disaster-ninja-fe: disaster-ninja-be epig
	helm install local-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml -f disaster-ninja-fe/values/values-local.yaml
epig:
	helm install local-epig epig -f epig/values.yaml -f epig/values/values-local.yaml
event-api:
	helm install local-event-api event-api -f event-api/values.yaml -f event-api/values/values-local.yaml
insights-api:
	helm install quickstart-insights-api insights-api -f insights-api/values.yaml -f insights-api/values/values-quickstart.yaml
layers-api:
	helm install local-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-local.yaml

layers-tiles-api:
	helm install local-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-local.yaml
raster-tiler:
	helm install local-raster-tiler raster-tiler -f raster-tiler/values.yaml -f raster-tiler/values/values-local.yaml
titiler:
	helm install local-titiler titiler -f titiler/values.yaml -f titiler/values/values-local.yaml

user-profile-api: keycloak
	helm install local-user-profile-api user-profile-api -f user-profile-api/values.yaml -f user-profile-api/values/values-local.yaml
keycloak:
	helm install local-keycloak keycloak -f keycloak/values.yaml -f keycloak/values/values-local.yaml

isochrone-api: osrm
	helm install local-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-local.yaml
osrm:
	helm install local-osrm osrm -f osrm/values.yaml -f osrm/values/values-local.yaml