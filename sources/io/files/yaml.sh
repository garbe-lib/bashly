import array

function parse_yaml(){
    # Missing features / TODO
    # - inline lists, and associative lists in general
    # - comments of all types
    # - chomping
    # - preserving

    local delimiter=':'

    declare -n parsed=$2
    
    new array pointer
    new array indents
    prev_indent=-1

    while IFS= read -r line; do
        line=${line%%#*}
        if [[ -z "$line" ]]; then
            continue
        fi
        
        indent=$(expr match "$line" " *")
        line="${line:indent}"
        stripped="${line//[[:space:]]/}"
        fieldname=( "${stripped%%"$delimiter"*}" )
        
        #echo "$indent : $line"
        if [[ $prev_indent -gt $indent ]]; then
            len=$($indents len)
            i=$(( len -1 ))
            for (( ; i>0; i-- ));
            do
                if [[ $indent == $($indents get $i) ]]; then
                    break
                fi
            done
            n=$(( $len - $i ))
            
            #$pointer print
            #$indents print
            $pointer popn $n
            $indents popn $n
            $pointer push $fieldname
            $indents push $indent
            #$pointer print
            #$indents print

        elif [[ $prev_indent -lt $indent ]]; then
            arraycount=0
            if [[ ! $fieldname == -* ]]; then
                $indents push $indent
                $pointer push $fieldname
                #$pointer print
                #$indents print
            fi
        fi

        if [[ $fieldname == -* ]]; then
            path="$($pointer values)"
            value=${line#-}
            value="${value##[[:space:]]}"
            parsed["${path//[[:space:]]/,}$arraycount"]="$value"
            #echo "$path[$arraycount] -> $value"
            let ++arraycount
        else
            value="${line#*"$delimiter"}"
            value="${value##[[:space:]]}"

            $pointer popn 1
            $pointer push $fieldname
            path="$($pointer values)"
            path="${path//[[:space:]]/,}"

            if [[ ! -z "$value" ]]; then
                parsed[$path]="$value"
                #echo "$path -> $value"
            else
                parsed[$path";"]="$fieldname"
                #echo "$path /-> $fieldname"
            fi
        fi
        
        prev_indent=$indent
    done < $1
    
    #for key in "${!parsed[@]}"; do
    #    echo "k: $key v: ${parsed[$key]}"
    #done
    
}

function query_yaml(){
    local -n __yaml_source=$1
    local -n __query_result=$3
    query="$2"
    
    __query_result=()
    for key in "${!__yaml_source[@]}"; do
        if [[ "$key" == $query ]]; then
            #__result["$key"]=${source[$key]}
            __query_result+=("${__yaml_source[$key]}")
        fi
    done
}

#function set_yaml(){
#}

#function write_yaml(){
#}
