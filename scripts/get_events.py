#!/usr/bin/env python3
"""
helper script to build a shortened variant of the events
"""

import ipaddress
import json
import requests
import sys

_lan = ['192.168.62.0/24', '172.16.0.0/12']

def check_source(ip):
    ret = False
    for i in range(0, len(_lan)):
        #print("searching for {}".format(_lan[i]))
        if ipaddress.ip_address(ip) in ipaddress.ip_network(_lan[i]):
            ret = True
    return ret

with open(sys.argv[1], 'r') as f:
    lines = [line for line in f if 'signature_id' in line]


_list = []
for i in range(0, len(lines)):
    if check_source(json.loads(lines[i])['src_ip']):
            _list.append(json.loads(lines[i]))


_final_list = []
for i in range(0, len(_list)):
    _temp_dict = {}
    for j in ['timestamp', 'src_ip', 'src_port', 'dest_ip', 'dest_port', 'proto']:
        _temp_dict[j] = _list[i][j]
    for j in ['signature_id', 'signature', 'severity', 'category']:
        _temp_dict[j] = _list[i]['alert'][j]
    _temp_dict['start_date'] = _temp_dict['timestamp'].split('.')[0].split('T')[0]
    _temp_dict['start_time'] = _temp_dict['timestamp'].split('.')[0].split('T')[1]
    _final_list.append(_temp_dict)

print(_final_list)

# _final list = list of jsons to query API
# due to the specifics of the API, it has to be done in 2 steps
#   - query the statistics table, for sessions already closed
#   - query the online table, for users still using the same session



