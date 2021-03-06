#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This work was created by participants in the Northwest Knowledge Network
# (NKN), and is copyrighted by NKN. For more information on NKN, see our
# web site at http://www.northwestknowledge.net
#
#   Copyright 2017 Northwest Knowledge Network
#
# Licensed under the Creative Commons CC BY 4.0 License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   https://creativecommons.org/licenses/by/4.0/legalcode
#
# Software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This application takes a POSTed PHP session id (session_id) and
# configuration keyword (config_kw) and an optional request id (request_id)
# and returns the username of the user logged in on the Drupal session
# associated with that session id.  It uses the config_kw to get connection
# parameters for a Drupal SQL server, then connects to that database and runs
# a simple query, returning a JSON envelope containing the original session id,
# configuration keyword, request id, and either a username or an error code.

import ConfigParser
import json
import MySQLdb
import os
import requests
import sys
import warnings

def test():
    #Config file is 'getUsername.conf' located in the current directory
    config_file = os.path.dirname(os.path.realpath(__file__)) + '/getUsername.conf'

    #Default to using the main NKN portal configuration and URL
    config_kw = 'nknportal'
    url = 'https://nknportal-prod.nkn.uidaho.edu/getUsername/'

    #Make SQL warnings into exceptions so we can catch them
    warnings.filterwarnings('error', category=MySQLdb.Warning)

    #Initialize db_con so we can refer to it in the finally block
    db_con = None

    #Initialize the output data structure
    #exit 0 - "OK", Nagios Server would highlight the check with Green
    #exit 1 - "WARNING", Nagios Server would highlight the check with Yellow
    #exit 2 - "CRITICAL", Nagios Server would highlight the check with Red
    #exit 3 - "UNKNOWN", Nagios Server would highlight the check with Grey
    output = 3
    msg = 'Something is not right...'

    try:
        #Open the config file and get the SQL connection parameters
        #Grab the version parameter before removing it from the rest
        config = get_config(config_file)
        conn_param = dict(config.items(config_kw))
        version = conn_param['version'];
        del conn_param['version'];

        #Get a valid session ID for testing:
        #Define the SQL query, connect to the DB, and execute
        #Note that Drupal 7 and 8 have different database structures,
        #so we choose a query based upon the 'version' parameter from config
        query = "";
        if version == '8':
            query = ("SELECT sid, name FROM users_field_data INNER JOIN sessions ON users_field_data.uid=sessions.uid WHERE name != '' LIMIT 1;")
        else:
            query = ("SELECT sid, name FROM users INNER JOIN sessions ON users.uid=sessions.uid WHERE name != '' LIMIT 1;")
        db_con = MySQLdb.connect(**conn_param)
        cur = db_con.cursor()
        cur.execute(query)

        #If we got no rows back, then nobody is logged in, and we
        #can't test getUsername.
        rows = cur.fetchall()
        if not rows:
            output = 1
            msg = 'No users are logged in'
            cur.close()
            sys.exit(output)
        session_id = rows[0][0]
        cur.close()

        #Submit the session ID to the getUsername service via POST
        r = requests.post(url, data={'session_id': session_id, 'config_kw': config_kw})
        json_data = json.loads(r.text)

        #If no username came back, fail.  Otherwise, success.
        if json_data['username'] == '':
            output = 2
            msg = 'getUsername Failed: ' + json_data['error']
        else:
            output = 0
            msg = 'Looks good from here'
        cur.close()

    except Exception as e:
        output = 2
        msg = 'Unable to test username: ' + e.message
    finally:
        if db_con:
            db_con.close()
        print msg
        sys.exit(output)


# The function for reading the config file
def get_config(config_file):
    """Provide user with a ConfigParser that has read the `config_file`
        Returns:
            (ConfigParser) Config parser with a section for each config
    """
    assert os.path.isfile(config_file), "Config file %s does not exist!" \
        % os.path.abspath(config_file)
    config = ConfigParser.ConfigParser()
    config.read(config_file)
    return config


if __name__== "__main__":
    test()
