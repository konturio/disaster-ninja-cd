.PHONY: create-event-api-db \
		create-insights-api-db \
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
		layers-api \
		layers-db-etl\
		layers-tiles-api \
		raster-tiler \
		titiler \
		user-profile-api \
		keycloak \
		create-isochrone-api-db \
		isochrone-api \
		osrm \
		basemap

##Makefile for local installation
install-quickstart: uninstall \
					create-all-dbs \
					helm-install-quickstart-all

uninstall: cleanup-namespaces \
		   cleanup-databases

create-image-pull-secrets: create-ns-required-for-pull-secrets #TODO remove once all images are at ghcr.io
	kubectl apply -f nexus.yaml -n quickstart-keycloak
	kubectl apply -f nexus.yaml -n quickstart-epig
	kubectl apply -f nexus.yaml -n quickstart-osrm
	kubectl apply -f nexus.yaml -n quickstart-basemap
	kubectl apply -f nexus.yaml -n quickstart-insights-api
	kubectl apply -f nexus.yaml -n quickstart-isochrone-api
	kubectl apply -f nexus.yaml -n quickstart-layers-api
	kubectl apply -f nexus.yaml -n quickstart-layers-db
	kubectl apply -f nexus.yaml -n quickstart-raster-tiler
	kubectl apply -f nexus.yaml -n quickstart-user-profile-api
	kubectl apply -f nexus.yaml -n quickstart-event-api

create-ns-required-for-pull-secrets: #TODO remove once all images are at ghcr.io
	if kubectl get ns quickstart-keycloak >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-keycloak; fi;
	if kubectl get ns quickstart-epig >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-epig; fi;
	if kubectl get ns quickstart-osrm >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-osrm; fi;
	if kubectl get ns quickstart-basemap >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-basemap; fi;
	if kubectl get ns quickstart-insights-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-insights-api; fi;
	if kubectl get ns quickstart-isochrone-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-isochrone-api; fi;
	if kubectl get ns quickstart-layers-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-layers-api; fi;
	if kubectl get ns quickstart-layers-db >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-layers-db; fi;
	if kubectl get ns quickstart-raster-tiler >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-raster-tiler; fi;
	if kubectl get ns quickstart-user-profile-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-user-profile-api; fi;
	if kubectl get ns quickstart-event-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-event-api; fi;

##CLEANUP#
cleanup-namespaces:
	if kubectl get ns quickstart-insights-api >& /dev/null; then kubectl delete ns quickstart-insights-api; fi;
	if kubectl get ns quickstart-isochrone-api >& /dev/null; then kubectl delete ns quickstart-isochrone-api; fi;
	if kubectl get ns quickstart-layers-api >& /dev/null; then kubectl delete ns quickstart-layers-api; fi;
	if kubectl get ns quickstart-layers-db >& /dev/null; then kubectl delete ns quickstart-layers-db; fi;
	if kubectl get ns quickstart-osrm >& /dev/null; then kubectl delete ns quickstart-osrm; fi;
	if kubectl get ns quickstart-basemap >& /dev/null; then kubectl delete ns quickstart-basemap; fi;
	if kubectl get ns quickstart-epig >& /dev/null; then kubectl delete ns quickstart-epig; fi;
	if kubectl get ns quickstart-layers-tiles-api >& /dev/null; then kubectl delete ns quickstart-layers-tiles-api; fi;
	if kubectl get ns quickstart-raster-tiler >& /dev/null; then kubectl delete ns quickstart-raster-tiler; fi;
	if kubectl get ns quickstart-titiler >& /dev/null; then kubectl delete ns quickstart-titiler; fi;
	if kubectl get ns quickstart-user-profile-api >& /dev/null; then kubectl delete ns quickstart-user-profile-api; fi;
	if kubectl get ns quickstart-event-api >& /dev/null; then kubectl delete ns quickstart-event-api; fi;
	if kubectl get ns quickstart-disaster-ninja >& /dev/null; then kubectl delete ns quickstart-disaster-ninja; fi;

cleanup-databases:
	psql -d postgres -c "DROP DATABASE IF EXISTS keycloak;";
	psql -d postgres -c "DROP DATABASE IF EXISTS event_api;";
	psql -d postgres -c "DROP DATABASE IF EXISTS \"insights-api\";";
	psql -d postgres -c "DROP DATABASE IF EXISTS gis;";
	psql -d postgres -c "DROP DATABASE IF EXISTS \"layers-db\";";
	psql -d postgres -c "DROP DATABASE IF EXISTS \"user-profile-api\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"keycloak\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"event_api_user01\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"insights-api\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"isochrone-api\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"layers-db\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"layers-api\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"layers-tiles-api\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"mosaic\";";
	psql -d postgres -c "DROP ROLE IF EXISTS \"user-profile-api\";";

