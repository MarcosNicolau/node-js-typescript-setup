echo "==========RUNNING SETUP=========="
echo -n "package name: (`basename $PWD`) "
read PACKAGE_NAME
echo -n "description: "
read DESCRIPTION
echo -n "author: "
read AUTHOR
echo -n "license: (ISC)"
read LICENSE


# Default variables
if [ -z $PACKAGE_NAME ]; then PACKAGE_NAME=`basename $PWD`
fi

if [ -z $LICENSE ]; then LICENSE="ISC"
fi


sed -i "s|NAME|$PACKAGE_NAME|" package.json
sed -i "s|AUTHOR|$AUTHOR|" package.json
sed -i "s|DESCRIPTION|$DESCRIPTION|" package.json
sed -i "s|LICENSE|$LICENSE|" package.json

rm -rf .git
git init
npx npm-check-updates -u
yarn
husky install
chmod u+x ./.husky/*
commitizen init cz-conventional-changelog --force --yarn --dev --exact
