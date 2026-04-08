# Install Nix

```
$ sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install)
```
# Install Brew, and xcode
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

# Install node.js Packages

```
raydean@rdean-MBA ~ % brew install nodejs node-red 
```

Then have brew start node-red at boot.
```
raydean@rdean-MBA ~ % sudo brew services start node-red
```
Install the additional blocks we need.
```
raydean@rdean-MBA ~ % sudo npm -g i node-red-contrib-midi node-red-contrib-ola
```


# Enable MacOS IAC DRIVER 
Audio Midi Setup -> Command + 2, Open "IAC Driver" -> Check "Device is online".  
Quit audio midi.

# Configure Pro-Presenter Midi output

# Import and validate Pro-Presenter presentation

# Deploy lights flake output. 
This installs ola- including a service that starts at boot
```
nix --extra-experimental-features "flakes nix-command"  build .#darwinConfigurations.lighting.system --no-write-lock-file
```
```
sudo ./result/activate
```