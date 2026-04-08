# Install Nix

# Enable MacOS IAC DRIVER 

# Configure Pro-Presenter Midi output

# Import and validate Pro-Presenter presentation

# Deploy lights flake output. 

 # Adding Node‑RED Plugins (Contrib Nodes)

Node‑RED plugins (also called “contrib nodes”) are installed into the
Node‑RED **user directory**, not into the system.

On Victory Family Church lighting systems, the user directory is:

  /var/lib/node-red

---

## ✅ Installing a Plugin

1. Open a terminal
2. Run:

   sudo -u nodered npm --prefix /var/lib/node-red install <plugin-name>

### Examples

Install MIDI support:

```
sudo -u nodered npm --prefix /var/lib/node-red install node-red-contrib-midi
sudo -u nodered npm --prefix /var/lib/node-red install node-red-contrib-ola
```
sudo launchctl kickstart -k system/org.vfc.node-red