##Create databases and roles
create-all-dbs: create-event-api-db \
				create-insights-api-db \
				create-keycloak-db \
				create-layers-db \
				create-layers-api-user \
				create-layers-tiles-api-user \
				create-mosaic-user \
				create-user-profile-api-db \
				create-isochrone-api-db

create-event-api-db:
	psql -d postgres -c "CREATE USER event_api_user01 WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE event_api WITH OWNER event_api_user01;";
	psql -d "event_api" -c "CREATE EXTENSION postgis;";
	psql -d "event_api" -c "CREATE EXTENSION \"uuid-ossp\";"
	psql -d "event_api" -c "CREATE EXTENSION btree_gin;";
	psql -d "event_api" -c "CREATE EXTENSION btree_gist;";

create-insights-api-db:
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

create-layers-db:
	psql -d postgres -c "CREATE USER \"layers-db\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE \"layers-db\" WITH OWNER \"layers-db\";";
	psql -d "layers-db" -c "CREATE EXTENSION postgis;";
	psql -d "layers-db" -c "CREATE EXTENSION btree_gin;";
	psql -d "layers-db" -c "CREATE EXTENSION btree_gist;";
	psql -d "layers-db" -c "CREATE EXTENSION h3;";
	psql -d "layers-db" -c "CREATE EXTENSION h3_postgis;";

create-layers-api-user: create-layers-db
	psql -d "layers-db" -c "CREATE USER \"layers-api\" WITH PASSWORD 'password';"
	psql -d "layers-db" -c "GRANT USAGE ON SCHEMA public TO \"layers-api\";"
	psql -d "layers-db" -c "ALTER DEFAULT PRIVILEGES FOR ROLE \"layers-db\" IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO \"layers-api\";"
	psql -d "layers-db" -c "ALTER DEFAULT PRIVILEGES FOR ROLE \"layers-db\" IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO \"layers-api\";"
	psql -d "layers-db" -c "ALTER DEFAULT PRIVILEGES FOR ROLE \"layers-api\" IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO \"layers-db\";"
	psql -d "layers-db" -c "ALTER DEFAULT PRIVILEGES FOR ROLE \"layers-api\" IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO \"layers-db\";"

create-layers-tiles-api-user: create-layers-db
	psql -d "layers-db" -c "CREATE USER \"layers-tiles-api\" WITH PASSWORD 'password';"
	psql -d "layers-db" -U "layers-db" -c "ALTER DEFAULT PRIVILEGES FOR ROLE \"layers-db\" IN SCHEMA public GRANT SELECT ON TABLES TO \"layers-tiles-api\";"
	psql -d "layers-db" -U "layers-api" -c "ALTER DEFAULT PRIVILEGES FOR ROLE \"layers-api\" IN SCHEMA public GRANT SELECT ON TABLES TO \"layers-tiles-api\";"

create-mosaic-user: create-layers-db
	psql -d "layers-db" -c "CREATE USER \"mosaic\" WITH PASSWORD 'password';"
	psql -d "layers-db" -U "layers-db" -c "ALTER DEFAULT PRIVILEGES FOR ROLE \"layers-db\" IN SCHEMA public GRANT SELECT ON TABLES TO \"mosaic\";"
	psql -d "layers-db" -U "layers-api" -c "ALTER DEFAULT PRIVILEGES FOR ROLE \"layers-api\" IN SCHEMA public GRANT SELECT ON TABLES TO \"mosaic\";"

create-user-profile-api-db:
	psql -d postgres -c "CREATE USER \"user-profile-api\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE \"user-profile-api\" WITH OWNER \"user-profile-api\";";
	psql -d "user-profile-api" -c "CREATE EXTENSION postgis;";

create-keycloak-db:
	psql -d postgres -c "CREATE USER \"keycloak\" WITH PASSWORD 'password';"
	psql -d postgres -c "CREATE DATABASE \"keycloak\" WITH OWNER \"keycloak\";";

##Helm Releases
helm-install-quickstart-all: epig \
							 layers-api \
							 user-profile-api \
							 disaster-ninja-be \
							 disaster-ninja-fe \
						     event-api \
							 insights-api \
							 layers-db-etl \
							 layers-tiles-api \
							 titiler \
							 raster-tiler \
							 keycloak \
							 osrm \
							 basemap \
							 isochrone-api

#dependencies below are very rough

