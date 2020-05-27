# Taskwarrior-notifications
A collection of scripts to provide various notifications for [taskwarrior](https://taskwarrior.org/), a commandline task management system.

### Configuration
Configuration of the email address and file locations can be changed in the `config` file in the root of the repo. A sample config is provided in [example.config](example.config). Simply rename this to `config` and make the appropriate edits.

### Available Scripts

[task-email.sh](task-email.sh): Uses ssmtp to send html formatted email to you on a regular basis giving you updates on your task list. I'm playing with two methods of accomplishing this. This one requires python and numpy (a python module). See the task-ansi2email.sh for an option that does not require python. Currently, the fancy HTML on this is optimized for mobile screens so it's thin and all that. I assume a little CSS would change this quickly. Thanks to Mail Chimp for releasing some good HTML templates on github.

[task-ansi2email.sh](task-ansi2email.sh): An alternate, but not as pretty version of HTML email. This puts the task output into an HTML pre tag so it appears as it would on the command line. I kinda like that though.

[task-popup.sh](task-popup.sh): Provides popups with sound to your linux desktop. This uses tools that come as part of the default ubuntu system, but are available on other Linux operating systems.

[task-growl.sh](task-growl.sh): For the mac users, this will send a message to Growl which is kinda like the task-popup.sh for linux users. This requires the "extra" package in the Growl install called growlnotify.

task-print.sh: Yeah, this doesn't actually exist because it is easily done in a crontab line so a script is overkill in a basic situation. See the appropriate line below.

### Sample Crontab lines
```bash
# Popup a little notice monday through friday ever 30 minutes with task info
*/30 * * * 1-5 DISPLAY=:0.0 /home/user/bin/taskwarrior-notifications/task-popup.sh

# Send me an email every morning at 5:30 on all days except Sunday.
30 5 * * 1-6 /home/user/bin/taskwarrior-notifications/task-email.sh

# Print out my task list every weekday morning at 5:30
30 5 * * 1-5 /usr/bin/task | /usr/bin/lp
```
