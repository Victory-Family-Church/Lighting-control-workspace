# INSTALLING   

There's two components that need to be installed: 
 - Open Lighting Architecture
 - NODE-RED

Open Lighting Architecture is available as a nix flake. It supports a number of DMX interfaces.   
Right now, NODE-RED communicates with OLA to convert MIDI to DMX.  
At this time, Pro-Presenter only supports artnet as an input, but will happily send MIDI notes.

# Enabling IAC (Do before install docs)
For applications to communicate with each other, we'll need to use IAC. 
- open `Audio Midi Setup`
- Hit `Command` + `2`
- Double-click `IAC Driver `
- Enable `Device is Online`

# Install Doc
OLA from homebrew will not work, since it doesn't have FTDI support enabled.  
[Install OLA](./OLA.MD)

NODE-RED is installed from NPM.  
[Install NODE-RED](./NODE-RED.MD)

# Configure Pro-Presenter

Now that we have all of the software installed- propresenter needs to know what to do.  
- Hit `command` + `,` to open settings
- Navigate to the `Devices` settings page (Image Below)  
- Select `Add Device (+)` > MIDI
- Checkmark `Bus 1` (Restart propresenter if it doesn't show up- example below)

![](./IMG/Screenshot%202026-04-09%20at%2012.49.28.png)

![](./IMG/Screenshot%202026-04-09%20at%2012.52.34.png)

# Controlling Lights
Lights can now be controlled via `slides` or `macros`.  
## Slides
If using slides to control lights, there is an [example presentation](/resources/ProPresenter/LIGHT%20CONTROL.pro).  
- Download and import
- Update the slide actions to target the correct midi device
![](./IMG/Screenshot%202026-04-09%20at%2012.59.24.png)