#############################################################################################
# GoldenGate HUB Check Extract and Replicats
#
# Author: Alex Lima
# 
# Execution: $python3 check_gg_processes.py
#
# Config: Set GoldenGate HUR URL, PORT and Authentication:  goldengate_hub_url and header
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
goldengate_hub_url="https://<IP or hostname>"

# Authentication
header = {"Authorization" : "Basic b2dnYWRtaW46eTR2RkdoV242SUNTLXNxZA=="}
##---

# DIsplay the Header content
def display_header():
 print("---------------------------------------------------------")
 print("-- GoldenGate HUB Status for " + goldengate_hub_url)
 print("---------------------------------------------------------")
 print()
 print(f"{'Process Type':13s}", f"{'Process Name':13s}", f"{'Status':10s}", f"{'Sequence':12s}", f"{'RBA':12s}", 
       f"{'Lag in Sec':12s}", f"{'Since Last Checkpoint':23s}", f"{'File Name':10s}", f"{'Connection':15s}" ) 
 print ("="*135)  

# Print Extract and Replicat Processes Status
def print_proc_status(proc_name, hub_url, proc_type):
 url = hub_url + "/" + proc_name
 url_info = hub_url + "/" + proc_name + "/info/status"
 #print (url + "     " + url_info)

 response = requests.get(url, verify=False, headers=header)
 response_info = requests.get(url_info, verify=False, headers=header)

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
 print(f"{proc_type.upper():13s}",f"{proc_name:13s}", f"{rstatus.upper():10s}",f"{rsequence:<12d}",
       f"{roffset:<12d}",f"{rlag:<12d}",f"{rlagSinceCheckpoint:<23d}",f"{rfilename:10s}", f"{ralias:15s}")

# Check how many processes exist and loop through each one for status reporting
def check_ggprocess(ggprocess):
  if (ggprocess == "extract"):
   hub_url = goldengate_hub_url +"/services/v2/extracts"
  else:
   hub_url = goldengate_hub_url +"/services/v2/replicats"

  response = requests.get(hub_url, verify=False, headers=header).text
  response_info = json.loads(response)

  # Loop along dictionary keys
  i = 0
  while i < len(response_info['response']['items']):
    print_proc_status(response_info['response']['items'][i]['name'], hub_url, ggprocess)
    i += 1

# Main
display_header()
check_ggprocess("extract")
check_ggprocess("replicat")
print()
print()
