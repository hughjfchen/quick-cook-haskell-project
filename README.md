
# Table of Contents

1.  [Features](#org0ce9921)
2.  [Usage](#orgf31d4f8)
3.  [How does it work](#orgbe73345)
    1.  [Nix provision](#org5a91586)
    2.  [Generate haskell project](#orgb570b52)
    3.  [Generate the build framework based on the `haskell.nix` infrastructure](#orgfd77158)
4.  [Setup development environment](#org15310b0)
5.  [Todos](#org7e9afa5)

This is a tool which can help you generate a haskell project with the haskell.nix as the build framework.


<a id="org0ce9921"></a>

# Features

This tool has following features at this moment:

-   install nix if needed
-   multiple platforms supported(currently `linux` and `macos` are supported, `windows` with `WSL` may work but not tested)
-   generate haskell project with the summoner tool
-   generate most usable nix files, including:
    -   **default.nix:** this is the major nix file which is used by all other nix files.
    -   **shell.nix:** to setup a development environment with nix-shell
    -   **cross-build.nix:** this nix expression can be used to build cross platform targets, including fully static binary linked with musl library
    -   **docker.nix:** this file can be used to build a docker image for the project


<a id="orgf31d4f8"></a>

# Usage

Following these steps to use this tool:

1.  clone the repository.
2.  run the following command under the clone directory:
    
        ./cook.sh <the directory where the project will be put> <the name of the project>
3.  follow the prompt of the screen til everything is done.


<a id="orgbe73345"></a>

# How does it work


<a id="org5a91586"></a>

## Nix provision

This tool will check if `nix` present on the running machine, if not, it will connect to the official `nix` web site and install `nix` first, it also set the default `nix` channel to the latest stable one.


<a id="orgb570b52"></a>

## Generate haskell project

This tool uses the `summoner` to do this job, for more information during the project generation, please refer to the [official site](https://github.com/kowainik/summoner).


<a id="orgfd77158"></a>

## Generate the build framework based on the `haskell.nix` infrastructure

This tool generates the ready to go build framework for the generated project with following facts:

-   It pinned the `haskell.nix` version to the current date with the `niv` tool
-   It uses the `nixpkgs` source from the `haskell.nix` within the `default.nix` file and set the `nixpkgs` version to the latest stable nix channel
-   It sets the `ghc` version to the default one from the latest stable nix channel
-   It sets the `index-state` for the project within the `default.nix` to the current date
-   It generate a `shell.nix` file with following features:
    -   With the `hoogle` tool enabled
    -   With `cabal` and `hlint` enabled and set their versions to the default one of the latest stable `nix` channel
    -   You can optionally enable other tools, like `ghcid`, `niv` or `lorri`, just check the `shell.nix` file
-   It generate the `cross-build.nix` file which will build the fully static binary linked with `musl` library by default. If you would like to cross build for other platforms, check the `nix/cross-build/systems.nix` and comment out for which platforms you want
-   It also generates a `docker.nix` file which can be used to build a docker image
-   It also comes with overlay support. If you want to override some packages within the `hackage` database, you can add a `nix` file for this package under the directory `nix/overlay` and it will be picked up automatically.


<a id="org15310b0"></a>

# Setup development environment

Besides the `shell.nix`, this tool also generates some other files to help you quick start the development:

-   The tool assumes you will use `emacs` with `haskell-mode` and `dante` combination as the development environment. If you use other tools, you need to figure out how to setup the development environment yourself.
-   The tool will generate a `cabal.project` file with the `index-state` set to the current date.
-   The tool will generate a `cabal.project.local` to make sure the `dante` will use the new style cabal commands.
-   The tool will also generate a `.dir-locals.el` and set the `dante` target to the executable of the project name.

With above files in place, you can just run the `nix-shell` under the project directory to enter a `nix-shell` and start `emacs` within the `nix-shell` and start to code.


<a id="org7e9afa5"></a>

# Todos

Following are the incomplete list of the features I want to implement in near future:

-   Add github action CI support based on `haskell.nix`

