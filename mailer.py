#!/usr/bin/python
# This script loops over a CSV file that is formatted like so:
#
# CustomerName, FirstName, Email
# Big Boy, Bob Smith, bboy@example.com
# 
# It sends a html formatted email to them. You'll need to set your CSV file
# below, set the smtp email server below, and customize your message

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import csv

filereader = csv.reader(open("./your.csv"), delimiter=",")

for CustomerName, FirstName, Email in filereader:
   print("Sending Mail to " + FirstName + " " + Email + " about " + CustomerName)
   print("Formatting email to " + Email)
   sender = 'sender@example'
   receivers = Email 

   message = MIMEMultipart("alternative")
   message["From"] = "sender@example"
   message["To"] = """ %s """ % (Email)
   message["Cc"] = "copieduser@example.com"
   message["Subject"] = """ %s is invited to a Christmas Party """ % (CustomerName)
#   message["Subject"] = "subject" 
   
   html = """\
<html>
Your Message Here
</html>
""" % (FirstName, CustomerName, CustomerName)

   convert = MIMEText(html, "html")
   message.attach(convert)

   try:
      smtpObj = smtplib.SMTP('smtp.example.com')
      smtpObj.sendmail(sender, receivers, message.as_string())         
      print("Successfully sent email to " + Email)
   except BaseException:
      print("Error: unable to send email to " + Email)
