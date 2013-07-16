import argparse
import yaml
from radio_to_podcast_util import *
from radio import *
from syslog import syslog,LOG_INFO

# configure argument parser
config_file_param = 'config_file'
parser = argparse.ArgumentParser('Start or stop a streaming radio program as appropriate.')
parser.add_argument(config_file_param)
args = parser.parse_args()

# load config
schedules = load_yaml(args.config_file)['schedules']

log_msg = "Streamripper is running"
if should_be_running(schedules) and is_not_running():
   start(get_current_schedule(schedules))
   syslog(LOG_INFO, log_msg)
elif should_not_be_running(schedules) and is_running():
   stop(schedules)
elif should_be_running(schedules) and is_running():
    syslog(LOG_INFO, log_msg)
    pass
elif should_not_be_running(schedules) and is_not_running():
    pass
    