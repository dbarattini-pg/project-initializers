#! /bin/bash

ESLINT_CONF_FILE='.eslintrc.json'

yarn init

node > out_package.json <<EOF
var data = require('./package.json');
data.scripts = {...data.scripts};
data.dependencies = {...data.dependencies};
console.log(JSON.stringify(data));
EOF
mv out_package.json package.json

yarn add --dev eslint eslint-config-prettier prettier
yarn run eslint --init --plugin eslint-config-prettier
rm package-lock.json

if [ -f ./.eslintrc.js ]
then
  ESLINT_CONF_FILE='.eslintrc.js'
fi

node > out${ESLINT_CONF_FILE} <<EOF
var data = require('./${ESLINT_CONF_FILE}');
data.extends.push('eslint-config-prettier');
if('${ESLINT_CONF_FILE}'==='.eslintrc.js'){
  console.log('module.export = ' + JSON.stringify(data));
} else {
  console.log(JSON.stringify(data));
}
EOF
mv out${ESLINT_CONF_FILE} ${ESLINT_CONF_FILE}

if [ ! -e .prettier.json ]
then
  echo '{"singleQuote": true}' > .prettierrc.json
fi

yarn prettier --write .
rm javascript_initializer.sh