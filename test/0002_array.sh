import array

new array a ; assert 0 "Creating new array"

$a push "test"
$a push "test1"
$a push "test2"
[[ "${__a[@]}" == "test test1 test2" ]] ; assert 0 "Pushing elements"


$a pop item
[[ "$item" == "test2" && "${__a[@]}" == "test test1" ]] ; assert 0 "Pop element"


function foo(){
    echo "$1,"
}
res=$($a foreach foo)
expected=$(echo -e "test,\ntest1,")
[[ "$res" == "$expected" ]] ; assert 0 "Pass each array element to function"

$a push "test3"
res=$($a print)
[[ $res == "[ test test1 test3 ]" ]] ; assert 0 "Print array"

$a popn 2
res=$($a values)
[[ $res == "test" ]] ; assert 0 "Remove n elements from tail of array"


[[ "test" == "$($a get 0)" ]] ; assert 0 "Get array element by index"
