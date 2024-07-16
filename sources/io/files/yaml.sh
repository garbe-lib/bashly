import array

function parse_yaml(){
    # Missing features / TODO
    # - inline lists, and associative lists in general
    # - comments of all types
    # - chomping
    # - preserving
    # - Single quote multiline and escaping characters

    local delimiter=':'
    local vert='|'
    local folding_mode=0
    local old_folding_mode=0
    declare -n parsed=$2
    
    new array pointer
    new array indents
    prev_indent=-1

    while IFS= read -r line; do
        # Folding strings

        line=${line%%#*}
        if [[ -z "$line" ]]; then
            continue
        fi
        
        indent=$(expr match "$line" " *")
        line="${line:indent}"
        stripped="${line//[[:space:]]/}"
        fieldname=( "${stripped%%"$delimiter"*}" )
        
        # set folding mode
        if [[ $line == *\>*([:space:]) ]]; then
            folding_mode=1
            line=${line%\>}
        elif [[ $line == *\>\+*([:space:]) ]]; then
            folding_mode=2
            line=${line%\>\+*}
        elif [[ $line == *\>\-*([:space:]) ]]; then
            folding_mode=3
            line=${line%\>\-*}
        elif [[ $line == *\|*([:space]) ]]; then
            folding_mode=4
            line=${line%"$vert"}
        elif [[ $prev_indent -gt $indent ]]; then
            folding_mode=0
        fi

        if [[ $old_folding_mode != $folding_mode ]]; then
            case $old_folding_mode in
                1)
                    echo "1 -> 0"
                    ;;
                2)
                    echo "2 -> 0"
                    
                    value=${parsed[$folding_fieldname]}
                    value=${value/%[[:space:]]/"\n"}
                    parsed[$folding_fieldname]="$value"
                    ;;
                3)
                    echo "3 -> 0"
                    value=${parsed[$folding_fieldname]}
                    value=${value%%[[:space:]]}
                    parsed[$folding_fieldname]="$value"
                    ;;
                4)
                    echo "4 -> 0"
                    ;;
            esac
            old_folding_mode=$folding_mode
            unset folding_fieldname
        fi
        
        #echo "$prev_indent, $indent : $line"
        
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

            case $folding_mode in
                0)
                    if [[ ! -z "$value" ]]; then
                        parsed[$path]="$value"
                    else
                        parsed[$path";"]="$fieldname"
                    fi
                    ;;
                1) 
                    # Folding >
                    if [[ -z "$value" ]]; then
                        folding_fieldname=$path
                    else
                        parsed[$folding_fieldname]+="$value"
                    fi
                    ;;
                2)
                    # Folding >+
                    # one line with \n at end
                    if [[ -z "$value" ]]; then
                        folding_fieldname=$path
                    else
                        value="$value "
                        value=${value/%[[:space:]]/ }
                        parsed[$folding_fieldname]+="$value"
                    fi
                    ;;
                3)
                    # Folding >-
                    if [[ -z "$value" ]]; then
                        folding_fieldname=$path
                    else
                        value="$value "
                        value=${value/%[[:space:]]/ }
                        parsed[$folding_fieldname]+="$value"
                    fi
                    ;;
                4)
                    # Folding |
                    if [[ -z "$value" ]]; then
                        folding_fieldname=$path
                    else
                        parsed[$folding_fieldname]+="$value\n"
                    fi
                    ;;
            esac
                
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
