
source ${HOME}/.privatevars

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/${USER}/google-cloud-sdk/path.bash.inc' ]; then . '/Users/${USER}/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/${USER}/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/${USER}/google-cloud-sdk/completion.bash.inc'; fi

# The below section accounts for AAsman's gcp tools
if [[ -f ${GCPUTIL} ]]; then
    if [[ ${ZSH_VERSION} ]]; then
        emulate bash -c "source ${GCPUTIL}"
    else
        source ${GCPUTIL}
    fi

    #Set project in this shell to last set project
    last_project=$(__last_set_project)
    if [[ ${last_project} ]]; then
        echo "Using last set gcp project $last_project"
        setgcp ${last_project}
    fi

    #---------------
    # Shell Prompt
    #---------------
    red='\e[0;31m'
    RED='\e[1;31m'
    lime='\e[0;32m'
    LIME='\e[1;32m'
    yellow='\e[0;33m'
    YELLOW='\e[1;33m'
    blue='\e[0;34m'
    BLUE='\e[1;34m'
    cyan='\e[0;36m'
    CYAN='\e[1;36m'
    NC='\e[0m'  

    if [[ "${DISPLAY#$HOST}" != ":0.0" &&  "${DISPLAY}" != ":0" ]]; then
        PRMTCLR=${cyan}   # remote machine: prompt will be partly cyan
    else
        PRMTCLR=${yellow}  # local machine: prompt will be partly red
    fi

    R=$RED
    B=$BLUE
    Y=$YELLOW
    G=$LIME
    P=$PRMTCLR

    #  --> Replace instances of \W with \w in prompt functions below
    #  --> to get display of full path name.

    function fastprompt()
    {
        case $TERM in
            *term | rxvt | *term-color | xterm-* | screen-256color)
                unset PROMPT_COMMAND


                # prompt command that doesn't affect title bar
                #PS1="\[${PRMTCLR}\][\u@\h] \W <\$?> \[${NC}\]"

                # prompt command that does affect title bar
                PS1="\[\e]2;\h:\W\a$P\][\[$B\]\u\[$NC\]@\[$G\]\h\[$NC\]#\[$R\]\$(getgcp)\[$P\]] \W <\$?> \[$NC\]"
                ;;
            linux)
                unset PROMPT_COMMAND
                PS1="\[$P\][\[$B\]\u\[$NC\]@\[$G\]\h\[$NC\]#\[$R\]\$(getgcp)\[$P\]] \W <\$?> \[$NC\]"
                ;;
            *)
               PS1="[\u@\h] \w > " ;;
        esac
    }
    
    fastprompt
fi