import yaml
from time import localtime,strptime

# load the yaml file
def load_yaml(file):
    retval = yaml.load(open(file,'r'))
    
    # clean up any times in the list
    for schedule in retval['schedules']:
        print(schedule)
        schedule['start'] = __parse_time(schedule['start'])
        schedule['end'] = __parse_time(schedule['end'])
    return retval

    
def should_be_running(schedules):
    return get_current_schedule(schedules) != None

# Return the current schedule that's relevant, or None    
def get_current_schedule(schedules):
    now = localtime()
    for schedule in schedules:
        if now >= schedule['start'] and now < schedule['end']:
            return schedule
    return None
    
def should_not_be_running(schedules):
    return not should_be_running(schedules)
    
def __parse_time(time_str):
    print(time_str)
    return strptime(time_str,'%Y-%m-%d %H:%M')
    