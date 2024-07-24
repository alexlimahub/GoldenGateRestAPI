# GoldenGate RestAPI
Examples of RestAPI for Oracle GoldenGate \
The Oracle GoldenGate REST API is a set of web services that enable you to manage and monitor Oracle GoldenGate deployments and replication processes programmatically. \
It provides a way to interact with GoldenGate's Microservices Architecture, giving you control over various aspects of data replication and integration.

### Key features and capabilities of the REST API include:

* Deployment Management: Create, update, and delete Oracle GoldenGate Distribution Paths, which define the flow of data replication.
* Monitoring: Retrieve statistics, information, and checkpoints related to distribution paths, processes, trails, and other components.
* Administration: Manage the status of distribution paths, control replication processes, and configure various settings.

## Where to find more information:

### Oracle GoldenGate Microservices Architecture REST API Documentation:
Version 23ai: https://docs.oracle.com/en/middleware/goldengate/core/23/oggra/ \
Version 21.3: https://docs.oracle.com/en/middleware/goldengate/core/21.3/oggra/ \
Version 19.1: https://docs.oracle.com/en/middleware/goldengate/core/19.1/oggra/ \
Blog Post: "See How Easily You Can Use Oracle GoldenGate Rest API": https://blogs.oracle.com/dataintegration/post/see-how-easily-you-can-use-oracle-goldengate-rest-api

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


