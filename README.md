# GoldenGateRestAPI
Examples of RestAPI for GoldenGate

## Disclaimer 
These examples are for educational purposes. \
They are not intended for production deployments and are not supported by Oracle or myself.  \
Before deploying it to any production environment, make sure to thoroughly test and validate it in your environment.

## Generic Scripts
* Create Extract
* Delete Extract
* Info Checkpoint
* Purge Trails
* Lag Checks
* Info Checks
* Create Replicat
* Delete Replicat
* Check for long Transactions
* View Log File
* Modify Session Timeout

## Custom Scripts
* create_replication.sh script is a complete bi-direction configuration with output from terraform (Shell Script)
* OpenTransaction.py and check_gg_longtransations.ph are scripts to check if there is an open transaction in the database (Python)
* check_gg_processes.py is a script to check the HUB process status with custom output


