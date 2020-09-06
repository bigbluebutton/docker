# this script sends all entries from different logfiles
# to stdout, so that they appear in the docker logs

import threading
import subprocess
import time
import pyinotify
import os
import re
import sys

log_dir = '/var/log/bigbluebutton'

def thread_function(name, filename):
    f = subprocess.Popen(['tail','-F', '-n', '0', filename],\
        stdout=subprocess.PIPE,stderr=subprocess.PIPE)
    while True:
        line = f.stdout.readline().decode('utf-8').strip()
        if len(line):
            print(name.ljust(10)+' |', line)
            sys.stdout.flush()

def tail_file(name, filename):
    x = threading.Thread(target=thread_function, args=(name, filename,))
    x.start()


tail_file('rap-worker', log_dir+'/bbb-rap-worker.log')
tail_file('sanity', log_dir+'/sanity.log')
tail_file('publish', log_dir+'/post_publish.log')

class EventHandler(pyinotify.ProcessEvent):
    def process_IN_CREATE(self, event):
        filename = os.path.basename(event.pathname)
        if re.match('^archive-.*\.log$', filename):
            tail_file('archive', event.pathname)
        elif re.match('^process-.*\.log$', filename):
            tail_file('process', event.pathname)


wm = pyinotify.WatchManager()
handler = EventHandler()
notifier = pyinotify.Notifier(wm, handler)
wdd = wm.add_watch(log_dir, pyinotify.IN_CREATE, rec=True)
notifier.loop()