#!/usr/bin/env python3 

import subprocess
import shlex
import json
import os
import signal
import sys
import ctypes
import argparse
import datetime

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


def get_selector(namespace, object_type, object_name):
    cmd = "{} -n {} get {} {}".format(Util.get_kubectl(), namespace, object_type, object_name) + " -o jsonpath='{.spec.selector.matchLabels}'"
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

def intput_with_timeout(timeout_sec):
    import select

    ready, _, _ = select.select([sys.stdin], [],[], timeout_sec)
    if ready:
        return sys.stdin.readline().rstrip('\n'), True

    return "", False


   
   

class LogPods:
    def __init__(self, namespace, object_type, object_name, outputdir):
        self.child_pids = []
        self.pods_handled = {} 

        self.namespace = namespace
        self.outputdir = outputdir
        self.selector_label = get_selector(self.namespace, object_type, object_name)


    def show_pids_in_deployment(self):
        # show the pods of this deployment and their status
        self.get_pods_cmd = "{} -n {} get pods -l {}".format(Util.get_kubectl(), self.namespace, self.selector_label)
        runner = RunCommand(self.get_pods_cmd)  

        strnow = str(datetime.datetime.now())
        print(runner.output.replace("\n","\n{} ".format(strnow)))


    def run(self):    
        self.show_pids_in_deployment()

        print("starting to log ...")

        # make the log dir
        if not os.path.isdir(self.outputdir):
            os.mkdir(self.outputdir)

        self.scand_pods_and_start_logging(True)

        print("press enter to stop logging")
        while True:

            text, has_pressed = intput_with_timeout(1)

            if has_pressed:
                break

            self.scand_pods_and_start_logging(False)

        self.stop_logging()

    def scand_pods_and_start_logging(self, first_call): 

        # this clusterfuck gets the following:
        # each line starts with the name of the pod and it's phase,  then followed by the names of the containers for that pod

        cmdex = self.get_pods_cmd +  """ -o jsonpath="{range .items[*]}{' '}{.metadata.name}{' '}{.status.phase}{range .spec.containers[*]}{' '}{.name}{end}{'\\n'}{end}" """
        runner = RunCommand(cmdex)  

        handled_pods = []

        for line in runner.output.split("\n"):
            if line != "":   
                tokens = line.split()

                pod_name=tokens[0]
                pod_phase=tokens[1]

                if pod_phase != "Running":
                    continue

                handled_pods.append(pod_name)

                if not pod_name in self.pods_handled:

                    if not first_call:
                        strnow = str(datetime.datetime.now())
                        print("{} {} {}".format(strnow, pod_name, pod_phase))

                    pod_dir = os.path.join(self.outputdir, pod_name)

                    if not os.path.isdir(pod_dir):
                        os.mkdir(pod_dir)

                    del tokens[0]
                    del tokens[0]

                    for container_name in tokens:
                        log_file = "{}/{}.log".format(pod_dir, container_name)

                        print("logging pod {} container {}".format(pod_name, container_name))
                        cmdlog = "{} logs -n {} --follow {} -c {}".format(Util.get_kubectl(), self.namespace, pod_name, container_name)

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
                            self.pods_handled[pod_name] = child_pid   

        if not first_call:
            for pod in set(self.pods_handled.keys()):
                if not pod in handled_pods:
                    strnow = str(datetime.datetime.now())
                    print("{} pod {} stopped".format(strnow, pod))
                    del self.pods_handled[pod]

    def stop_logging(self):
        print("stopping logging...")
        for pid in self.pods_handled.values():
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

    group = parse.add_argument_group("log  pods/containers in either one of deployment/replicaset/statefuleset")

    group.add_argument('--namespace', '-n', type=str, default="", \
            dest='namespace', help='optional: specify namespace of deployment')

    group.add_argument('--deployment', '-d', type=str, default="", \
            dest='deployment', help='name of deployment')

    group.add_argument('--stset', '-s', type=str, default="", \
            dest='statefulset', help='name of statefull set')

    group.add_argument('--rset', '-r', type=str, default="", \
            dest='replicaset', help='name of replica set')

    group.add_argument('--out', '-o', type=str, default="", \
            dest='outdir', help='mandatory: name of output directory')

    ctl_cmd = group.add_argument('--kubectl', '-k', type=str, default="kubectl", \
            dest='kubecmd', help='optional: name of kubectl command')   

    group.add_argument('--trace', '-x', action='store_true', \
            dest='trace', help='optional: enable tracing')   

    group = parse.add_argument_group("suport for bash autocompletion of command line arguments")

    group.add_argument('--complete-bash', '-b', action='store_true', \
            dest='complete_bash', default=False,  help='show bash source of completion function')

    group.add_argument('--complete', '-c', action='store_true', \
            dest='complete', default=False,  help='internal: used during code completion')

    # that's the trick for having the same option in two groups
    group._group_actions.append(ctl_cmd)

    #group.add_argument('--kubectl', '-k', type=str, default="kubectl", \
    #        dest='kubecmd', help='optional: name of kubectl command') 

    return parse.parse_args(), parse

