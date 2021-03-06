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

import ConfigParser
import json
import os
import pymssql
import sys
import urllib
from elasticsearch import Elasticsearch
from getJsonByURL import processFile

def getRecords(failed_records):
    #Open the config file and get the SQL connection parameters
    config_file = os.path.join(os.path.dirname(__file__), 'config.py')
    config = get_config(config_file)
    conn_param = dict(config.items('config'))

    #Set up and execute the query
    query = "SELECT [path] FROM [nknDatastore].[dbo].[file] WHERE [isMetadata] = 1 and [isCanonicalMetadata] = 1  and path like 'published%';"
    with pymssql.connect(conn_param['host'], conn_param['user'],
                         conn_param['password'], conn_param['database']) as conn:
        with conn.cursor() as cursor:
            cursor.execute(query)
            for row in cursor:
                url = urllib.quote(row[0])
                url = url.replace('published/', conn_param['baseurl'])
                print url
                index(url, failed_records)


# Insert a record into the index
def index(url, failed_records):
    jsonText, error = processFile(url)
    if error == 1:
	failed_records.append(jsonText)
    else:
	try:
	    es = Elasticsearch([{'host': 'localhost', 'port': 9200}])
            print es.index(index='records', doc_type='metadata', body=json.loads(jsonText))
	except:
	    print "Unexpected error: could not insert record in to Elasticsearch"
	    failed_records.append(url)

# Clear all records from the index
def wipeIndex():
    es = Elasticsearch([{'host': 'localhost', 'port': 9200}])
    print es.delete_by_query(index='records',body={"query":{"match":{"record_source":"filesystemIndexer"}}})


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
    failed_records = []

    wipeIndex()
    getRecords(failed_records)
    if len(failed_records) > 0:
        print "Listing URL's of failed records:"
        print failed_records
