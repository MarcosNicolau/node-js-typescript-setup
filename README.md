# Typescript Node js setup

This is the usual configuration I always end up doing when creating services with nodejs and typescript.

You can also use it for a package.

## How to run it

First clone the project and then run this command: `yarn setup`. This command will initialize a repository, update all packages to their latest version and prepare husky and commitizen.

## What it will do for you

This configuration will setup:

-   eslint
-   prettier
-   husky, commitizen and .commitlint
-   ts-config paths: added some basic paths in tsconfig.json, make sure you change it to your needs
-   jest configuration
-   [semantic-release](https://semantic-release.gitbook.io/semantic-release/): npm (won't publish), changelog, tag, and git
-   add some basic github workflows to automate semantic releasing

## Use it to publish a package

If you want to use this project to publish a package, change the package.json `private` field to `false`.

If you whish to automate publishing for npm, add NPM_TOKEN var to the project secrets. [click here to read docs](https://github.com/semantic-release/npm)

## Can I contribute?

Yes of course you can, feel free to create any pr.
