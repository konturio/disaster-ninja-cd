# Layers DB and API deployment

Field: Content

## Layers-DB

GIT repo <https://gitlab.com/kontur-private/platform/layers-db> 
* Preparation step
  * yum install parallel
  * Create roles and database using V0.1__roles_and_db_creation.sql file from  task <https://kontur.fibery.io/Tasks/Task/Set-up-LayersDB-8257>
  * add database credentials for layers-db linux user to .pgpass file
  * Create tables, functions and initial table filling using V0.2__tables_creation.sql
* Run CI deploy stage https://gitlab.com/kontur-private/platform/layers-db/-/pipelines. Add new staging to the deploy stage beforehand if needed.

## [pg_tileserv](https://github.com/CrunchyData/pg_tileserv "https://github.com/CrunchyData/pg_tileserv") installation
* Create DB user for pg_tileserv with read access to tile serving function (ask someone with superuser access).
  * Query example:

    ```
    CREATE USER "layers-db-tileserver" WITH PASSWORD 'XXX' LOGIN;
    
    GRANT EXECUTE ON FUNCTION hot_projects(integer, integer, integer) TO "layers-db-tileserver";
    
    GRANT SELECT ON layers_features TO "layers-db-tileserver";
    ```
* login under `layers-tiles-api` user
* create folder with the latest pg_tileserv version number, e.g. `mkdir v1.0.8`
* download and unzip pg_tileserv into version directory
  * `wget `[`https://postgisftw.s3.amazonaws.com/pg_tileserv_latest_linux.zip`](https://postgisftw.s3.amazonaws.com/pg_tileserv_latest_linux.zip)
  * `unzip pg_tileserv_latest_linux.zip`
* create symlink to version folder `ln -s v1.0.8/ current`
* move config file into user root directory `mv current/config/pg_tileserv.toml.example config.toml`
* update config.toml
  * Set up DB connection
  * `DbPoolMaxConnLifeTime = "10m"`
  * `DbPoolMaxConns = 10`
  * `HttpPort = 8629`
  * `BasePath = "/tiles"` 
* Configure systemd for the service
  * create `.config/systemd/user/layers-tiles-api.service` file with content:

    ```
    [Unit]
    Description=pg_tileserv: MVT tiles serving service for Layers-DB
    
    [Service]
    Type=simple
    
    TimeoutStartSec=infinity
    ExecStart=%h/current/pg_tileserv --config %h/config.toml
    
    [Install]
    WantedBy=default.target
    ```
  * reload configuration `systemctl --user daemon-reload`
  * and start the service `systemctl --user start layers-tiles-api.service`
  * register service for autostart `systemctl --user enable --now layers-tiles-api.service` 

## Layers-API

GIT repo <https://gitlab.com/kontur-private/platform/layers-api> 
* Preparation step
  * API doesn't contain any migration scripts for DB. So Layers-DB should be installed first. 
  * Create new DB user for Layers-DB with read and write access.
* Run CI deploy stage <https://gitlab.com/kontur-private/platform/layers-api/-/pipelines>. Add new staging to the deploy stage beforehand if needed.
* On first run new `config.local.yaml` config file will be created. Otherwise required configuration parameters can be found in `/src/main/resources/external/config.yaml` file in the repo
  * Update this config file with required properties
  * restart application to apply new properties `systemctl --user restart layers-api.service`

