#! /bin/bash

# check project name
if [[ $# -eq 0 ]] ; then
    echo 'Sorry, you must specify a project name'
    exit 1
fi

# create react app
npx create-react-app $1
cd $1

# add prettier and eslint-config-prettier as dev dependencies
yarn add --dev prettier eslint-config-prettier

# initialize prettier config file
cat <<EOF > .prettierrc
{
  "singleQuote": true
}
EOF

# add prettier to eslintConfig
node > out_package.json <<EOF
const data = require('./package.json');
data.eslintConfig.extends.push('prettier')
console.log(JSON.stringify(data));
EOF

# add lint-staged precommit hook
npx mrm@2 lint-staged

# customize lint-staged config
node > out_package.json <<EOF
const data = require('./package.json');
data['lint-staged'] = {
  "src/**/*.{js,jsx}": ["eslint --cache --fix", "prettier --write"],
  "src/**/*.{css,scss,json}": "prettier --write"
}
console.log(JSON.stringify(data));
EOF
mv out_package.json package.json

# reformat all
yarn run prettier --write .