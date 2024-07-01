#!/usr/bin/bash

if [[ "$(basename -- "$0")" != "bashly.sh" ]]; then
    >&2 echo "Cannot be run. Use source $0"
    exit 1
fi

unset BASHLY_PATH
export BASHLY_PATH="$(cd "$(dirname "$0")"; pwd)/sources"

function import() {
    package=$1
    
    package=${BASHLY_PATH}/${package//:/\/}

    # version greater equal
    pieces=(${package//+/+ })
    
    if [[ ${#pieces[@]} > 1 ]]; then
        for i in ${!pieces[*]}; do
            piece=${pieces[i]}
            if [[ "${piece: -1}" != "+" ]]; then
                continue
            fi
            version=$(basename -- ${piece:1:-1})
            parent=${piece%\/*}
            for folder in $(ls $parent)
            do
                if [[ "$folder" > "$version" || "$folder" == "$version" ]]
                then
                    version=$folder
                    solution=$folder
                fi
            done
            if [[ -z $solution ]]; then
                >&2 echo "Could not resolve version"
                return 1
            else
                pieces[$i]="$parent/$solution"
            fi
        done
        package=$(IFS=;echo "${pieces[*]}")
        
    fi

    if [[ -f ${package}.sh ]]; then
        source ${package}.sh
    elif [[ -d $package ]]; then
            source $package/*.sh
    else
        >&2 echo "Did not find $package"
    fi

    return 0
}
