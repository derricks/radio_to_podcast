# does the actual work of starting/stopping/checking the radio program
# abstracted out so different radio streamers can be pulled in as needed.
import os.path
from subprocess import check_output, Popen
from time import localtime, mktime


# determines if the radio program is running
def is_running():
    return (check_output("ps -wef | grep streamripper | awk '!/grep/{print}'",shell=True) != '')
    
# determines if the radio program is not running    
def is_not_running():
    return not is_running()

# given a schedule, start up the radio with an appropriate file name
# note this will try to not overwrite a file that already exists, instead suffixing 1,2,3 etc.    
def start(schedule):
    if schedule == None:
        return
        
    print "starting radio capture for " + str(schedule)
    file_name = os.path.expanduser("~/radio_captures/" + schedule['name'] + ".mp3")
    if os.path.exists(file_name):
        counter = 1
        file_name = os.path.expanduser("~/radio_captures/" + schedule['name'] + "." + str(counter) + ".mp3")
        while os.path.exists(file_name):
            counter = counter + 1
   
    # run streamripper for however long is left in the schedule (note that you might be picking up to recover)
    # in which case you wouldn't just go from start -> end seconds!
    now = localtime()
    seconds = int(mktime(schedule['end']) - mktime(localtime()))
    Popen("nohup /usr/local/bin/streamripper " + schedule['url'] + " -a " + file_name + " --quiet -l " + str(seconds),shell=True)