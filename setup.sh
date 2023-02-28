echo "==========RUNNING SETUP=========="
echo -n "package name: (`basename $PWD`) "
read PACKAGE_NAME
echo -n "description: "
read DESCRIPTION
echo -n "author: "
read AUTHOR
echo -n "license: (ISC)"
read LICENSE

echo -n "Do you want to setup a basic Docker setup(create dockerfile, add docker publish in release workflow)[Y/n]?"
read DOCKER_SETUP


# Default variables
if [ -z $PACKAGE_NAME ]; then PACKAGE_NAME=`basename $PWD`
fi

if [ -z $LICENSE ]; then LICENSE="ISC"
fi

# Change package fields
sed -i "s|NAME|$PACKAGE_NAME|" package.json
sed -i "s|AUTHOR|$AUTHOR|" package.json
sed -i "s|DESCRIPTION|$DESCRIPTION|" package.json
sed -i "s|LICENSE|$LICENSE|" package.json

# Run docker setup if set to yes
if [ $DOCKER_SETUP = "y" ] || [ $DOCKER_SETUP = "Y" ] || [ $DOCKER_SETUP = "yes" ];
then 
echo SETTING UP DOCKER... 
#Create dockerfile
echo "
# stage 1 building the code
FROM node:19-alpine3.16 AS builder

# Create app directory
WORKDIR /app

# A wildcard is used to ensure both package.json AND package-lock.json are copied
COPY ./package*.json ./
COPY ./yarn.lock ./

# Install app dependencies
RUN npm install

# Copy used packages
COPY ./ ./

# Build packages
RUN npm run build

# Remove devDepedencies
RUN npm prune --production

# stage 2
FROM node:19-alpine3.16 AS bundler

USER node

WORKDIR /home/node/app

# Copy the complide ts code
COPY --from=builder --chown=node:node /app/dist ./dist
COPY --from=builder --chown=node:node /app/node_modules ./node_modules

# We need the src folder for ts-node-paths module
COPY --from=builder --chown=node:node /app/src ./src 
COPY --from=builder --chown=node:node /app/tsconfig.json ./tsconfig.json 
COPY --from=builder --chown=node:node /app/package.json ./package.json 

# Bundle app source
ARG PORT=8000
ENV PORT=\${PORT}

EXPOSE \${PORT} 
CMD npm start" > ./Dockerfile


# Setup scripts
yarn add cross-env -D
sed -i "/scripts/a \"docker:build\": \"docker build -t $PACKAGE_NAME ./\", \
                \"docker:tag\": \"docker tag $PACKAGE_NAME ghcr.io/$PACKAGE_NAME:\$LATEST_TAG && docker tag $PACKAGE_NAME ghcr.io/$PACKAGE_NAME:latest\", \
                \"docker:push\": \"docker push ghcr.io/$PACKAGE_NAME:\$LATEST_TAG && docker push ghcr.io/$PACKAGE_NAME:latest\", \
                \"docker\": \"cross-env-shell LATEST_TAG=\$(git describe --abbrev=0 --tags) 'npm run docker:build && npm run docker:tag && npm run docker:push' \"," package.json

# Update release workflow
echo '      - name: "GitHub container registry login" 
        uses: docker/login-action@v2  
        with:  
          registry: ghcr.io  
          username: ${{ github.actor }}  
          password: ${{ secrets.GITHUB_TOKEN }}  
      - name: "Docker Publish"  
        run: "npm run docker"' >> ./.github/workflows/release.yml
echo DOCKER SETUP READY
else 
echo SKIPPING DOCKER SETUP
fi
 
# Initialize a new repository
rm -rf .git
git init
# Check dependencies version 
npx npm-check-updates -u
# Install dependencies
yarn
husky install
# Allow husky to run scripts
chmod u+x ./.husky/*
# Initialize commitizen
commitizen init cz-conventional-changelog --force --yarn --dev --exact

# Format generated code
npx prettier -w ./package.json
