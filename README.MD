**THIS IS A PLACEHOLDER< AI GEN>
**`Victory-Family-Church/Lighting-control-workspace`**, aligned with the Node‑RED + OLA + nix‑darwin work you’ve been doing.

You can copy‑paste this directly into `README.md` and tweak naming/details later.

***

# Lighting Control Workspace

This repository contains the **Nix‑based lighting control stack** used by Victory Family Church.  
It is designed to provide a **reproducible, declarative environment** for lighting control using:

*   **Node‑RED** – flow-based automation and control
*   **OLA (Open Lighting Architecture)** – DMX / Art‑Net / sACN
*   **nix / flakes** – reproducible development and deployment
*   **nix‑darwin + launchd** – macOS-based lighting controllers

This workspace supports both **interactive development** (`nix develop`) and **production deployment** via `launchd`.

***

## Repository Goals

*   ✅ Declarative, reproducible lighting control
*   ✅ No mutable npm or system state
*   ✅ Works on macOS (Intel & Apple Silicon)
*   ✅ Easy to deploy, easy to recover
*   ✅ Designed for church production environments

***

## What’s Included

Depending on the checked-in flakes/modules, this workspace provides:

*   Node‑RED with lighting-focused contrib nodes:
    *   MIDI input/output
    *   OLA / DMX integration
*   launchd services for headless operation
*   Development shells for testing flows locally
*   Infrastructure shared across lighting controllers

***

## Requirements

*   macOS
*   `nix` with flakes enabled
*   `nix-darwin`

If you don’t already have nix‑darwin installed, see:  
<https://github.com/lnl7/nix-darwin>

***

## Development (Local Testing)

To enter a development shell:

```bash
nix develop
```

This will provide:

*   Node.js
*   Node‑RED
*   Required contrib nodes
*   OLA utilities

A local Node‑RED user directory will be created for testing.

Start Node‑RED manually:

```bash
node \
  $(npm root -g 2>/dev/null || true)/node-red/red.js \
  --userDir ./node-red-data
```

Then open:

    http://localhost:1880

Use this mode for:

*   Building and testing flows
*   Verifying MIDI / DMX behavior
*   Debugging node configuration

***

## Deployment (Production)

This workspace is intended to be deployed using **nix‑darwin**.

At a high level:

1.  Import the relevant lighting / Node‑RED module into your `darwinConfiguration`
2.  Enable the service
3.  Rebuild the system

Example (simplified):

```nix
services.nodeRedMidiOla = {
  enable = true;
  port = 1880;
};
```

After applying:

```bash
darwin-rebuild switch
```

Node‑RED will run as a **launchd service**, start on boot, and persist flows safely.

***

## MIDI & DMX Notes

*   **MIDI**  
    macOS uses CoreMIDI directly; no kernel modules are required.
    Devices and virtual ports can be managed via **Audio MIDI Setup**.

*   **DMX / Art‑Net**  
    OLA is used as the DMX backend.
    This integrates cleanly with USB‑DMX adapters, Art‑Net, and sACN.

***

## Design Philosophy

*   Immutable infrastructure
*   Clear separation between:
    *   *System configuration*
    *   *User data (flows)*
*   Fast recovery:
    *   Rebuild the system
    *   Restore flows
    *   Resume service

This approach minimizes downtime during services and rehearsals.

***

## Related Repositories

*   <https://github.com/Victory-Family-Church/darwin-ola-ftdi>  
    USB‑DMX / FTDI support for macOS via nix‑darwin

***

## Contributing

*   Keep changes declarative
*   Avoid introducing mutable runtime state
*   Favor Nix options over shell scripts
*   Test changes with `nix develop` before deployment

***

## License

Internal use by Victory Family Church unless otherwise noted.

***

If you want, I can:

*   Tighten this up for **public vs internal** visibility
*   Add a **diagram** of MIDI → Node‑RED → OLA → Lights
*   Add a **“Sunday morning checklist”** section
*   Align wording exactly with other VFC repos

Just tell me how you want it presented.
