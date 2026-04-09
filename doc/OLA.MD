# Installing OLA  

OLA is installed using a `nix flake`. This allows us to define inputs, and have reproducable outputs.  
OLA is included upstream, so we end up overlaying some additional build options on top of the upstream package.  
Side note, this will also install node@25 and NPM, which are needed for node-red.

## Overview   
 - Install the Nix Package Manager
 - Pull the configuration repo   
 - Deploy the system configuration with OLA included.

### Install [Nix](https://nixos.org/download/)  
```
 sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```
You'll likely have to open a new terminal window to use the nix command. 

### Clone the configuration repo   
Enter a nix shell with git installed: 
```
nix-shell -p git
```
  
Once this finishes, go ahead and clone the configuration repo: 
```
git clone https://github.com/Victory-Family-Church/Nixos-Config && cd Nixos-Config
```
Build the system configuration. (This is only needed when activating for the first time.) 
```
nix --extra-experimental-features "flakes nix-command" build .#darwinConfigurations.lighting.system
```
Once this finishes building, activate the new configuration.   

```
sudo ./result/activate
```

## Running at user login   
Because of the weirdness of launchd, I could not get it to reliable launch.  
Instead of using launchd, download [start-ola.sh](/resources/start-ola.sh) from this repo, and add it to `login items`

## Configure OLAD
### configure modules
Edit these files with the following changes:  

/$HOME/.ola/ola-ftdidmx.conf
```
enable = true
```  
---
/$HOME/.ola/ola-usbserial.conf
```
enable = false
```
---
/$HOME/.ola/ola-opendmx.conf  
```
enable = false
```
--- 

### Create a universe
Go to http://localhost:9090/ola.html  
Select `Reload Plugins`  
Select `Add Universe`  
Universe ID is 0  
Universe Name is 0  
Select the correct DMX output device  
Select `Add Universe`
