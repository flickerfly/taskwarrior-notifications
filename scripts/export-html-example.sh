echo "<h4>pending:</h4>"
task _query status:pending | export-html.py
echo "<h4>completed:</h4>"
task _query status:completed | export-html.py
