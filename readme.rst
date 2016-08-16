Need custom patch to xonsh ! Does not work yet neither with xonsh stable, nor xonsh master !

Xonshpiration
=============

How can you type so fast ?

That's easy, the xonsh is a lie ! Load Xonshpiration and the shell can animate
itself.

Warning extremely experimental ! To use ::

    xontrib load xonshpiration
    start <file.xsh>
    # press Ctrl-L to go to section 1 of your `.xsh` file, and `Ctrl-N` to start playing.

You can separate your `.xsh` file into sections using the `#:section` marker.
Use Ctrl-L/K to move between section (the current section number is shown in
front of the prompt), use Ctrl-N to start playing a new section.

Use `#:sleep <value>` to sleep `<value>` number of second at certain points.
Use it if a command takes a long time, or xonshpiration will try to start
typing before the end.

While Xonshpiration is typing you can use `Ctrl-P` to pause it. Press
`Control-P` again to resume.






