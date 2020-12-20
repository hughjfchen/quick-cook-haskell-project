+++
title = "Readme"
author = ["Hugh JF Chen"]
date = 2020-12-18
draft = false
+++

<div class="ox-hugo-toc toc">
<div></div>

<div class="heading">Table of Contents</div>

- [Features](#features)
- [Usage](#usage)

</div>
<!--endtoc-->

This is a tool which can help you generate a haskell project which uses the haskell.nix as the build framework.


## Features {#features}

This tool has following features at this moment:

-   provision nix if needed
-   generate haskell project with the summoner tool
-   generate most usable nix files, including:
    -   **default.nix:** this is the major nix file
    -   **shell.nix:** to setup a development environment with nix-shell
    -   **cross-build.nix:** this nix expression can be used to build cross platform targets, including fully static linked binary with musl library
    -   **docker.nix:** this file can be used to build a docker image for the project


## Usage {#usage}

Following these steps to use this tool:

1.  clone the repository.
2.  run the following command under the clone directory:

    ```sh
    /cook.sh <the directory where the project will be put> <the name of the project>
    ```
3.  follow the prompt of the screen til everything is done.
