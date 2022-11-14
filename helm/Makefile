#Makefile for local installation

install-local: create-local-secrets create-psql-databases local-all

create-local-secrets:
	kubectl apply -f blabla.yaml

create-psql-databases:
	#TODO should use passwords the same as in secrets in create-local-secrets
	psql

local-all: disaster-ninja-be disaster-ninja-fe epig event-api insights-api isochrone-api layers-api layers-tiles-api osrm raster-tiler titiler user-profile-api keycloak

#TODO dependencies below are very rough

disaster-ninja-be: user-profile-api keycloak event-api insights-api layers-api
	helm install local-disaster-ninja-be disaster-ninja-be -f disaster-ninja-be/values.yaml -f disaster-ninja-be/values/values-local.yaml
disaster-ninja-fe: disaster-ninja-be epig
	helm install local-disaster-ninja-fe disaster-ninja-fe -f disaster-ninja-fe/values.yaml -f disaster-ninja-fe/values/values-local.yaml
epig:
	helm install local-epig epig -f epig/values.yaml -f epig/values/values-local.yaml
event-api:
	helm install local-event-api event-api -f event-api/values.yaml -f event-api/values/values-local.yaml
insights-api:
	helm install local-insights-api insights-api -f insights-api/values.yaml -f insights-api/values/values-local.yaml
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