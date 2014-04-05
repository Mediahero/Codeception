# Bash autocompletion for Codeception.
# Copy/symlink this script to /etc/bash_completion.d/codecept and restart your bash

_codecept()
{ 
    local cur prev commands opts prefix base_opts base_cmds generate_cmds refactor_cmds

    COMPREPLY=()

    cur=${COMP_WORDS[COMP_CWORD]}
    prev=${COMP_WORDS[COMP_CWORD-1]}

    base_opts="--help --quiet --verbose --version --ansi --no-ansi --no-interaction"

    base_cmds="analyze bootstrap build clean console help list run"
    
    generate_cmds="generate:cept generate:cest generate:group\
                generate:pageobject generate:scenarios\
                generate:stepobject generate:suite\
                generate:test generate:phpunit"

    refactor_cmds="refactor:add-namespace"

    case "$prev" in
        codecept)
            commands="${base_cmds} ${generate_cmds} ${refactor_cmds}"
            ;;        
        bootstrap)
            opts="-ns --namespace ${base_opts}"
            ;;
        help)
            opts="--xml --format --raw ${base_opts}"
            commands="${base_cmds} ${generate_cmds} ${refactor_cmds}"
            ;;
        list)            
            opts="--xml --raw --format"
            ;;
        run)
            opts="--config --report --html --xml --tap --json --colors\
                --no-colors --silent --steps --debug --coverage --no-exit\
                --defer-flush --group --skip --skip-group --env ${base_opts}"
            ;;    
        add-namespace)
            opts="--force -c --config ${base_opts}"
            commands="${opts}"            
            ;;
        -c|--config)
            _filedir '@(yml)'
            return 0
            ;;
        *)
            opts="-c --config ${base_opts}"
            commands="${opts}"
            ;;        
    esac

    # ":" is treated as separate option so we need this workaround 
    # to get generate:* and refactor:* actions properly completed
    if [[ "$prev" == ":" || "$cur" == ":" ]]; then
        if [[ "$cur" == ":" ]]; then    
            prefix="$prev"
        else
            prefix="${COMP_WORDS[COMP_CWORD-2]}"
        fi
        case "$prefix" in
            generate)
                commands=$(echo "${generate_cmds}" | sed 's/generate://g')
                ;;
            refactor)
                commands=$(echo "${refactor_cmds}" | sed 's/refactor://g')
                ;;
        esac 
        if [[ "$cur" == ":" ]]; then
            COMPREPLY=( $( compgen -W "${commands}" ) )            
            return 0
        fi        
    fi

    if [[ ${cur} == -* ]]; then
        COMPREPLY=($( compgen -W "${opts}" -- "${cur}" ))
    else
        COMPREPLY=($( compgen -W "${commands}" -- "${cur}" ))
    fi    

    if [[ -z $COMPREPLY ]]; then
        _filedir
    fi

    return 0;
}

complete -F _codecept $filenames codecept