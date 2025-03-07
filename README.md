# UbuntuKernelPurge
Purge Old Ubuntu Kernels

# delete_old_kernels.sh

A Bash script that removes older Ubuntu kernels while keeping your current kernel and a specified number of the newest kernels. It also runs `autoremove` to clean up residual dependencies and purges leftover configuration files (those in `rc` state).

---

## Table of Contents

1. [Overview](#overview)  
2. [Features](#features)  
3. [Requirements](#requirements)  
4. [Installation](#installation)  
5. [Usage](#usage)  
6. [Configuration](#configuration)  
7. [Contributing](#contributing)  
8. [License](#license)  

---

## Overview

This script:

1. Detects your **current** kernel version.  
2. Removes older kernels, while keeping a set number of the most recent ones.  
3. Ensures the currently running kernel is never removed.  
4. Runs `sudo apt-get autoremove -y` to clear out any orphaned dependencies.  
5. Purges leftover config files (packages in `rc` state).

It helps keep your Ubuntu system clean, freeing up disk space consumed by old kernels.

---

## Features

- **Safe Cleanup**: Always keeps your current kernel.  
- **Configurable**: Choose how many of the newest kernels to keep (`KEEP` variable).  
- **Automatically Removes Residuals**: Runs `autoremove`, then purges config files so they no longer show up in `dpkg --list`.  
- **Simple & Self-Contained**: Single Bash script, easy to customize or run on multiple systems.

---

## Requirements

- An Ubuntu (or similar Debian-based) system.  
- `bash` shell (usually installed by default).  
- Sudo privileges (to remove packages).  
- `apt` (Advanced Package Tool).

---

## Installation

1. Download the script (e.g., `delete_old_kernels.sh`) to your local system.  
2. Make the script executable:  
   ```bash
   chmod +x delete_old_kernels.sh.sh

## Usage

1. **Run the script** with `sudo`:
   ```bash
   sudo ./delete_old_kernels.sh

2. **Follow any on-screen messages**. The script will:
Identify kernels to keep vs. remove.
Remove old kernels (`apt-get purge`).
`apt-get autoremove` leftover dependencies.
Purge config files for removed kernels.

**Tip: Always confirm the current kernel is correct before removing old kernels.**

## Configuration

Inside the script, there’s a variable called `KEEP`. By default, it’s set to `2`. This means:

- The script keeps the **newest 2 kernels plus the currently running kernel.**
- If you want to keep more (or fewer), open the script and modify:
   ```bash
   KEEP=2

Change this to 3, 4, or however many you’d like.

## Contributing

1. Fork the repository.
2. Create a feature branch:
   ```bash
   git checkout -b feature/my-new-feature
3. Commit your changes:
   ```bash
   git commit -m 'Add some feature'
4. Push to the branch:
   ```bash
   git push origin feature/my-new-feature
5. Create a new Pull Request, describing your changes.

## License
This script is available under the MIT License. You are free to use, modify, and distribute it, subject to the terms of the license.


