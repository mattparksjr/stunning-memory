# Stunning Memory
This repository contains all of the code for each of the games projects. See each section below for more infomation on each, and the role it plays in our game. If you need help on getting the development envirnment setup, see the next section.

## Getting setup
> Before starting, make sure you have your github account added, godot installed, as well as github desktop installed.

Once you have all of the programs installed, simply login to github desktop, and clone this repository. Open godot, and click import on whatever part of the game you need to work on. For example, to work on just the gateway server, you would import the project.godot from `/gatewayserver/project.godot/` and start working. Once you have made a group of changes, swap back to github desktop, enter text to describe the changes, and commit. Once you are done, you can push these changes to the main branch(Although you can use other branches for larger features or game breaking ones)

## Auth Server
The auth server is used to authenticate all of the players once they try to **login** to the game. For more info on how it works check its [in-project docs](https://github.com/mattparksjr/stunning-memory/blob/main/authserver/README.md).

## Game
This project is the game itself, all of the assets and game functionaly is contained within this project. All of its documentation is in the code, or in the docs folder.

## Gateway Server
The gateway server is used to finish the connection between the client and the game server. It will authenticate the client by connecting to the auth server, forward the client its own data, and finally establish the clients connection to the game server. See how it works in [its project docs](https://github.com/mattparksjr/stunning-memory/tree/main/gatewayserver/README.md).

## Game Server
The game server handles, well, the game server stuff. All of the player sync, and sever side stuff for making the game run are done in here. It also [has its own docs](https://github.com/mattparksjr/stunning-memory/tree/main/server/README.md). 

## SSL-Gen
You dont need to open this, if you need it for something, message matt