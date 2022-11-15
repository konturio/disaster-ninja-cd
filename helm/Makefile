.PHONY: create-event-api-db \
		create-insights-api-db \
		create-isochrone-api-db \
		create-layers-db \
		create-layers-api-user \
		create-layers-tiles-api-user \
		create-mosaic-user \
		create-user-profile-api-db \
		disaster-ninja-be \
		disaster-ninja-fe \
		epig \
		event-api \
		insights-api \
		isochrone-api \
		layers-api \
		layers-tiles-api \
		osrm \
		raster-tiler \
		titiler \
		user-profile-api \
		keycloak

#testing goals
template-all: delete-files kustomize-flux template-dev template-test template-prod template-local

delete-files:
	rm -f dev.yaml
	rm -f test.yaml
	rm -f prod.yaml
	rm -f local.yaml
	rm -f ../flux/clusters/k8s-01/flux.yaml

kustomize-flux:
	kustomize build ../flux/clusters/k8s-01 > ../flux/clusters/k8s-01/flux.yaml

template-dev:
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

template-test:
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

template-prod:
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

template-local:
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
install-quickstart: cleanup-namespaces \
					cleanup-databases \
					create-all-dbs \
					helm-install-quickstart-all

create-image-pull-secrets: create-ns-required-for-pull-secrets #TODO remove once all images are at ghcr.io
	kubectl apply -f nexus.yaml -n quickstart-insights-api
	kubectl apply -f nexus.yaml -n quickstart-isochrone-api
	kubectl apply -f nexus.yaml -n quickstart-layers-api
	kubectl apply -f nexus.yaml -n quickstart-raster-tiler
	kubectl apply -f nexus.yaml -n quickstart-user-profile-api

create-ns-required-for-pull-secrets: #TODO remove once all images are at ghcr.io
	if kubectl get ns quickstart-insights-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-insights-api; fi;
	if kubectl get ns quickstart-isochrone-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-isochrone-api; fi;
	if kubectl get ns quickstart-layers-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-layers-api; fi;
	if kubectl get ns quickstart-raster-tiler >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-raster-tiler; fi;
	if kubectl get ns quickstart-user-profile-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-user-profile-api; fi;

##CLEANUP#
cleanup-namespaces:
	if kubectl get ns quickstart-insights-api >& /dev/null; then kubectl delete ns quickstart-insights-api; fi;
	if kubectl get ns quickstart-layers-api >& /dev/null; then kubectl delete ns quickstart-layers-api; fi;

cleanup-databases:
	psql -d postgres -c "DROP DATABASE IF EXISTS event_api;";
	psql -d postgres -c "DROP DATABASE IF EXISTS \"insights-api\";";
	psql -d postgres -c "DROP DATABASE IF EXISTS gis;";
	psql -d postgres -c "DROP DATABASE IF EXISTS \"layers-db\";";
	psql -d postgres -c "DROP DATABASE IF EXISTS \"user-profile-api\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"event_api_user01\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"insights-api\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"isochrone-api\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"layers-db\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"layers-api\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"layers-tiles-api\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"mosaic\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"user-profile-api\";";

create-all-dbs: create-event-api-db \
				create-insights-api-db \
				create-isochrone-api-db \
				create-layers-db \
				create-layers-api-user \
				create-layers-tiles-api-user \
				create-mosaic-user \
				create-user-profile-api-db

create-event-api-db:
	psql -d postgres -c "CREATE USER event_api_user01 WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE event_api WITH OWNER event_api_user01;";

create-insights-api-db: #OK
	psql -d postgres -c "CREATE USER \"insights-api\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE \"insights-api\" WITH OWNER \"insights-api\";";
	psql -d "insights-api" -c "CREATE EXTENSION postgis;";

create-isochrone-api-db:
	psql -d postgres -c "CREATE USER \"isochrone-api\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE gis WITH OWNER \"isochrone-api\";";

