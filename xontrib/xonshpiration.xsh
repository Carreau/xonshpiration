import numpy as np
from xonsh.ptk.key_bindings import carriage_return
import time


def fake_write(string, lattency):
    time.sleep(0.4)
    for line in string.splitlines(): 

        for c in line:
            def update_text():
                cli = __xonsh_shell__.shell.prompter.cli
                buff = cli.buffers['DEFAULT_BUFFER']
                buff.insert_text(c)
            s = np.random.randn(1)*0.03+0.07
            __xonsh_shell__.shell.prompter.cli.eventloop.call_from_executor(update_text)
            time.sleep(max(s[0]*lattency, 0.05))
        time.sleep(0.2*lattency)
        def bar():
            cli = __xonsh_shell__.shell.prompter.cli
            buff = cli.buffers['DEFAULT_BUFFER']
            carriage_return(buff, cli, '')


        __xonsh_shell__.shell.prompter.cli.eventloop.call_from_executor(bar)
        time.sleep(1*lattency)

        #__xonsh_shell__.shell.prompter.cli.buffers['DEFAULT_BUFFER'].insert_text('')


import asyncio

def loop_in_thread(loop, string, latency):
    #asyncio.set_event_loop(loop)
    fake_write(string, latency)
    #loop.run_until_complete()


import threading


def s(latency=1):
    loop = asyncio.get_event_loop()
    string = \
"""print("This is Xonshpiration")
print("Beautiful is better than ugly.")

for i in range(10):
    print('real multiline edittion')
"""
    return threading.Thread(target=loop_in_thread, args=(loop,string, 0.3*latency)).start()

