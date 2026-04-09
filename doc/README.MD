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