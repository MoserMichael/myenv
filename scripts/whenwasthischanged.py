#!/usr/bin/python3

import sys
import shlex
import subprocess
import re

def show_error(msg):
    print("Error: {}".format(msg))
    sys.exit(1)


class RunCommand:
    def __init__(self, command_line):
        self.command_line = command_line
        self.exit_code = 0
        self.run(command_line)

    def run(self, command_line):
        try:
            process = subprocess.Popen(shlex.split(command_line), \
                        stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            (output, error_out) = process.communicate()
            self.exit_code = process.wait()

            self.output = output.decode("utf-8")
            self.error_out = error_out.decode("utf-8")
            self.exit_code = process.wait()
            return self.exit_code

        except FileNotFoundError:
            self.output = ""
            self.error_out = "file not found"
            self.exit_code = 1
            return self.exit_code


def main():
    if len(sys.argv) == 2 and sys.argv[1] == '-h':
        print("show how many files were commited to git repo in current dir per month")
        sys.exit(1)

    cmd="git log --pretty='commit:: %ad' --name-only --date=format:%Y-%m"

    run_cmd = RunCommand(cmd)

    if run_cmd.exit_code != 0:
        show_error("current directory is not a git repo")


    date_to_commitcount={}
    date_to_uniquefilescommited={}
    date_to_num_of_commits={}

    lines = run_cmd.output.splitlines()
    for line in lines:
        match_obj = re.match(r'commit:: (.*)', line)
        if match_obj:
            date = match_obj.group(1)

            res = date_to_num_of_commits.get(date)
            if not res:
                date_to_num_of_commits[date] = 1
            else:
                date_to_num_of_commits[date] += 1

        else:
            if line != "":
                res = date_to_commitcount.get(date)
                if not res:
                    date_to_commitcount[date] = 1
                else:
                    date_to_commitcount[date] = date_to_commitcount[date] + 1

                res = date_to_uniquefilescommited.get(date)
                if not res:
                    date_to_uniquefilescommited[date] = { line : "1" }
                else:
                    date_to_uniquefilescommited[date][line] = "1"



    for k in sorted(date_to_commitcount.keys()):
        print("month: {} number-of-files-commited: {}\t unique-files-commited: {}\tnum-of-commits-per-month {}".\
                format(k, date_to_commitcount[k], \
                        len(date_to_uniquefilescommited[k]), \
                        date_to_num_of_commits[k]))



main()
