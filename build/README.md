# Builder for Project DarkStar

More information on DarkStar: 
* https://github.com/DarkstarProject/darkstar
* https://wiki.dspt.info/index.php/Building_the_Server

## Function

This is a build system will build the DarkStar project in a stable and repeatable way. This is especially useful for an automated build process or
if you do not want to figure out how to configure the DarkStar build environment *but* have access to Docker.

## Procedure

* Checks out DarkStar from github (origin/stable) if not available
* Configures and builds DarkStar
* Copies binaries to individual container directories
* Builds containers that have DarkStar binaries

## Building

To use build DarkStar you will only need the path to the where the DarkStar project is cloned with git

The command will look like:

```
./darkstar-builder build /path/to/darkstar/git/clone
```