disaster-ninja-be: insights-api layers-api user-profile-api event-api keycloak
	if kubectl get ns quickstart-disaster-ninja >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-disaster-ninja; fi;
	helm upgrade --install quickstart-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-quickstart.yaml -n quickstart-disaster-ninja
disaster-ninja-fe: disaster-ninja-be epig basemap
	if kubectl get ns quickstart-disaster-ninja >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-disaster-ninja; fi;
	helm upgrade --install quickstart-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml -f disaster-ninja-fe/values/values-quickstart.yaml -n quickstart-disaster-ninja
epig: create-image-pull-secrets
	if kubectl get ns quickstart-epig >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-epig; fi;
	helm upgrade --install quickstart-epig epig -f epig/values.yaml -f epig/values/values-quickstart.yaml -n quickstart-epig
event-api: create-event-api-db create-image-pull-secrets insights-api keycloak
	if kubectl get ns quickstart-event-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-event-api; fi;
	helm upgrade --install quickstart-event-api event-api -f event-api/values.yaml -f event-api/values/values-quickstart.yaml -n quickstart-event-api
insights-api: create-insights-api-db create-image-pull-secrets
	if kubectl get ns quickstart-insights-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-insights-api; fi;
	helm upgrade --install quickstart-insights-api insights-api -f insights-api/values.yaml -f insights-api/values/values-quickstart.yaml -n quickstart-insights-api
layers-api: create-layers-db create-layers-api-user create-image-pull-secrets
	if kubectl get ns quickstart-layers-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-layers-api; fi;
	helm upgrade --install quickstart-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-quickstart.yaml -n quickstart-layers-api
layers-db-etl: create-layers-db create-image-pull-secrets
	if kubectl get ns quickstart-layers-db >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-layers-db; fi;
	helm upgrade --install quickstart-layers-db-etl layers-db-etl -f layers-db-etl/values.yaml -f layers-db-etl/values/values-quickstart.yaml -n quickstart-layers-db
layers-tiles-api: create-layers-tiles-api-user
	if kubectl get ns quickstart-layers-tiles-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-layers-tiles-api; fi;
	helm upgrade --install quickstart-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-quickstart.yaml -n quickstart-layers-tiles-api
raster-tiler: create-image-pull-secrets create-mosaic-user titiler
	if kubectl get ns quickstart-raster-tiler >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-raster-tiler; fi;
	helm upgrade --install quickstart-raster-tiler raster-tiler -f raster-tiler/values.yaml -f raster-tiler/values/values-quickstart.yaml -n quickstart-raster-tiler
titiler:
	if kubectl get ns quickstart-titiler >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-titiler; fi;
	helm upgrade --install quickstart-titiler titiler -f titiler/values.yaml -f titiler/values/values-quickstart.yaml -n quickstart-titiler
user-profile-api: create-image-pull-secrets create-user-profile-api-db keycloak
	if kubectl get ns quickstart-user-profile-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-user-profile-api; fi;
	helm upgrade --install quickstart-user-profile-api user-profile-api -f user-profile-api/values.yaml -f user-profile-api/values/values-quickstart.yaml -n quickstart-user-profile-api
keycloak: create-image-pull-secrets create-keycloak-db create-user-profile-api-db
	if kubectl get ns quickstart-keycloak >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-keycloak; fi;
	helm upgrade --install quickstart-keycloak keycloak -f keycloak/values.yaml -f keycloak/values/values-quickstart.yaml -n quickstart-keycloak
isochrone-api: osrm create-isochrone-api-db create-image-pull-secrets
	if kubectl get ns quickstart-isochrone-api >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-isochrone-api; fi;
	helm upgrade --install quickstart-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-quickstart.yaml -n quickstart-isochrone-api
osrm: create-image-pull-secrets
	if kubectl get ns quickstart-osrm >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-osrm; fi;
	helm upgrade --install quickstart-osrm osrm -f osrm/values.yaml -f osrm/values/values-quickstart.yaml -n quickstart-osrm
basemap: create-image-pull-secrets
	if kubectl get ns quickstart-basemap >& /dev/null; then echo NS already exists; else kubectl create ns quickstart-basemap; fi;
	helm upgrade --install quickstart-basemap basemap -f basemap/values.yaml -f basemap/values/values-quickstart.yaml -n quickstart-basemap

####### GOALS FOR TEMPLATES TESTING #######
template-all: delete-files kustomize-flux template-dev template-test template-prod template-local template-quickstart

