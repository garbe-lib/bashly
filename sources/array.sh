function new() {
    ctor="$1.__init__"
    $ctor $2
    declare -n obj=$2
    obj="$1 $2"
}

function array() {
    if [[ ${#@} == 1 ]]; then
        local -n this=__$1
        return
    fi
    member="array.$2"
    this=$1
    shift 2
    $member $this $@
}

function array.__init__() {
    declare -n __refdata_array=__$1
    __refdata_array=()
}

function array.pop() {
    local -n __refdata_array=__$1
    shift
    local _n=0
    for _i; do
        local -n __array__item=$_i
        __array__item=${__refdata_array[-1]}
        unset __refdata_array[-1]
        let ++_n
    done
}

function array.popn() {
    local -n __refdata_array=__$1
    shift
    local _n=$1
    for (( _i=0; _i<$_n;++_i )); do
        unset __refdata_array[-1]
    done
}

function array.push() {
    local -n __refdata_array=__$1
    shift 1
    __refdata_array+=( "$1" )
}

function array.values() {
    local -n __refdata_array=__$1
    echo ${__refdata_array[*]}
}

function array.foreach() {
    local -n __refdata_array=__$1
    shift
    for item in ${__refdata_array[*]};do
        $1 $item
    done
}

function array.print() {
    local -n __refdata_array=__$1
    echo "[ ${__refdata_array[@]} ]"
}

function array.len() {
    local -n __refdata_array=__$1
    echo ${#__refdata_array[@]}
}

function array.get() {
    local -n __refdata_array=__$1
    echo ${__refdata_array[$2]}
}
