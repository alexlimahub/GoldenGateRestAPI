# GoldenGate RestAPI
Examples of RestAPI for Oracle GoldenGate 

The Oracle GoldenGate REST API is a set of web services that enable programmatic management and monitoring of Oracle GoldenGate deployments and replication processes.
It provides a way to interact with GoldenGate's Microservices Architecture, giving you control over various data replication and integration aspects.

### Key features and capabilities of the REST API include:

The Oracle GoldenGate REST API is a comprehensive solution to remote control your GoldenGate environment. It allows you to create, manage, and monitor replication processes, fine-tune parameters, and access real-time performance metrics. Additionally, it enables security configuration, automated actions (my favorite part), and seamless integration with other deployments. This API is a powerful tool for centrally managing and optimizing data replication processes with Oracle GoldenGate.

## Where to find more information:

### Oracle GoldenGate Microservices Architecture REST API Documentation:
* Version 23ai: https://docs.oracle.com/en/middleware/goldengate/core/23/oggra/ 
* Version 21.3: https://docs.oracle.com/en/middleware/goldengate/core/21.3/oggra/ 
* Version 19.1: https://docs.oracle.com/en/middleware/goldengate/core/19.1/oggra/ 
* Blog Post: "See How Easily You Can Use Oracle GoldenGate Rest API": \
  https://blogs.oracle.com/dataintegration/post/see-how-easily-you-can-use-oracle-goldengate-rest-api

## Disclaimer 
These examples are for **educational purposes**. \
They are not intended for production deployments and are not supported by Oracle or myself.  \
Before deploying it to any production environment, make sure to test and validate it thoroughly in your environment.

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
* ***create_replication.sh*** script is a complete bi-direction configuration with output from terraform (Shell Script)
* ***OpenTransaction.py*** and ***check_gg_longtransations.sh*** are scripts to check if there is an open transaction in the database (Python)
* ***check_gg_processes.py*** is a script to check the HUB process status with custom output


