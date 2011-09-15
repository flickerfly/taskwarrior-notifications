#!/bin/bash

# email myself info about upcoming tasks in a pretty HTML format
# Basic idea conceived by Kevin Owens at: 
#   http://taskwarrior.org/boards/1/topics/495#message-552
# Requires ssmtp and ansi2html script. It should be easy to substitute
#   another smtp program, if you do, please let me know and I'll update this
# cron: 30 5 * * 1-6 /home/user/bin/taskwarrior-notifications/task-email.sh

# Pull in the config variables
dir="$( cd "$( dirname "$0" )" && pwd )"

if [ -f $dir/config ]
then
  source $dir/config
else
  echo "No configuration file found. Maybe you need to copy and edit the example.config file to config."
  exit 1
fi

#setup headers so the HTML shows properly
cat > $tmp_email <<EOF
From: The Task List <$sendto> 
To: $sendto
Subject: Daily Task Email
MIME-Version: 1.0
Content-Type: text/html
Content-Disposition: inline
EOF

#pump the task information into the email
task $report | $scripts/ansi2html.sh >> $tmp_email

# Send the email
$mail_prog $sendto < $tmp_email
rm $tmp_email
