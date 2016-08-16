clear
# next, some python...
#:section
# this is xonshpiration
print("everybody wonder how you can type this fast ! During your presentations !")

# next, multiline
#:section

#easy....
for i in range(10):
    print('Practice !')
echo "The Xonsh is a lie !"


# next, envs
#:section
# let simplify out prompt
$OLD_PROMPT = $PROMPT
$PROMPT = '{env_name:{} }{BOLD_BLUE}{cwd}{branch_color}{curr_branch: {}}{prompt_end}{NO_COLOR} '

# as you can see it's pretty easy to change prompt, let's
# restore the old one...

$PROMPT = $OLD_PROMPT
