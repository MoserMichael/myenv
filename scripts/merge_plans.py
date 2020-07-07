#!/usr/bin/python3

import re
import datetime
import argparse
import os.path
import os
import sys

class Entry:
    def __init__(self, line_number_of_entry=-1,\
            day=0, month=0, year=0, hour=0, minn=0, sec=0):
        if line_number_of_entry == -1:
            day_time = datetime.datetime.now()
            self.day = day_time.date()
            self.time = day_time.time()
            self.lines = []
            self.line_number_of_entry = 1
        else:
            if year < 100:
                year += 2000
            self.day = datetime.date(year, month, day)
            self.time = datetime.time(hour, minn, sec)
            self.lines = []
            self.line_number_of_entry = line_number_of_entry

    def add(self, line):
        self.lines.append(line.rstrip())

    def show_header(self, show_line=False):
        if show_line:
            print(self.line_number_of_entry, ': ', sep='', end='')
        print("---{:0>2}/{:0>2}/{:0>4} {:0>2}:{:0>2}:{:0>2}----------------------".\
                format(self.day.day, self.day.month, \
                        self.day.year, self.time.hour, self.time.minute, self.time.second))

    def show(self):
        self.show_header()
        for line in self.lines:
            print(line)

    def num_lines(self):
        return len(self.lines)

    def is_empty(self):
        for line in self.lines:
            if line != "":
                return False
        return True

    def later_or_equal_than(self, entry):
        if self.day > entry.day:
            return True
        if self.day == entry.day:
            return self.time >= entry.time
        return False


def valid_day(day, month, year):
    if 0 < day <= 31 and 0 < month <= 12 and year >= 0:
        return True
    return False

def valid_hour(hour, minn, sec):
    if 0 <= hour <= 23:
        if 0 <= minn <= 59 and 0 <= sec <= 59:
            return True
    return False

class EntryFile:
    def __init__(self, filename):
        self.entries = []
        self.filename = filename

    def add(self, entry):
        self.entries.append(entry)

    def parse(self):
        current_entry = Entry()

        header = re.compile(r"(-+)(\d\d)/(\d\d)/(\d+) (\d\d):(\d\d):(\d\d)(-+)")
        line_num = 1
        with open(self.filename, "r") as file:
            lines = file.readlines()
            for line in lines:
                hdr = header.match(line)
                if hdr:
                    day = int(hdr.group(2))
                    month = int(hdr.group(3))
                    year = int(hdr.group(4))
                    hour = int(hdr.group(5))
                    minn = int(hdr.group(6))
                    sec = int(hdr.group(7))

                    if valid_day(day, month, year) and valid_hour(hour, minn, sec):

                        # header lines not followed by any text are empty entries
                        # therefore adding the current entry at the start of the next entry
                        if not current_entry.is_empty():
                            self.entries.append(current_entry)
                        current_entry = Entry(line_num, day, month, year, hour, minn, sec)
                    else:
                        current_entry.add(line)
                else:
                    current_entry.add(line)
                line_num += 1

        if not current_entry.is_empty():
            self.entries.append(current_entry)

    def sort(self):
        self.entries = sorted(self.entries, key=\
                lambda entry: datetime.datetime.combine(entry.day, entry.time))
        self.entries.reverse()

    def show(self):
        for entry in self.entries:
            entry.show()

    def check_is_sorted(self, show_errors):
        if len(self.entries) == 0:
            return True
        hdr = self.entries[0]
        pos = 1
        is_sorted = True
        while pos < len(self.entries):
            if not hdr.later_or_equal_than(self.entries[pos]):
                is_sorted = False
                if show_errors:
                    print("\nnot sorted here:")
                    hdr.show_header(True)
                    self.entries[pos].show_header(True)
            hdr = self.entries[pos]
            pos += 1
        return is_sorted

    def merge_in(self, entry_file):
        if not self.check_is_sorted(True):
            print("Can't merge, file {} is not sorted".format(self.filename))
            return False
        if not entry_file.check_is_sorted(False):
            print("Can't merge, file {} is not sorted".format(entry_file.filename))
            return False

        i = 0
        j = 0
        merged_list = []

        while i < len(self.entries) or j < len(entry_file.entries):

            if i < len(self.entries) and j < len(entry_file.entries):
                if self.entries[i].later_or_equal_than(entry_file.entries[j]):
                    merged_list.append(self.entries[i])
                    i += 1
                else:
                    merged_list.append(entry_file.entries[j])
                    j += 1
            else:
                if i < len(self.entries):
                    merged_list.append(self.entries[i])
                    i += 1

                if j < len(entry_file.entries):
                    merged_list.append(entry_file.entries[j])
                    j += 1

        self.entries = merged_list
        return True

def parse_cmd_line():
    usage = '''Parsing and processing of a structured plan file.
My plan files have the following header followed by text line, up until the next header:
regex for parsing header line: (-+)(\\d\\d)/(\\d\\d)/(\\d+) (\\d\\d):(\\d\\d):(\\d\\d)(-+)
'''
    parse = argparse.ArgumentParser(description=usage)
    parse.add_argument('--infile', '-i', type=str, metavar='infile',\
            help='Input file name', nargs='*')
    parse.add_argument('--shows', '-s', default=False, action='store_true', dest='showfiles',\
            help='Show the file entries to standard output')
    parse.add_argument('--check', '-c', default=False, action='store_true', dest='checkfile',\
            help='Check if the file is sorted by date')
    parse.add_argument('--sort', '-q', default=False, action='store_true', dest='sortfile',\
            help='Sort entries by date an time, print to standard output')
    parse.add_argument('--merge', '-m', default=False, action='store_true', dest='merge',\
            help='Merge two files, on conditio that they are both sorted.')

    return parse.parse_args()

def main():

    if len(sys.argv) == 2 and sys.argv[1] == '-h' and os.environ.get("SHORT_HELP_MODE"):
        print("processing my plan.txt formatted text files")
        sys.exit(1)

    args = parse_cmd_line()

    entries = EntryFile(os.path.expanduser(args.infile[0]))
    entries.parse()

    if args.merge:
        if len(args.infile) != 2:
            print("Error: merge needs two input files specified")
            sys.exit(1)
        entries_two = EntryFile(os.path.expanduser(args.infile[1]))
        entries_two.parse()
        if not entries.merge_in(entries_two):
            sys.exit(1)
        entries.show()
        sys.exit(0)

    if len(args.infile) != 1:
        print("Error: one file name must be specified for the current command")
        sys.exit(1)

    if args.sortfile:
        entries.sort()
        entries.show()

    if args.checkfile:
        if not entries.check_is_sorted(True):
            print("file is not sorted")
            sys.exit(1)
        else:
            print("file is sorted")

    if args.showfiles:
        entries.show()


if __name__ == '__main__':
    main()
