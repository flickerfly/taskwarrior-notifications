#!/usr/bin/env python
# found this code on http://taskwarrior.org/projects/1/wiki/Export-htmlpy
# sudo apt-get install python-numpy
# requires taskwarrior 1.9.4 and python-numpy

import sys
from numpy import array,append

def print_html_descriptions(tasks):
    for t in tasks:
        if 'depends' not in t:
            if 'tags' not in t:
                print("    <li>%s</li>" % t['description'])
            else:
                tags = ', '.join(t['tags']) # join tags as comma separated list
                print("    <li>%s (%s)</li>" % (t['description'], tags))

def main():
    tasks = array([])
    for line in sys.stdin: # reads in all lines until EOF
        if 'No matches.' not in line:
            # pack columns into array
            lin = eval(line)
            tasks = append(tasks, lin)
        else:
            print("%s" % line) # print "No matches."

    print("  <ol>")
    print_html_descriptions(tasks)
    print("  </ol>")

if __name__ == '__main__':
    main()