delete-files:
	rm -f dev.yaml
	rm -f test.yaml
	rm -f prod.yaml
	rm -f local.yaml
	rm -f quickstart.yaml
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
	#helm template dev-keycloak keycloak -f keycloak/values.yaml -f keycloak/values/values-dev.yaml >> dev.yaml
	helm template dev-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-dev.yaml >> dev.yaml
	helm template dev-layers-db-etl layers-db-etl -f layers-db-etl/values.yaml -f layers-db-etl/values/values-dev.yaml >> dev.yaml
	helm template dev-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-dev.yaml >> dev.yaml
	helm template dev-osrm osrm -f osrm/values.yaml -f osrm/values/values-dev.yaml >> dev.yaml
	helm template dev-basemap basemap -f basemap/values.yaml -f basemap/values/values-dev.yaml >> dev.yaml
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
	#helm template test-keycloak keycloak -f keycloak/values.yaml -f keycloak/values/values-test.yaml >> test.yaml
	helm template test-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-test.yaml >> test.yaml
	helm template test-layers-db-etl layers-db-etl -f layers-db-etl/values.yaml -f layers-db-etl/values/values-test.yaml >> test.yaml
	helm template test-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-test.yaml >> test.yaml
	#helm template test-osrm osrm -f osrm/values.yaml -f osrm/values/values-test.yaml >> test.yaml
	helm template test-basemap basemap -f basemap/values.yaml -f basemap/values/values-test.yaml >> test.yaml
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
	#helm template prod-keycloak keycloak -f keycloak/values.yaml -f keycloak/values/values-prod.yaml >> prod.yaml
	helm template prod-layers-api layers-api -f layers-api/values.yaml -f layers-api/values/values-prod.yaml >> prod.yaml
	helm template prod-layers-db-etl layers-db-etl -f layers-db-etl/values.yaml -f layers-db-etl/values/values-prod.yaml >> prod.yaml
	helm template prod-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-prod.yaml >> prod.yaml
	#helm template prod-osrm osrm -f osrm/values.yaml -f osrm/values/values-prod.yaml >> prod.yaml
	helm template prod-basemap basemap -f basemap/values.yaml -f basemap/values/values-prod.yaml >> prod.yaml
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
	#helm template local-keycloak keycloak -f keycloak/values.yaml -f keycloak/values/values-local.yaml >> local.yaml
	helm template local-layers-api layers-api -f layers-api/values.yaml >> local.yaml
	helm template local-layers-db-etl layers-db-etl -f layers-db-etl/values.yaml >> local.yaml
	helm template local-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-local.yaml >> local.yaml
	#helm template local-osrm osrm -f osrm/values.yaml -f osrm/values/values-local.yaml >> local.yaml
	helm template local-basemap basemap -f basemap/values.yaml -f basemap/values.yaml >> local.yaml
	helm template local-raster-tiler raster-tiler -f raster-tiler/values.yaml >> local.yaml
	helm template local-titiler titiler -f titiler/values.yaml >> local.yaml
	helm template local-user-profile-api user-profile-api -f user-profile-api/values.yaml >> local.yaml

template-quickstart:
	helm template quickstart-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-quickstart.yaml >> quickstart.yaml
	helm template quickstart-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml >> quickstart.yaml
	helm template quickstart-epig epig -f epig/values.yaml -f epig/values/values-quickstart.yaml >> quickstart.yaml
	helm template quickstart-event-api event-api -f event-api/values.yaml >> quickstart.yaml
	helm template quickstart-insights-api insights-api -f insights-api/values.yaml >> quickstart.yaml
	helm template quickstart-isochrone-api isochrone-api -f isochrone-api/values.yaml -f isochrone-api/values/values-quickstart.yaml >> quickstart.yaml
	helm template quickstart-keycloak keycloak -f keycloak/values.yaml -f keycloak/values/values-quickstart.yaml >> quickstart.yaml
	helm template quickstart-layers-api layers-api -f layers-api/values.yaml >> quickstart.yaml
	helm template quickstart-layers-db-etl layers-db-etl -f layers-db-etl/values.yaml >> quickstart.yaml
	helm template quickstart-layers-tiles-api layers-tiles-api -f layers-tiles-api/values.yaml -f layers-tiles-api/values/values-quickstart.yaml >> quickstart.yaml
	helm template quickstart-osrm osrm -f osrm/values.yaml -f osrm/values/values-quickstart.yaml >> quickstart.yaml
	helm template quickstart-basemap basemap -f basemap/values.yaml -f basemap/values/values-quickstart.yaml >> quickstart.yaml
	helm template quickstart-raster-tiler raster-tiler -f raster-tiler/values.yaml >> quickstart.yaml
	helm template quickstart-titiler titiler -f titiler/values.yaml >> quickstart.yaml
	helm template quickstart-user-profile-api user-profile-api -f user-profile-api/values.yaml >> quickstart.yaml

#end of testing goals