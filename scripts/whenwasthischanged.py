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


class Main:
    def __init__(self):
        self.date_to_commitcount={}
        self.date_to_uniquefilescommited={}
        self.date_to_num_of_commits={}
        self.date_to_committercount={}

        self.run_cmd()

    def run_cmd(self):
        if len(sys.argv) == 2 and sys.argv[1] == '-h':
            print("show how many files were commited to git repo in current dir per month")
            sys.exit(1)

        cmd="git log --pretty='commit:: %ad %ae' --name-only --date=format:%Y-%m"

        run_cmd = RunCommand(cmd)

        if run_cmd.exit_code != 0:
            show_error("current directory is not a git repo")

        self.run_scan(run_cmd.output.splitlines())

    def run_scan(self,lines):

        for line in lines:
            match_obj = re.match(r'commit:: (.*) (.*)', line)
            if match_obj:
                date = match_obj.group(1)
                author_email = match_obj.group(2)

                res = self.date_to_num_of_commits.get(date)
                if not res:
                    self.date_to_num_of_commits[date] = 1
                else:
                    self.date_to_num_of_commits[date] += 1

                res = self.date_to_committercount.get(date)
                if not res:
                    self.date_to_committercount[date] = { author_email : [1, 0] }
                else:
                    res2 = res.get(author_email)
                    if not res2:
                        res[author_email] = [1, 0]
                    else:
                        res[author_email][0]+= 1

            elif line != "":
                res = self.date_to_commitcount.get(date)
                if not res:
                    self.date_to_commitcount[date] = 1
                else:
                    self.date_to_commitcount[date] = self.date_to_commitcount[date] + 1

                res = self.date_to_uniquefilescommited.get(date)
                if not res:
                    self.date_to_uniquefilescommited[date] = { line : "1" }
                else:
                    self.date_to_uniquefilescommited[date][line] = "1"

                self.date_to_committercount[date][author_email][1] += 1

        self.show_report()

    def show_report(self):

        for k in sorted(self.date_to_commitcount.keys()):
            print("month: {} num-of-commits-per-month {}\tnumber-of-files-commited: {}\tunique-files-commited: {}".\
                    format(k,\
                        self.date_to_num_of_commits[k],\
                        self.date_to_commitcount[k], \
                        len(self.date_to_uniquefilescommited[k]) \
                        ))

            for author in self.date_to_committercount[k].keys():
                print("\tnum-commits: {}\tfiles-changed-in-commits: {}\tauthor: {}".\
                        format(self.date_to_committercount[k][author][0], \
                               self.date_to_committercount[k][author][1], \
                               author))

Main()
