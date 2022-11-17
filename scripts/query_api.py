#!/usr/bin/env python3
"""
helper script to query the API via php
"""

import ast
import json
import os
import subprocess
import sys

f = open(sys.argv[1], 'r')
data = ast.literal_eval(f.read())

# list with stuff in it
_new = []
_counter = 0
for i in data:
    os.system('cp template.php output/{}.php'.format(i[0]))
    os.system('sed -i \'s/x_start_date/{}/\' output/{}.php'.format(i[1], i[0]))
    os.system('sed -i \'s/x_end_date/{}/\' output/{}.php'.format(i[1], i[0]))
    os.system('sed -i \'s/x_ip/{}/\' output/{}.php'.format(i[0], i[0]))
    cmd = 'php output/{}.php | grep login | head -1'.format(i[0])
    try:
        output = subprocess.check_output(cmd, shell=True).decode().split('=>')[1].strip()
        print(_counter, "/{}: ".format(len(data)), i[0], " --> ", output, "length _new: {}".format(len(_new)))
        i = i + (output,)
        print(i)
        #i['login'] = output
        _new.append(i)
    except:
        continue
    _counter += 1


_filename = sys.argv[1].replace('/', '').replace('.', '')
with open(_filename, 'w') as newfile:
    newfile.write(str(_new))


