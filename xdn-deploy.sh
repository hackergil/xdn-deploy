#!/usr/bin/env bash

ENDPOINT='gilberto-alvarado-spartacus-default.moovweb-edge.io'
APP='spartacus'
ANGULAR_CLI_VERSION='~10.1.0'

function deploy_spa {
    npm i -g @angular/cli@${ANGULAR_CLI_VERSION}

    echo "-----"
    echo "Installing xdn cli"
    npm i -g @xdn/cli@latest

    echo "-----"
    echo "Creating new Spartacus shell app"

    ng new ${APP} --style=scss --routing=false
    cd ${APP}
    ng add @spartacus/schematics --ssr --pwa

    echo "-----"
    echo "Initializing XDN and adding configuration"
    xdn init

    cd ..

    # add CX endpoint to xdn.config.js
    cp xdn.config.js ${APP}/

    # add xdn endpoint to app.module.ts and index.html
    sed s/localhost\:9002/${ENDPOINT}/ ${APP}/src/app/app.module.ts > app.module.ts
    cp app.module.ts ${APP}/src/app/app.module.ts

    sed s/localhost\:9002/${ENDPOINT}/ ${APP}/src/index.html > index.html
    cp index.html ${APP}/src/index.html

    cp routes.ts ${APP}/

    echo "-----"
    echo "Starting XDN deployment"

    cd ${APP}
    xdn deploy --environment staging --branch --token=$XDN_DEPLOY_TOKEN
}

deploy_spa
