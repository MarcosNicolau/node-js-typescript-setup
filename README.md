# Typescript Node js setup

This is the usual configuration I always end up doing when creating services with nodejs and typescript.

You can also use it for a package.

## How to run it

1. Clone the project: <br />
   `git clone https://github.com/MarcosNicolau/node-js-typescript-setup ./<YOUR_DIRECTORY>`

2. Give permission to the setup script: <br />
   `sudo chmod +x ./setup.sh`

3. Run setup: <br />
   `yarn setup`

## What it will do for you

This configuration will setup:

-   eslint
-   prettier
-   husky, commitizen and .commitlint
-   ts-config paths: added some basic paths in tsconfig.json, make sure you change it to your needs
-   jest configuration
-   [semantic-release](https://semantic-release.gitbook.io/semantic-release/): npm (won't publish), changelog, tag, and git
-   add some basic github workflows to automate semantic releasing

## About setup script

When running `yarn setup` you will be prompt to enter the basic package info and whether you would like to setup docker.

### What does the docker setup do?

1. Creates a Dockerfile
2. Creates package scripts to manage docker actions
3. Updates release workflow to include docker publish. Pushes the container to the GitHub container registry

## Use it to publish a package

If you want to use this project to publish a package, change the package.json `private` field to `false`.

If you whish to automate publishing for npm, add NPM_TOKEN var to the project secrets. [click here to read docs](https://github.com/semantic-release/npm)

## A Comment about commitizen

Commitizen is a cli tool that is a must have to me because it enforces a clear and solid patterns of commits following the commonly used angular guideline.

Whenever you commit your code, run `yarn cm` and follow the tool steps.

For more information access their repo [here](https://hola.com)

## Can I contribute?

Yes of course you can, feel free to create any pr.
