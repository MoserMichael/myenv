#!/usr/bin/env python

import subprocess
import shlex
import functools
from datetime import datetime
import operator
import statistics
import sys
import os

class Options:
    def __init__(self):
        self.show_progress = True
        self.sort_by_field = 'num_commits'
        self.sort_descending  = True


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

            self.output = output.decode("cp858")
            self.error_out = error_out.decode("cp858")
            self.exit_code = process.wait()
            return self.exit_code

        except FileNotFoundError:
            self.output = ""
            self.error_out = "file not found"
            self.exit_code = 1
            return self.exit_code

    def status(self):
        return self.exit_code

class CommitEntry:

    FILE_STATUS_DELETED=1
    FILE_STATUS_ADDED=2
    FILE_STATUS_CHANGED=3

    def __init__(self, hash_val, author, email, time):
        self.hash_val = hash_val
        self.author = author
        self.email = email
        self.time = int(time)

        # data added upon analysing the commit
        self.files_added = 0
        self.files_deleted = 0
        self.files_changed = 0

        self.lines_added = 0
        self.lines_deleted = 0
        self.lines_changed = 0


    def show(self):
        print(f"File: A/D/C {self.files_added}/{self.files_deleted}/{self.files_changed}  Lines: A/D/C {self.lines_added}/{self.lines_deleted}/{self.lines_changed}") 

    def _get_commit_text(self):
        #cmd = f"git show --no-color {self.hash_val}"
        cmd = f"git show --no-color --pretty='format:%b' {self.hash_val}"
        cmd_out=RunCommand(cmd)

        return cmd_out.output


    def analyse(self):
        line_status = 0
        deleted_line_seq = 0
        added_line_seq = 0

        for line in self._get_commit_text().split("\n"):
            if line.startswith("---"):
                if line.find("/dev/null") == -1:
                    line_status += CommitEntry.FILE_STATUS_DELETED
            elif line.startswith("+++"):
                if line.find("/dev/null") == -1:
                    line_status += CommitEntry.FILE_STATUS_ADDED
            else:
                if line_status != 0:
                    if line_status == CommitEntry.FILE_STATUS_DELETED:
                        self.files_deleted += 1
                    elif line_status == CommitEntry.FILE_STATUS_CHANGED:
                        self.files_changed += 1
                    elif line_status == CommitEntry.FILE_STATUS_ADDED:
                        self.files_added += 1

                    line_status = 0

                    if added_line_seq > 0 or deleted_line_seq > 0:
                        self.on_line_sequence(added_line_seq, deleted_line_seq)

                    added_line_seq = 0
                    deleted_line_seq = 0


                if line.startswith("-"):
                    deleted_line_seq += 1
                elif line.startswith("+"):
                    added_line_seq += 1
                else:
                    if added_line_seq !=0 or deleted_line_seq != 0:
                        self.on_line_sequence(added_line_seq, deleted_line_seq)
                        added_line_seq = 0
                        deleted_line_seq = 0

        if added_line_seq != 0 or deleted_line_seq != 0:
            self.on_line_sequence(added_line_seq, deleted_line_seq)


    def on_line_sequence(self, added_line_seq, deleted_line_seq):
        self.lines_changed += min(added_line_seq, deleted_line_seq) 
        if  added_line_seq > deleted_line_seq:
            self.lines_added += added_line_seq - deleted_line_seq
        else:    
            self.lines_deleted += deleted_line_seq - added_line_seq


