#############################################################################################
# GoldenGate HUB Check Long Transactions
#
# Author: Alex Lima
# 
# Execution: $python3 check_gg_longtransactions.py
#
############################################################################################

import requests
import json
import os

# Clearing the Screen
os.system('clear')

# Disable Warning for InsecureRequestWarning certificate verification
requests.packages.urllib3.disable_warnings()

# Url and PORT for GOldengate HUB
goldengate_hub_url="https://<ip or hostname>"

# Authentication
header = {"Authorization" : "Basic <Encoded username:password>"}
##---

# DIsplay the Header content
def display_header():
 print("---------------------------------------------------------")
 print("-- GoldenGate HUB Status for " + goldengate_hub_url)
 print("---------------------------------------------------------")
 print()
 print(f"{'Process Type':16s}", f"{'Process Name':15s}", f"{'Status':12s}", f"{'Sequence':12s}", f"{'RBA':12s}", 
       f"{'Lag in Sec':12s}", f"{'Since Last Checkpoint':23s}", f"{'File Name':10s}", f"{'Connection':15s}" ) 
 print ("="*135)  

# Print Extract and Replicat Processes Status
def print_proc_status(proc_name, hub_url, proc_type):
 url = hub_url + "/" + proc_name
 url_info = hub_url + "/" + proc_name + "/info/status"

 # print (url + "     " + url_info)
 response = requests.get(url, verify=False, headers=header)
 response_info = requests.get(url, verify=False, headers=header)
 #response = requests.post(url, verify=False, headers=header)

 #If full response display is required
 #print(json.dumps(response.json(), indent=4))
 #print(json.dumps(response_info.json(), indent=4))

 # Formated Response
 ##  Config for the Extract Formating
 if (proc_type == "extract"):
  rdata=response.json()
  rstatus = rdata['response']['status']
  rfilename = rdata['response']['targets'][0]['name']
  rsequence = rdata['response']['targets'][0]['sequence']
  roffset = rdata['response']['targets'][0]['offset']
  ralias = rdata['response']['credentials']['alias']
  
  rdata_info=response_info.json()
  rlag = rdata_info['response']['lag']
  rlagSinceCheckpoint = rdata_info['response']['sinceLagReported']
 else:
## Config for the Replicat Formating
  rdata_info=response_info.json()
  rdata=response.json()
  rstatus = rdata_info['response']['status']
  rfilename = rdata_info['response']['position']['name']
  rsequence = rdata_info['response']['position']['sequence']
  roffset = rdata_info['response']['position']['offset']
  ralias = rdata['response']['credentials']['alias']
  rlag = rdata_info['response']['lag']
  rlagSinceCheckpoint = rdata_info['response']['sinceLagReported']

## Print the Process Status
 print(f"{proc_type.upper():16s}",f"{proc_name:15s}", f"{rstatus.upper():12s}",f"{rsequence:<12d}",
       f"{roffset:<12d}",f"{rlag:<12d}",f"{rlagSinceCheckpoint:<23d}",f"{rfilename:10s}", f"{ralias:15s}")

# Check how many processes exist and loop through each one for status reporting
def check_ggprocess(ggprocess):
  hub_url = goldengate_hub_url + "/services/v2/mpoints/EWEST/currentInflightTransactions"

  response = requests.get(hub_url, verify=False , headers=header).text
  response_info = json.loads(response)

  #print(response_info)
  print("Current In Flight Transactions")
  print("="*50)
  print("XID:         " + response_info['response']['currentInflightTransactions'][0]['xid'])
  print("Extract:     " + response_info['response']['currentInflightTransactions'][0]['extract'])
  print("Redo Thread: " + str(response_info['response']['currentInflightTransactions'][0]['redoThread']))
  print("Start Time:  " + response_info['response']['currentInflightTransactions'][0]['startTime'])
  print("Redo Seq:    " + str(response_info['response']['currentInflightTransactions'][0]['redoSeq']))
  print("SCN:         " + response_info['response']['currentInflightTransactions'][0]['scn'])
  print("Redo RBA:    " + str(response_info['response']['currentInflightTransactions'][0]['redoRba']))
  print("Status:      " + response_info['response']['currentInflightTransactions'][0]['status'])
  # Loop along dictionary keys
  #i = 0
  #while i < len(response_info['response']['replyData']['currentInflightTransactions']):
# #   print_proc_status(response_info['response']['items'][i]['name'], hub_url, ggprocess)
  #  print(response_info['response']['items'][i]['name'])
  #  i += 1

# Main
#display_header()
check_ggprocess("extract")
#check_ggprocess("replicat")
print()
print()
