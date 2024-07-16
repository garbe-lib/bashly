import io/files/yaml

declare -A ymldata
parse_yaml "./test/data/example.yml" ymldata

for key in ${!ymldata[@]}; do
    echo "k: $key -> v: ${ymldata[$key]}"
done

REGEX_USER="*([-_[:alnum:]])"

query_yaml ymldata "user,$REGEX_USER;" users
for user in ${users[@]}; do
    echo "$user"
done