class Author:
    def __init__(self, author, email):
        self.author = author
        self.email = email
        self.commits = []
        self.first_commit = -1
        self.last_commit = -1

    def add_commit(self, commit):
        self.commits.append(commit)

    def analyse(self):
        self.files_added = functools.reduce(lambda x, commit : x + commit.files_added, self.commits, 0)
        self.files_deleted = functools.reduce(lambda x, commit : x + commit.files_deleted, self.commits, 0)
        self.files_changed = functools.reduce(lambda x, commit : x + commit.files_changed, self.commits, 0)
        self.files_affected = self.files_added + self.files_deleted + self.files_changed

        self.lines_added = functools.reduce(lambda x, commit : x + commit.lines_added, self.commits, 0)
        self.lines_deleted = functools.reduce(lambda x, commit : x + commit.lines_deleted, self.commits, 0)
        self.lines_changed = functools.reduce(lambda x, commit : x + commit.lines_changed, self.commits, 0)
        self.lines_affected =  self.lines_added + self.lines_deleted + self.lines_changed

        self.from_date = min(self.commits, key=lambda x: x.time).time
        self.to_date = max(self.commits, key=lambda x: x.time).time
        self.tenure = self.to_date - self.from_date
        self.num_commits = len(self.commits)

    def show(self):
        ftime = datetime.utcfromtimestamp(self.from_date).strftime('%Y-%m-%d')
        ttime = datetime.utcfromtimestamp(self.to_date).strftime('%Y-%m-%d')

        print(f"Author: {self.author} mail: {self.email} Num-of-commits: {self.num_commits} files:(Added/Deleted/Changed): {self.files_added}/{self.files_deleted}/{self.files_changed} lines(Added/Deleted/Changed):{self.lines_added}/{self.lines_deleted}/{self.lines_changed} time-range: {ftime} to {ttime}")


class GitRepoData:

    def __init__(self):
        self.authors = {}

    def analyse(self, opts):
        self._get_commits(opts)
        self._analyse()
        self._sort_for_display(opts)

    def _analyse(self):
        for author in self.authors.values():
            author.analyse()

    def show(self):
        print("")
        for commit in self.display_list:
            commit.show()

        self._show_tenure()

    def _show_tenure(self):
        print("\nAuthor statistics (tenure is defined as time between first and last commit)\n\n")
        print(f"Number of authors: {len(self.display_list)}")
        tenures = []
        for auth in self.display_list:
            tenures.append(auth.tenure)

        max_tenure = max(tenures)
        mean_tenure = statistics.mean(tenures)
        stddev_tenure = statistics.pstdev(tenures)

        print(f"Mean tenure:    {GitRepoData._to_months(mean_tenure)} months")
        print(f"Stddev tenure:  {GitRepoData._to_months(stddev_tenure)} months")
        print(f"Maximum tenure: {GitRepoData._to_months(max_tenure)} months")

    def _to_months(val):
        return val / (24 * 3600 * 30.5)

    def _sort_for_display(self, opts):
        self.display_list = list(self.authors.values())
        self.display_list.sort(key=operator.attrgetter(opts.sort_by_field), reverse=opts.sort_descending)

    def _get_commits(self, opts):
        cmd=RunCommand("git log --format='%H,%aN,%ae,%ct'")
        commit_num = 0
        for line in cmd.output.split("\n"):
            line = line.strip()
            if line != "":
                if opts.show_progress:
                    commit_num += 1
                    if commit_num % 10 == 0:
                        print(".", end='', flush=True)
                #print(f"line: {line}")
                [ hash_val, author, author_mail, commit_date]  = line.split(',')
                #print(f"{hash_val} - {author} - {commit_date}")
                commit = CommitEntry(hash_val, author, author_mail, commit_date)

                author_obj = self.authors.get(author)
                if not author_obj:
                    author_obj = Author(author, author_mail)
                    self.authors[author] = author_obj

                commit.analyse()
                author_obj.add_commit(commit)

def main():

    if len(sys.argv) == 2 and (sys.argv[1] == '-h' or os.environ.get("SHORT_HELP_MODE")):
        print("Shows how many commits/files/lines any one of the users made, shows how long each of the users have been active.")
        sys.exit(1)

    opt = Options()
    run = GitRepoData()
    run.analyse(opt)
    run.show()


if __name__ == '__main__':
    main()
