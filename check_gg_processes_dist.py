#########################################################################################################################################
# GoldenGate Check Extract and Replicats
#
# Author: Alex Lima
# 
# Execution: $python3 check_gg_processes_dist.py
#
# Config: Set GoldenGate Source and Target URL, PORT and Authentication:  goldengate_hub_url_source, goldengate_hub_url_target and header
#
##########################################################################################################################################

import requests
import json
import os

# Clearing the Screen
os.system('clear')

# Disable Warning for InsecureRequestWarning certificate verification
requests.packages.urllib3.disable_warnings()

# URL and PORT for GoldenGate Distributed Env
goldengate_hub_url_source="https://localhost:9090"
goldengate_hub_url_target="https://localhost:8080"

# Authentication
header = {"Authorization" : "Basic b2dnYWRtaW46V2VsY29tZSMjMTIz"}
##---

# DIsplay the Header content
def display_header():
 
 # Print the table header
 header_line1 = "{:<9} {:<9} {:<9} {:<10} {:<12} {:<7} {:12} {:<6} {:<11} {:<25} {:<25}".format(
    "Process", "Process", "", "", "", "Lag", "Since Last", "File", "", "Last", "Checkpoint"
 )
 header_line2 = "{:<9} {:<9} {:<9} {:<10} {:<12} {:<7} {:<12} {:<6} {:<11} {:<25} {:<25}".format(
    "Type", "Name", "Status", "Sequence", "RBA", "in Sec", "Checkpoint", "Name", "Connection", "Checkpoint Time", "Recovery"
 )
 print("-"*155)
 print("-- GoldenGate Status for " + goldengate_hub_url_source + "(Source) and " + goldengate_hub_url_target + "(Target)")
 print("-"*155)
 print()
#print(f"{'ProcessType':9s}", f"Process\n {'Name':13s}", f"{'Status':10s}", f"{'Sequence':12s}", f"{'RBA':12s}", 
#       f"{'Lag in Sec':12s}", f"{'Since Last Checkpoint':23s}", f"{'File Name':10s}", f"{'Connection':15s}", f"{'Last Checkpoint Time':15s}" ) 
 
 print(header_line1)
 print(header_line2)
 print ("="*155)  

# Print Extract and Replicat Processes Status
def print_proc_status(proc_name, hub_url, proc_type):
 url = hub_url + "/" + proc_name
 url_info = hub_url + "/" + proc_name + "/info/status"
 url_checkpoints = hub_url + "/" + proc_name + "/info/checkpoints"
 url_distpath = hub_url + "/" + proc_name
 url_distpath_info = hub_url + "/" + proc_name + "/info"
 url_distpath_checkpoints = hub_url + "/" + proc_name + "/checkpoints"

 response = requests.get(url, verify=False, headers=header)
 response_info = requests.get(url_info, verify=False, headers=header)
 response_checkpoints = requests.get(url_checkpoints, verify=False, headers=header)
 response_distpaths = requests.get(url_distpath, verify=False, headers=header) 
 response_distpaths_checkpoints = requests.get(url_distpath_checkpoints, verify=False, headers=header) 
 response_distpaths_info = requests.get(url_distpath_info, verify=False, headers=header) 

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

  rdata_checkpoints=response_checkpoints.json()
  rCheckpointTime = rdata_checkpoints['response']['current']['input'][0]['current']['timestamp']
  rCheckpointRecovery = rdata_checkpoints['response']['current']['input'][0]['recovery']['timestamp']
 elif (proc_type == "replicat"):
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

  rdata_checkpoints=response_checkpoints.json()
  rCheckpointTime = rdata_checkpoints['response']['current']['input'][0]['current']['timestamp']
  rCheckpointRecovery = ""
 else:
 ##  Config for the Dist Path Formating  
  rdata_distpaths=response_distpaths.json()
  rstatus = rdata_distpaths['response']['status']
  rlagSinceCheckpoint = 0
  rCheckpointTime = "N/A"
  rCheckpointRecovery = "N/A"
  
  rdata_distpaths_checkpoints=response_distpaths_checkpoints.json()
  rsequence = rdata_distpaths_checkpoints['response']['current']['input'][0]['current']['sequence']
  roffset = rdata_distpaths_checkpoints['response']['current']['input'][0]['current']['offset']
  rfilename = rdata_distpaths_checkpoints['response']['current']['input'][0]['current']['name']

  rdata_distpaths_info=response_distpaths_info.json()
  rlag = rdata_distpaths_info['response']['lag']
  ralias = rdata_distpaths_info['response']['sourceExtractName']
  

## Print the Process Status
 print(f"{proc_type.upper():9s}",f"{proc_name:9s}", f"{rstatus.upper():9s}",f"{rsequence:<10d}",
       f"{roffset:<12d}",f"{rlag:<7d}",f"{rlagSinceCheckpoint:<12d}",f"{rfilename:6s}", f"{ralias:11s}", f"{rCheckpointTime:25s}", f"{rCheckpointRecovery:15s}")

# Check how many processes exist and loop through each one for status reporting
def check_ggprocess(ggprocess):
  if (ggprocess == "extract"):
   hub_url = goldengate_hub_url_source +"/services/v2/extracts"
  elif (ggprocess == "replicat"):
   hub_url = goldengate_hub_url_target +"/services/v2/replicats"
  else:
   hub_url = goldengate_hub_url_source +"/services/v2/sources" 

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
check_ggprocess("distpath")
print()
print()
