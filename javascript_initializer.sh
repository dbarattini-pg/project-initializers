#! /bin/bash

INIT=0

usage()
{
  echo "Usage: javascript_initializer [ -i | --init ]"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n javascript_initializer -o i --long init -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi
eval set -- "$PARSED_ARGUMENTS"

while :
do
  case "$1" in
    -i | --init)   INIT=1      ; shift   ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
    # If invalid options were passed, then getopt should have reported an error,
    # which we checked as VALID_ARGUMENTS when getopt was called...
    *) echo "Unexpected option: $1 - this should not happen."
       usage ;;
  esac
done

((INIT)) && yarn init
yarn add --dev eslint eslint-config-prettier prettier json
read -p 'Use JSON as config file format when requested'
yarn run eslint --init --plugin eslint-config-prettier
rm package-lock.json

yarn json -I -f .eslintrc.json -e "this.extends.push('eslint-config-prettier')"

echo '{"singleQuote": true}' > .prettierrc.json
yarn prettier --write .
yarn remove json
rm javascript_initializer.sh