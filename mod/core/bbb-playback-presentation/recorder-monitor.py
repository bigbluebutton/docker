#!/usr/bin/env python3

import time
import argparse
import subprocess
import glob

PATH_MONITOR = "/var/bigbluebutton/recording/status/"

def file_monitor(event_to_check):
    done_files = glob.glob(PATH_MONITOR + event_to_check + "/*.done") # List
    while len(done_files) == 0:
        time.sleep(5)
    subprocess.Popen("/usr/local/bigbluebutton/scripts/rap-"+event_to_check+"-worker.rb", cwd="/usr/local/bigbluebutton/core/scripts")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--event", type=str, dest="event_to_check", help="Event to check (archive, events, process, publish, sanity)")
    args = parser.parse_args()
    file_monitor(args.event_to_check)
