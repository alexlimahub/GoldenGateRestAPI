#############################################################################################
# GoldenGate HUB Check Extract and Replicats
#
# Author: Alex Lima
#
# Execution: $python3 OpenTransaction.py
#
# Config: Set GoldenGate HUR URL, PORT and Authentication:  goldengate_hub_url and header
#
############################################################################################

import requests
import json
import os
import cx_Oracle

# Clearing the Screen
os.system('clear')

# Disable Warning for InsecureRequestWarning certificate verification
requests.packages.urllib3.disable_warnings()

# Url and PORT for GOldengate HUB
goldengate_hub_url="https://150.230.169.166"

# Authentication
header = {"Authorization" : "Basic b2dnYWRtaW46eTR2RkdoV242SUNTLXNxZA=="}
##---

# Extract Name for testing purposes
ext_name = "EWEST"

hub_url = goldengate_hub_url + "/services/v2/mpoints/"+ ext_name +"/currentInflightTransactions"
response = requests.get(hub_url, verify=False , headers=header).text
response_info = json.loads(response)

if (len(response_info['messages']) < 1):

    #print(len(response_info['response']['currentInflightTransactions']))
    print("Current In Flight Transactions")
    print("="*51)
    
    # Loop along dictionary keys
    i = 0
    while i < len(response_info['response']['currentInflightTransactions']):
    #    print_proc_status(response_info['response']['items'][i]['name'], hub_url, ggprocess)
    #print(response_info)
        print("XID:         " +     response_info['response']['currentInflightTransactions'][0]['xid'])
        print("Extract:     " +     response_info['response']['currentInflightTransactions'][0]['extract'])
        print("Redo Thread: " + str(response_info['response']['currentInflightTransactions'][0]['redoThread']))
        print("Start Time:  " +     response_info['response']['currentInflightTransactions'][0]['startTime'])
        print("Redo Seq:    " + str(response_info['response']['currentInflightTransactions'][0]['redoSeq']))
        print("SCN:         " +     response_info['response']['currentInflightTransactions'][0]['scn'])
        print("Redo RBA:    " + str(response_info['response']['currentInflightTransactions'][0]['redoRba']))
        print("Status:      " +     response_info['response']['currentInflightTransactions'][0]['status'])
        print()
        i += 1

        conn = cx_Oracle.connect(
        'soe/soe@//oggfreedb2.subnet1.alimavcn.oraclevcn.com:1521/DBFREE_iad1bp.subnet1.alimavcn.oraclevcn.com')
else:
    print("="*51)
    print("###### OGG-25166: No Long Transaction Found #######")
    print("="*51)
    print()