create-layers-db: #OK
	psql -d postgres -c "CREATE USER \"layers-db\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE \"layers-db\" WITH OWNER \"layers-db\";";
	psql -d "layers-db" -c "CREATE EXTENSION postgis;";
	psql -d "layers-db" -c "CREATE EXTENSION btree_gin;";
	psql -d "layers-db" -c "CREATE EXTENSION btree_gist;";
	psql -d "layers-db" -c "CREATE EXTENSION h3;";
	psql -d "layers-db" -c "CREATE EXTENSION h3_postgis;";

create-layers-api-user: create-layers-db #OK
	psql -d "layers-db" -c "CREATE USER \"layers-api\" WITH PASSWORD 'password';"
	psql -d "layers-db" -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"layers-api\";" #TODO seems that other privileges exist by default
	psql -d "layers-db" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO \"layers-api\";"

create-layers-tiles-api-user: create-layers-db
	psql -d "layers-db" -c "CREATE USER \"layers-tiles-api\" WITH PASSWORD 'password';"
	psql -d "layers-db" -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"layers-tiles-api\";"
	psql -d "layers-db" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO \"layers-tiles-api\";"

create-mosaic-user: create-layers-db
	psql -d "layers-db" -c "CREATE USER \"mosaic\" WITH PASSWORD 'password';"
	psql -d "layers-db" -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"mosaic\";"
	psql -d "layers-db" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO \"mosaic\";"

create-user-profile-api-db:
	psql -d postgres -c "CREATE USER \"user-profile-api\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE \"user-profile-api\" WITH OWNER \"user-profile-api\";";

helm-install-quickstart-all: insights-api \
							 layers-api
							# isochrone-api \
#							 disaster-ninja-be \
#							 disaster-ninja-fe \
#							 epig \
#							 event-api \
#							 layers-tiles-api \
#							 osrm \
#							 raster-tiler \
#							 titiler \
#							 user-profile-api \
#							 keycloak

#TODO dependencies below are very rough

disaster-ninja-be: insights-api #user-profile-api keycloak event-api layers-api
	helm upgrade --install local-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-local.yaml -n quickstart-disaster-ninja
disaster-ninja-fe: disaster-ninja-be epig
	helm upgrade --install local-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml -f disaster-ninja-fe/values/values-local.yaml -n quickstart-disaster-ninja
epig:
	helm upgrade --install local-epig epig -f epig/values.yaml -f epig/values/values-local.yaml -n quickstart-epig
event-api:
	helm upgrade --install local-event-api event-api -f event-api/values.yaml -f event-api/values/values-local.yaml -n quickstart-event-api
insights-api: create-insights-api-db create-image-pull-secrets #OK
	if kubectl get ns quickstart-insights-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-insights-api; fi;
	helm upgrade --install quickstart-insights-api insights-api -f insights-api/values.yaml -f insights-api/values/values-quickstart.yaml -n quickstart-insights-api
layers-api: create-layers-db create-layers-api-user create-image-pull-secrets #OK
	if kubectl get ns quickstart-layers-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-layers-api; fi;
	helm upgrade --install quickstart-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-quickstart.yaml -n quickstart-layers-api

layers-tiles-api:
	helm upgrade --install local-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-local.yaml -n quickstart-layers-tiles-api
raster-tiler: create-image-pull-secrets
	helm upgrade --install local-raster-tiler raster-tiler -f raster-tiler/values.yaml -f raster-tiler/values/values-local.yaml -n quickstart-raster-tiler
titiler:
	helm upgrade --install local-titiler titiler -f titiler/values.yaml -f titiler/values/values-local.yaml -n quickstart-titiler

user-profile-api: keycloak create-image-pull-secrets
	helm upgrade --install local-user-profile-api user-profile-api -f user-profile-api/values.yaml -f user-profile-api/values/values-local.yaml -n quickstart-user-profile-api
keycloak:
	helm upgrade --install local-keycloak keycloak -f keycloak/values.yaml -f keycloak/values/values-local.yaml -n quickstart-keycloak

isochrone-api: osrm create-image-pull-secrets
	helm upgrade --install local-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-local.yaml -n quickstart-isochrone-api
osrm:
	helm upgrade --install local-osrm osrm -f osrm/values.yaml -f osrm/values/values-local.yaml -n quickstart-osrm