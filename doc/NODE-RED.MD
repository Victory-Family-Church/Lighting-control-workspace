# Installing NODE-RED  

NODE-RED is managed via NPM. 
NPM is installed with homebrew

## Overview   
 - Install Homebrew
 - Install node
 - Install node-red
 - Install Modules
 - Deploy the NODE-RED flow.

### Install [Homebrew](https://brew.sh)
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
**READ** what homebrew tells you at the end. You'll need to add some stuff to path. 

### Install node@25
```
brew install node@25
```
### Install NODE-RED
```
sudo npm -g i node-red
```

## Running at user login   
Because of the weirdness of launchd, I could not get it to launch.  
Instead of using launchd, download [start-nodeRed.sh](/resources/start-nodeRed.sh) from this repo, and add it to `login items`

After doing this, log out and log back in to this user's graphical session. It should start these services. 
## Install Modules
[Open NODE-RED](http://127.0.0.1:1880/)   
At first launch you should see something like this. 
![Getting Started](./IMG/Screenshot%202026-04-09%20at%2012.16.34.png)  
  
Open `Manage Palette`

![Manage Palette](./IMG/Screenshot%202026-04-09%20at%2012.19.01.png)  
  
Select the `Install` tab  
  
![Install](./IMG/Screenshot%202026-04-09%20at%2012.20.32.png)  

We're going to install two plugins: 
- `node-red-contrib-midi`
- `node-red-contrib-ola`  
  
When done, it should look kinda like this: 

![approximately](./IMG/Screenshot%202026-04-09%20at%2012.22.52.png)

## Deploy the node-red flow  
- Hit `command` + `i`
- Copy [this flow](/resources/node-red/flows.json), and paste it.
- Hit `Import`
- Double-click the `Midi In` Block, and make sure the selected port is `IAC Driver Bus 1`
- At the top right, hit `Deploy`