#!/bin/bash

#email myself info about upcoming tasks in a pretty HTML format
# Requires ssmtp
# cron: 30 5 * * 1-6 /home/user/bin/taskwarrior-notifications/task-email.sh

# Pull in the config variables
f [ -f ./config ]; then
  source ./config
elif
  echo "No configuration file found. Maybe you need to copy and edit the example.config file to config."
  exit 1
fi

# Format time string
date=`date '+%b %d'` #Sept 07

cat > $tmp_email <<EOF
From: The Task List <$sendto> 
To: $sendto
Subject: Daily Task Email
MIME-Version: 1.0
Content-Type: text/html
Content-Disposition: inline
EOF

# Get the template loaded up
cat $templates/html_email_head.template >> $tmp_email
echo "<h1>Task Info: $date</h1>" >> $tmp_email
echo `task _query status:completed | $scripts/export-html.py` >> $tmp_email
cat $templates/html_email_foot.template >> $tmp_email

# Send the email
ssmtp $sendto < $tmp_email
rm $tmp_email
