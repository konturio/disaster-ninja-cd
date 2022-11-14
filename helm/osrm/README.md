# OSRM

There are four applications in this chart:
1. ```pbf-downloader``` (CronJob): downloads PBF file
2. ```osrm-preprocessor``` (CronJob): preprocesses PBF into OSRM-supported format
3. ```osrm-backend``` (Deployment): OSRM API itself
4. ```osrm-restarter``` (CronJob): restarts OSRM API periodically

There is no special mechanics to move huge PVC between nodes - so for now ```pbf-downloader```, ```osrm-preprocessor``` and ```osrm-backend``` should run at the same node.

## pbf-downolader
See https://github.com/konturio/isochrone-api/blob/develop/osrm-pipeline/README.md#pbf-downloader for description and environment variables available

Downloads AOI PBF and puts into ```PVC 1```
> Planet PBF file size is ~66Gi

## osrm-preprocessor
See https://github.com/konturio/isochrone-api/blob/develop/osrm-pipeline/README.md#pbf-downloader for description and environment variables available

Performs OSRM preprocessing for PBF from ```PVC 1``` if download by ```pbf-downloader``` succeeded and puts output into ```PVC 2```

**Unfortunately does not support updates of any kind - so first PBF file has to be updated by any tool, then the entire preprocessing has to be rerun** 

> Resource consumption:
Processing the entire planet PBF requires 385Gi RAM for ```car.lua``` and ```motorcycle.lua``` profiles and even more for bicycle (> 450Gi). No ```--mmap``` option is available. Resulting files take ~310Gi on disk.

## osrm-backend
OSRM API: https://github.com/Project-OSRM/osrm-backend

Starts only if preprocessing by ```osrm-preprocessor``` succeeded and required data is available in ```PVC 2```

> When started without the ```--mmap``` option - takes ~170Gi RAM to start (given input files from previous step took ~310Gi on disk - entire planet dataset).

## osrm-restarter
Restarts OSRM backend deployment if OSRM preprocessing succeeded (if there is no ```aoi.pbf.lock``` and there is ```aoi.osrm.preprocessed``` in ```PVC 2``` )