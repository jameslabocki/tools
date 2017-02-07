#!/usr/bin/python
# This script loops over a CSV file that is formatted like so:
#
# FirstName, Email, CustomerName
# Bob, bsmith@domain.com, Big Boy
# 
# It sends a formatted email to them. You'll need to set your CSV file
# below, set the smtp email server below, and customize your message

import smtplib
import csv

filereader = csv.reader(open("../your.csv"), delimiter=",")
header = filereader.next()

for FirstName, Email, CustomerName in filereader:
   print "Sending Mail to " + FirstName + " " + Email + " about " + CustomerName
   print "Formatting email to " + Email
   sender = 'YOUREMAIL@redhat.com'
   receivers = Email 
   message = """From: YOURNAME <YOUREMAIL@redhat.com> 
To: %s <%s>
Subject: %s YOURSUBJECT

Hello %s,

YOUR MESSAGE

Thanks
YOURNAME
""" % (FirstName, Email, CustomerName, FirstName)
   
   try:
      smtpObj = smtplib.SMTP('smtp.domain.com')
      smtpObj.sendmail(sender, receivers, message)         
      print "Successfully sent email to " + Email
   except SMTPException:
      print "Error: unable to send email to " + Email
