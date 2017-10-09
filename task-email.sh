#!/usr/bin/env bash

#email myself info about upcoming tasks in a pretty HTML format
# Requires ssmtp
# cron: 30 5 * * 1-6 /home/user/bin/taskwarrior-notifications/task-email.sh

# Pull in the config variables
dir="$( cd "$( dirname "$0" )" && pwd )"
 
if [ -f $dir/config ]; then
  source $dir/config
else
  echo "No configuration file found. Maybe you need to copy and edit the example.config file to config."
  exit 1
fi

# taskrc defaults
taskrc="rc.json.array=off rc.verbose=nothing"

# Format time string
date=`date '+%d/%m/%Y'` #07/09/2012

cat > $tmp_email <<EOF
From: The Task List <$sendto> 
To: $sendto
Subject: Daily Task Email
MIME-Version: 1.0
Content-Type: text/html
Content-Disposition: inline
EOF

# Define my own eow and eonw
if [[ "$OSTYPE" =~ ^darwin ]]; then
    eow=`date -v+1w -vsun +%d%m%Y` # end of week
    eonw=`date -v+2w -vsun +%d%m%Y` # end of next week
else
    eow=`date -d "sunday" +%d/%m/%Y` # end of week
    eonw=`date -d "1 week sunday" +%d/%m/%Y` # end of next week
fi

# Get the template loaded up
cat $templates/html_email_head.template >> $tmp_email
echo "<h1>Task Info: $date</h1>" >> $tmp_email

# Overdue
echo "<h2>Overdue</h2>" >> $tmp_email
echo `task "due.before:today and status:pending" export ${taskrc} | $scripts/export-html.py` >> $tmp_email

if [[ $(date +%u) -lt 6 ]] ; then # Weekday

# Today
echo "<h2>Today</h2>" >> $tmp_email
echo `task "due:today and status:pending" export ${taskrc} | $scripts/export-html.py` >> $tmp_email
# This Week (but not today)
echo "<h2>This Week</h2>" >> $tmp_email
echo `task "due.after:today and (due.before:$eow or due:$eow) and status:pending" export ${taskrc} | $scripts/export-html.py` >> $tmp_email

else

# This Weekend
echo "<h2>This Weekend</h2>" >> $tmp_email
if [[ $(date +%u) -eq 6 ]] ; then # Saturday 
  echo `task "(due:today or due:tomorrow) and status:pending" export ${taskrc} | $scripts/export-html.py` >> $tmp_email
else # Sunday
  echo `task "(due:yesterday or due:today) and status:pending" export ${taskrc} | $scripts/export-html.py` >> $tmp_email
fi

fi

# Next Week
echo "<h2>Next Week</h2>" >> $tmp_email
echo `task "due.after:$eow and (due.before:$eonw or due:$eonw) and status:pending" export ${taskrc} | $scripts/export-html.py` >> $tmp_email

cat $templates/html_email_foot.template >> $tmp_email

# Send the email
$mail_prog $sendto < $tmp_email
rm $tmp_email
