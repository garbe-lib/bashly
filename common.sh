function assert(){
    rv=$?
    if [[ $rv == $1 ]]; then
        echo -e "[ \x1b[32;1mpassed\x1b[0m ] $2"
    else
        echo -e "[ \x1b[31;1mfailed\x1b[0m ] $2"
    fi
}
