import numpy as np
from xonsh.ptk.key_bindings import carriage_return
import time
from threading import Lock
from xonsh.proc import foreground
import threading
import re

SECTION_RE = re.compile('#:section\s*\n')

pauseLock = Lock()

PLAY  = '\u25b6 ' # ▶
STOP  = '\u25a0 ' # ■
PAUSE = b'\xe2\x9d\x9a\xe2\x9d\x9a ' # '❚❚'
WAIT =  '\u29d7 ' # '⧗'

from contextlib import contextmanager

@contextmanager
def status(new):
    old = $FORMATTER_DICT['p_status']
    #print('old is', old)
    $FORMATTER_DICT['p_status'] = new
    shell =  __xonsh_shell__.shell
    shell._prompt_tokens = shell.prompt_tokens(None)
    shell.prompter.cli.request_redraw()
    try:
        # print('before yield')
        yield
    except Exception as e:
        pass
    finally:
        $FORMATTER_DICT['p_status'] = old
        shell._prompt_tokens = shell.prompt_tokens(None)
        shell.prompter.cli.request_redraw()


def dec_status(stat):
    def dec(func):
        def wrapped(*args, **kwargs):
            with status(stat):
                return func(*args, **kwargs)
        return wrapped
    return dec



@dec_status(PLAY)
def fake_write(text, lattency):
    lattency = lattency * 2
    time.sleep(0.4)
    line = ''
    for line in text.splitlines():
        shell = __xonsh_shell__.shell
        # if line.startswith(('#:pause',)):
        #     pauseLock.acquire()
        #     shell.prompter.cli.eventloop.call_from_executor(lambda :pauseLock.acquire(False))
        #     continue
        if line.startswith(('#:sleep',)):
            time.sleep(int(line[7:])*lattency)
            continue

        for c in line:
            pauseLock.acquire() 
            pauseLock.release() 
            def update_text():
                cli = shell.prompter.cli
                buff = cli.buffers['DEFAULT_BUFFER']
                buff.insert_text(c)
            s = (np.random.randn(1)+2)/100
            shell.prompter.cli.eventloop.call_from_executor(update_text)
            time.sleep(max(s[0]*lattency, 0.01))
        with status(WAIT):
            time.sleep(0.2*lattency)
        def bar():
            cli = shell.prompter.cli
            buff = cli.buffers['DEFAULT_BUFFER']
            return carriage_return(buff, cli, autoindent=False)


        shell.prompter.cli.eventloop.call_from_executor(bar)
        time.sleep(0.5*lattency)
    global ind
    ind +=1
    shell._prompt_tokens = shell.prompt_tokens(None)
    __xonsh_shell__.shell.prompter.cli.request_redraw()




queue = []
gen = None

def loop_in_thread(latency):
    global gen







def _start(name, latency=1):
    $FORMATTER_DICT['p_status'] = STOP
    with open(name) as f:
        string = f.read()

    queue.extend(SECTION_RE.split(string))

def _stop():
    $FORMATTER_DICT['p_status'] = None
    global queue
    queue=[]
    global ind
    ind = 0 


_slow_factor = 1

def _speed(speed_str):
    global _slow_factor
    _slow_factor = 1/float(speed_str)



aliases['start'] = foreground(lambda args,stdin : _start(*args))
aliases['stop'] = foreground(lambda args,stdin : _stop(*args))
aliases['speed'] = foreground(lambda args,stdin : _speed(*args))


from prompt_toolkit.keys import Keys


        



def xontrib_init(*args, **kw):

    handle = __xonsh_shell__.shell.key_bindings_manager.registry.add_binding
    global ind
    ind = 0

    from random import randint

    $FORMATTER_DICT['presentation_index'] = lambda : str(ind) if ind else None
    $FORMATTER_DICT['p_status'] = None
    $PREFIX = '{presentation_index:{}|}{p_status:{}}' 
    $PROMPT = $PREFIX+$PROMPT

    @handle(Keys.ControlK)
    def _(event):
        global ind
        ind -=1
        shell = __xonsh_shell__.shell
        shell._prompt_tokens = shell.prompt_tokens(None)
        __xonsh_shell__.shell.prompter.cli.request_redraw()

    @handle(Keys.ControlL)
    def _(event):
        global ind
        ind +=1
        shell = __xonsh_shell__.shell
        shell._prompt_tokens = shell.prompt_tokens(None)
        __xonsh_shell__.shell.prompter.cli.request_redraw()


 
    @handle(Keys.ControlN)
    def _(event):
        global _slow_factor
        shell = __xonsh_shell__.shell
        shell._prompt_tokens = shell.prompt_tokens(None)
        __xonsh_shell__.shell.prompter.cli.request_redraw()
        if not len(queue):
            print('Nothing loaded')
            return
        if ind-1 >= len(queue) :
            print('Too far !')
        elif ind < 1:
            print('Too small')
        else:
            t = threading.Thread(target=fake_write, args=(queue[ind-1], _slow_factor,)).start()


    @handle(Keys.ControlP)
    def _(event):
        if not pauseLock.acquire(False):
            pauseLock.release() 

