# welcome to xonsh!
1+1
#:sleep 1
# woah! mind blown...
#:sleep 3
clear
# env variable are typed
# press ctrl-N to resume...
#:section
$HOME
x= 'US'
${x+'ER'}
$PATH
sorted($PATH[3:7])
#:sleep 3
clear
# file names can be globbed with regexes
ls  -l `xonsh/\w+?(ci|ic).*`
#:sleep 3
clear
# aliases can be lists or function
aliases['ls']
aliases['banana'] = lambda args,stdin=None: "Banana, for scale\n"
banana
#:sleep 3
clear
exit
