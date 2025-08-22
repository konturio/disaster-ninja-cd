# Restoring PGO Postgres database from backup

The backup can be restored using pgbackrest, which is integrated into PGO.

1. Install pgo-client utility: <https://github.com/CrunchyData/postgres-operator-client> 
2. Run the following command to get the name of the cluster:

   ```
   kubectl get postgrescluster -n <namespace>
   ```

   Example:

   ```
   $ kubectl get postgrescluster -n dev-user-profile-api-exp
   NAME                      AGE
   db-user-profile-api-exp   35d
   ```
3. List the backups using pgo-cli utility:

   ```
   pgo show backup <cluster-name> -n <namespace>
   ```

   Example:

   ```
     $ pgo show backup -n dev-user-profile-api-exp db-user-profile-api-exp
   stanza: db
       status: ok
       cipher: none
   
       db (current)
           wal archive min/max (16): 000000010000000000000009/0000001400000000000000C6
       ...
           incr backup: 20240821-180010F_20240822-200009I
               timestamp start/stop: 2024-08-22 20:00:09+00 / 2024-08-22 20:00:12+00
               wal start/stop: 0000000E0000000000000053 / 0000000E0000000000000054
               database size: 63.3MB, database backup size: 85.6KB
               repo2: backup set size: 7.6MB, backup size: 8.9KB
               backup reference list: 20240821-180010F, 20240821-180010F_20240821-200010I
   
           full backup: 20240904-134321F
               timestamp start/stop: 2024-09-04 13:43:21+00 / 2024-09-04 13:46:32+00
               wal start/stop: 0000001400000000000000C4 / 0000001400000000000000C5
               database size: 71.5MB, database backup size: 71.5MB
               repo2: backup set size: 7.9MB, backup size: 7.9MB
   ```
4. Restore the desired backup by specifiyng its backup set ID with the following command:

   ```
   pgo restore -n <namespace> <cluster-name> --repoName repo2 --options '--set="BACKUP_SET_ID"'
   ```

   Example:

   ```
     $ pgo restore -n dev-user-profile-api-exp db-user-profile-api-exp --repoName repo2 --options '--set="20240904-134321F"'                                                  !31116
   WARNING: You are about to restore from pgBackRest with {options:[--set="20240904-134321F"] repoName:repo2}
   WARNING: This action is destructive and PostgreSQL will be unavailable while its data is restored.
   
   Do you want to continue? (yes/no): yes
   postgresclusters/db-user-profile-api-exp patched
   ```

   A pod will then start, where the backup restoration process will run:

   ```
     $ k get pods -n dev-user-profile-api-exp
   NAME                                                READY   STATUS            RESTARTS   AGE
   ...
   db-user-profile-api-exp-pgbackrest-restore-ccl4s    1/1     Running   0          6s
   ...
   ```
5.  To check if the backup restoration process completed successfully, check the events:

   ```
   $ kubectl get event -n dev-user-profile-api-exp
   28m         Normal    Completed          job/db-user-profile-api-exp-pgbackrest-restore         Job completed
   28m         Normal    StanzasCreated     postgrescluster/db-user-profile-api-exp                pgBackRest stanza creation completed successfully
   ```
