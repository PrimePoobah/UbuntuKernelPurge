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
7. [Example Output](#example-output)  
8. [Contributing](#contributing)  
9. [License](#license)  

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
   chmod +x delete_old_kernels_keep_multiple_with_purge.sh