def bash_complete():
    current_word = os.getenv('COMP_CWORD')
    cmdline = os.getenv('COMP_LINE')
 

    if current_word != "":

        current_word_index = int(current_word)
        words = cmdline.split()


        if words[current_word_index-1] == "-n":
            cmd = Util.get_kubectl() + """ get namespaces -o jsonpath="{.items[*]['metadata.name']}" """
            runner = RunCommand(cmd)  
            print(runner.output)
        elif get_obj_type_from_option(words[current_word_index-1]):
        
            obj_type = get_obj_type_from_option(words[current_word_index-1])
            
            # was there a namespace specified?
            namespace = "default"
            for i in range(0,len(words)-1):
                if words[i] == "-n":
                    namespace = words[i+1]
            cmd = Util.get_kubectl() + " get " + obj_type + " -n " + namespace + """ -o jsonpath="{.items[*]['metadata.name']}" """
            #print(cmd, file=sys.stderr)
            runner = RunCommand(cmd)  
            print(runner.output)
        elif words[current_word_index-1][0:1] == "-":
            print ("--namespace --deployment --rset --stset --out --kubectl --trace -n -d -r -s -o -k -x")


def get_obj_type_from_option(opt_string):
    if opt_string == "-d" or opt_string == "--deployment":
        return "deployment"
    if opt_string == "-r" or opt_string == "--rset":
        return "replicaset"
    if opt_string == "-s" or opt_string == "--stset":
        return "statefulset"
    return ""


def show_bash_completion():
    print("""
function _follow-kube-logs {
    local cur opts

    export COMP_CWORD
    export COMP_LINE
    opts=$(follow-kube-logs.py -c """ + "-k {}".format( Util.get_kubectl() ) + """ )
    cur="${COMP_WORDS[COMP_CWORD]}"

    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _follow-kube-logs follow-kube-logs.py
""")


def main():
    cmd_args, cmd_parser = parse_cmd_line()

    Util.set_kubectl(cmd_args.kubecmd)

    if cmd_args.complete:
        bash_complete()
    elif cmd_args.complete_bash:
        show_bash_completion()    
    elif (cmd_args.deployment != "" or cmd_args.replicaset != "" or cmd_args.statefulset != "") and cmd_args.outdir != "":
        RunCommand.trace(cmd_args.trace)

        if cmd_args.deployment != "":
            obj_type="deployment"
            obj_name=cmd_args.deployment
        elif cmd_args.replicaset != "":
            obj_type="replicaset"
            obj_name=cmd_args.replicaset
        elif cmd_args.statefulset != "":
            obj_type="statefulset"
            obj_name=cmd_args.statefulset

        log_pods = LogPods(cmd_args.namespace, obj_type, obj_name, cmd_args.outdir)
        log_pods.run()
    else:
        cmd_parser.print_help()

main()        

