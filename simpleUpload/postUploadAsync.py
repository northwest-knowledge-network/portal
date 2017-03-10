#!/usr/bin/python

import shlex
from subprocess import Popen, PIPE
import shutil
import smtplib
import sys
import os

basePath = sys.argv[1]


#
#Clamscan the dataset path
#
exit_code = 0
if (os.path.isdir(basePath)):
  cmd = "/usr/bin/clamscan " + basePath
  process = Popen(shlex.split(cmd), stdout=PIPE)
  process.communicate()
  exit_code = process.wait()
#print >> sys.stderr, "~~~~~exit code " + str(exit_code)



#
#If exit_code != 0, then clamscan returned some error, possibly a virus,
#so send the notification email
#

if (exit_code != 0):
  sender = 'portal@northwestknowledge.net'
  receivers = ['publish@northwestknowledge.net']
  message = """From: NKN Geoportal <portal@northwestknowledge.net>
To: NKN Publisher Group <publish@northwestknowledge.net>
Subject: Virus scan failed for uploaded data

Hi, NKN data publishers.  A new dataset has been uploaded in pre-production,
but the data failed the virus scan.  Please take a look.

Dataset path:
"""

  message = message + basePath

  try:
    smtpObj = smtplib.SMTP('localhost')
    smtpObj.sendmail(sender, receivers, message)
    print "Successfully sent email"
  except SMTPException:
    print "Error: unable to send email"


# After this, we insert the return code into MongoDB

#
#If the files were infected, stop processing
#

#if (exit_code != 0):
#  exit();



#
#If the files are clean, move them into production
#
#if (exit_code == 0):
#  if (os.path.isdir(dsPath)):
#    shutil.move(dsPath, datastorePath + uuid)
