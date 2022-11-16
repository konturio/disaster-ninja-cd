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
	helm template dev-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-dev.yaml >> dev.yaml
	helm template dev-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml -f disaster-ninja-fe/values/values-dev.yaml >> dev.yaml
	helm template dev-epig epig -f epig/values.yaml -f epig/values/values-dev.yaml >> dev.yaml
	helm template dev-event-api event-api -f event-api/values.yaml -f event-api/values/values-dev.yaml >> dev.yaml
	helm template dev-insights-api insights-api -f insights-api/values.yaml -f insights-api/values/values-dev.yaml >> dev.yaml
	helm template dev-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-dev.yaml >> dev.yaml
	helm template dev-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-dev.yaml >> dev.yaml
	helm template dev-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-dev.yaml >> dev.yaml
	helm template dev-osrm osrm -f osrm/values.yaml -f osrm/values/values-dev.yaml >> dev.yaml
	helm template dev-raster-tiler raster-tiler -f raster-tiler/values.yaml -f raster-tiler/values/values-dev.yaml >> dev.yaml
	helm template dev-titiler titiler -f titiler/values.yaml -f titiler/values/values-dev.yaml >> dev.yaml
	helm template dev-user-profile-api user-profile-api -f user-profile-api/values.yaml -f user-profile-api/values/values-dev.yaml >> dev.yaml

template-test:
	helm template test-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-test.yaml >> test.yaml
	helm template test-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml -f disaster-ninja-fe/values/values-test.yaml >> test.yaml
	helm template test-epig epig -f epig/values.yaml -f epig/values/values-test.yaml >> test.yaml
	helm template test-event-api event-api -f event-api/values.yaml -f event-api/values/values-test.yaml >> test.yaml
	helm template test-insights-api insights-api -f insights-api/values.yaml -f insights-api/values/values-test.yaml >> test.yaml
	helm template test-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-test.yaml >> test.yaml
	helm template test-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-test.yaml >> test.yaml
	helm template test-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-test.yaml >> test.yaml
	#helm template test-osrm osrm -f osrm/values.yaml -f osrm/values/values-test.yaml >> test.yaml
	helm template test-raster-tiler raster-tiler -f raster-tiler/values.yaml -f raster-tiler/values/values-test.yaml >> test.yaml
	helm template test-titiler titiler -f titiler/values.yaml -f titiler/values/values-test.yaml >> test.yaml
	helm template test-user-profile-api user-profile-api -f user-profile-api/values.yaml -f user-profile-api/values/values-test.yaml >> test.yaml

template-prod:
	helm template prod-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-prod.yaml >> prod.yaml
	helm template prod-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml -f disaster-ninja-fe/values/values-prod.yaml >> prod.yaml
	helm template prod-epig epig -f epig/values.yaml -f epig/values/values-prod.yaml >> prod.yaml
	helm template prod-event-api event-api -f event-api/values.yaml -f event-api/values/values-prod.yaml >> prod.yaml
	helm template prod-insights-api insights-api -f insights-api/values.yaml -f insights-api/values/values-prod.yaml >> prod.yaml
	helm template prod-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-prod.yaml >> prod.yaml
	helm template prod-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-prod.yaml >> prod.yaml
	helm template prod-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-prod.yaml >> prod.yaml
	#helm template prod-osrm osrm -f osrm/values.yaml -f osrm/values/values-prod.yaml >> prod.yaml
	helm template prod-raster-tiler raster-tiler -f raster-tiler/values.yaml -f raster-tiler/values/values-prod.yaml >> prod.yaml
	helm template prod-titiler titiler -f titiler/values.yaml -f titiler/values/values-prod.yaml >> prod.yaml
	helm template prod-user-profile-api user-profile-api -f user-profile-api/values.yaml -f user-profile-api/values/values-prod.yaml >> prod.yaml

template-local:
	helm template local-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-local.yaml >> local.yaml
	helm template local-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml >> local.yaml
	helm template local-epig epig -f epig/values.yaml -f epig/values/values-local.yaml >> local.yaml
	helm template local-event-api event-api -f event-api/values.yaml >> local.yaml
	helm template local-insights-api insights-api -f insights-api/values.yaml >> local.yaml
	helm template local-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-local.yaml >> local.yaml
	helm template local-layers-api layers-api -f layers-api/values.yaml >> local.yaml
	helm template local-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-local.yaml >> local.yaml
	#helm template local-osrm osrm -f osrm/values.yaml -f osrm/values/values-local.yaml >> local.yaml
	helm template local-raster-tiler raster-tiler -f raster-tiler/values.yaml >> local.yaml
	helm template local-titiler titiler -f titiler/values.yaml >> local.yaml
	helm template local-user-profile-api user-profile-api -f user-profile-api/values.yaml >> local.yaml

#end of testing goals

#Makefile for local installation
install-quickstart: uninstall \
					create-all-dbs \
					helm-install-quickstart-all

uninstall: cleanup-namespaces \
		   cleanup-databases

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
	if kubectl get ns quickstart-isochrone-api >& /dev/null; then kubectl delete ns quickstart-isochrone-api; fi;
	if kubectl get ns quickstart-layers-api >& /dev/null; then kubectl delete ns quickstart-layers-api; fi;
	if kubectl get ns quickstart-osrm >& /dev/null; then kubectl delete ns quickstart-osrm; fi;

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
	psql -d gis -c "CREATE EXTENSION postgis;"
	psql -d gis -c "CREATE EXTENSION postgis_sfcgal;"
	psql -d gis -c "CREATE EXTENSION \"uuid-ossp\";"
	psql -d gis -c "CREATE EXTENSION btree_gist;"
	psql -d gis -c "CREATE EXTENSION pgRouting;"
	psql -d gis -c "CREATE EXTENSION http;"

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
							 layers-api \
							 isochrone-api
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

disaster-ninja-be: insights-api layers-api #user-profile-api keycloak event-api
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
	helm upgrade --install quickstart-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-local.yaml -n quickstart-isochrone-api
osrm:
	if kubectl get ns quickstart-osrm >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-osrm; fi;
	helm upgrade --install quickstart-osrm osrm -f osrm/values.yaml -f osrm/values/values-local.yaml -n quickstart-osrm