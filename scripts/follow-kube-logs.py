#!/usr/bin/env python3 

import subprocess
import shlex
import json
import os
import signal
import sys
import ctypes
import argparse

class Util:
    kubectl = "kubectl"

    @staticmethod
    def get_kubectl():
        return Util.kubectl

    @staticmethod
    def set_kubectl(cmd):
        Util.kubectl = cmd
       

class RunCommand:
    trace_on = False
    exit_on_error = True

    @staticmethod
    def trace(on_off):
        RunCommand.trace_on = on_off

    @staticmethod
    def exit_on_error(on_off):
        RunCommand.exit_on_error = on_off

    def __init__(self, command_line):
        self.command_line = command_line
        self.exit_code = 0
        self.run(command_line)

    def run(self, command_line):
        try:
            if RunCommand.trace_on:
                print(">{}".format( command_line   ))

            process = subprocess.Popen(shlex.split(command_line), \
                        stdout=subprocess.PIPE, stderr=subprocess.PIPE)

            (output, error_out) = process.communicate()

            self.exit_code = process.wait()

            self.output = output.decode("utf-8")
            self.error_out = error_out.decode("utf-8")

        
            self.exit_code = process.wait()

            if RunCommand.trace_on:
                print(">exit code: {} output: {} stderr: {}".format(self.exit_code, self.output, self.error_out))

            if RunCommand.exit_on_error and self.exit_code != 0:
                print(self.make_error_message())
                exit(1)

            return self.exit_code
        except FileNotFoundError:
            self.output = ""
            self.error_out = "file not found"
            self.exit_code = 1
            return self.exit_code

    def result(self):
        return self.exit_code, self.output

    def make_error_message(self):
        return_value = ""
        if self.command_line != "":
            return_value += " command line: {}.".format(self.command_line)
        if self.exit_code != 0:
            return_value += " exit status: {}. ".format(self.exit_code)
        if self.error_out != "":
            return_value += " " + self.error_out
        return return_value


def get_deployment_selector(namespace, deployment_name):
    cmd = "{} -n {} get deployment {}".format(Util.get_kubectl(), namespace, deployment_name) + " -o jsonpath='{.spec.selector.matchLabels}'"
    runner = RunCommand(cmd)
    obj = json.loads(runner.output)
    cmd_opts = ""
    for item in obj.items():
        if cmd_opts != "":
            cmd_opts += ","
        cmd_opts += "{}={}".format(item[0], item[1])
    return cmd_opts

def open_and_redirect_os_stdout(log_file):
    file = open(log_file, "w")
    original_stdout_fd = sys.stdout.fileno()

    #libc = ctypes.CDLL(None)
    #c_stdout = ctypes.c_void_p.in_dll(libc, 'stdout')
 
    #libc.fflush(c_stdout)
    # Make original_stdout_fd point to the same file as to_fd
    os.dup2(file.fileno(), original_stdout_fd)
   


def log_pods_of_deployment(namespace, deployment_name, outputdir):
    selector_label = get_deployment_selector(namespace, deployment_name)

    # show the pods of this deployment and their status
    cmd = "{} -n {} get pods -l {}".format(Util.get_kubectl(), namespace, selector_label)
    runner = RunCommand(cmd)  

    print(runner.output)

    # this clusterfuck gets the following:
    # each line starts with the name of the pod, then followed by the names of the containers.

    cmdex = cmd +  """ -o jsonpath="{range .items[*]}{' '}{.metadata.name}{range .spec.containers[*]}{' '}{.name}{end}{'\\n'}{end}" """
    runner = RunCommand(cmdex)  
    print(runner.output)

    # make the log dir
    if not os.path.isdir(outputdir):
        os.mkdir(outputdir)

    child_pids = []

    for line in runner.output.split("\n"):
        if line != "":   
            tokens = line.split()

            pod_name=tokens[0]
            pod_dir = os.path.join(outputdir, pod_name)

            if not os.path.isdir(pod_dir):
                os.mkdir(pod_dir)

            del(tokens[0])

            print("starting to log ...")

            for container_name in tokens:
                log_file = "{}/{}.log".format(pod_dir, container_name)

                print("logging pod {} container {}".format(pod_name, container_name))
                cmdlog = "{} logs -n {} --follow {} -c {}".format(Util.get_kubectl(), namespace, pod_name, container_name)

                print("log cmd: {}".format(cmdlog))

                parent_pid = os.getpid()
                child_pid = os.fork()
                if child_pid == 0:

                    cmd_list = cmdlog.split()

                    # this one works only on stuff used by python's pring
                    #sys.stdout = open(log_file, "w")
                    #sys.stderr = sys.stdout

                    open_and_redirect_os_stdout(log_file)

                    os.execvp(cmd_list[0], cmd_list)
                    exit(1)
                else:
                    child_pids.append(child_pid)   

            

    print("logging started. Press enter to stop logging...")
    input()

    print("stopping logging...")
    print(child_pids)
    for pid in child_pids:
        os.kill(pid, signal.SIGSTOP)


def parse_cmd_line():
    if len(sys.argv) == 2 and sys.argv[1] == '-h' and os.environ.get("SHORT_HELP_MODE"):
        print("follows logs of all containers in all pods of a deployment, for some time period")
        sys.exit(1)
    
    usage = '''
This program starts to follow the logs of containers in all pods of a kubernetes deployment.
The output is written to a file per container.
The script then waits for user input, logging is stopped once the user has pressed enter.

'''
    parse = argparse.ArgumentParser(description=usage, \
                formatter_class=argparse.ArgumentDefaultsHelpFormatter)

    group = parse.add_argument_group("log  pods/containers in deployment")

    group.add_argument('--namespace', '-n', type=str, default="", \
            dest='namespace', help='optional: specify namespace of deployment')

    group.add_argument('--deployment', '-p', type=str, default="", \
            dest='deployment', help='mandatory: name of deployment')

    group.add_argument('--dir', '-d', type=str, default="", \
            dest='outdir', help='mandatory: name of output directory')

    group.add_argument('--kubectl', '-k', type=str, default="kubectl", \
            dest='kubecmd', help='optional: name of kubectl command')   

    group.add_argument('--trace', '-x', action='store_true', \
            dest='trace', help='optional: enable tracing')   

    return parse.parse_args(), parse


def main():
    cmd_args, cmd_parser = parse_cmd_line()

    RunCommand.trace(cmd_args.trace)
    Util.set_kubectl(cmd_args.kubecmd)


    if cmd_args.deployment != "" and cmd_args.outdir != "":
        log_pods_of_deployment(cmd_args.namespace, cmd_args.deployment, cmd_args.outdir)
    else:
        cmd_parser.print_help()

main()        

