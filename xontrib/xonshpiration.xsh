import numpy as np
from xonsh.ptk.key_bindings import carriage_return
import time
from threading import Lock

pauseLock = Lock()
pauseLock.acquire()


def fake_write(string, lattency):
    time.sleep(0.4)
    for line in string.splitlines(): 
        shell = __xonsh_shell__.shell
        if line.startswith(('#:pause',)):
            pauseLock.acquire()
            continue
        for c in line:
            def update_text():
                cli = shell.prompter.cli
                buff = cli.buffers['DEFAULT_BUFFER']
                buff.insert_text(c)
            s = np.random.randn(1)*0.03+0.07
            shell.prompter.cli.eventloop.call_from_executor(update_text)
            time.sleep(max(s[0]*lattency, 0.05))
        time.sleep(0.2*lattency)
        def bar():
            cli = shell.prompter.cli
            buff = cli.buffers['DEFAULT_BUFFER']
            return carriage_return(buff, cli, autoindent=False)


        shell.prompter.cli.eventloop.call_from_executor(bar)
        time.sleep(1*lattency)




def loop_in_thread(string, latency):
    fake_write(string, latency)


import threading


def s(name, latency=1):
    with open(name) as f:
        string = f.read()

    return threading.Thread(target=loop_in_thread, args=(string, 0.3*latency)).start()

from xonsh.proc import foreground

aliases['start'] = foreground(lambda args,stdin : s(*args))

handle = __xonsh_shell__.shell.key_bindings_manager.registry.add_binding

from prompt_toolkit.keys import Keys

@handle(Keys.ControlN)
def _(event):
    # pauseLock.acquire(False)
    pauseLock.release()
