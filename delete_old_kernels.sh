#!/bin/bash
#
# delete_old_kernels_keep_multiple_with_purge.sh
#
# Description:
#   This script:
#     1) Identifies the currently running kernel on Ubuntu
#     2) Removes old kernels while keeping the current kernel plus a specified
#        number of the newest kernels
#     3) Runs 'apt-get autoremove -y' for leftover dependencies
#     4) Purges any lingering config files ("rc" packages in dpkg)
#
# Usage:
#   1) chmod +x delete_old_kernels_keep_multiple_with_purge.sh
#   2) sudo ./delete_old_kernels_keep_multiple_with_purge.sh
#
# Notes:
#   - Adjust the KEEP variable below to decide how many of the newest kernels
#     to retain in addition to your current kernel.
#   - Always test on a non-critical system if unsure.
#

# -----------------------
# CONFIGURATION
# -----------------------
# Number of latest kernel versions to keep (excluding the running kernel if it’s older)
KEEP=2

# -----------------------
# MAIN SCRIPT
# -----------------------
echo "[INFO] Detecting your current kernel..."
CURRENT_KERNEL="$(uname -r)"
echo "      Currently running kernel: ${CURRENT_KERNEL}"
echo

# Get all installed linux-image-[0-9]* packages
echo "[INFO] Gathering installed kernel packages..."
ALL_KERNELS=($(dpkg --list 'linux-image-[0-9]*' 2>/dev/null | awk '/^ii/ {print $2}'))

# If there are no installed kernel packages found, exit
if [ ${#ALL_KERNELS[@]} -eq 0 ]; then
  echo "[INFO] No installed linux-image packages found."
  exit 0
fi

# Extract just the kernel version (strip the "linux-image-" prefix)
VERSIONS=()
for KERNEL_PKG in "${ALL_KERNELS[@]}"; do
  VERSION="${KERNEL_PKG#linux-image-}"
  VERSIONS+=("$VERSION")
done

# Sort the versions naturally (-V does version sort)
SORTED_VERSIONS=($(printf '%s\n' "${VERSIONS[@]}" | sort -V))

echo "[INFO] All kernel versions found (oldest -> newest):"
printf '      %s\n' "${SORTED_VERSIONS[@]}"
echo

# Figure out how many total versions we have
NUM_VERSIONS=${#SORTED_VERSIONS[@]}

if (( NUM_VERSIONS <= KEEP )); then
  echo "[INFO] Only $NUM_VERSIONS kernel(s) installed, which is <= KEEP ($KEEP)."
  echo "[INFO] Nothing to remove. Proceeding to cleanup steps."
else
  echo "[INFO] Keeping the newest $KEEP kernel(s) + the running kernel."
  # Keep the last $KEEP versions from the sorted list (the newest ones)
  START_KEEP_INDEX=$(( NUM_VERSIONS - KEEP ))
  KEEP_LIST=("${SORTED_VERSIONS[@]:${START_KEEP_INDEX}}")

  # Ensure the current (running) kernel is also included (in case it's older)
  KEEP_LIST+=("$CURRENT_KERNEL")

  # Remove duplicates, sort again, etc.
  KEEP_LIST_SORTED_UNIQ=($(printf '%s\n' "${KEEP_LIST[@]}" | sort -u))

  echo "[INFO] Final keep list (versions):"
  printf '      %s\n' "${KEEP_LIST_SORTED_UNIQ[@]}"
  echo

  # Remove any kernel packages that are NOT in the keep list
  for KERNEL_PKG in "${ALL_KERNELS[@]}"; do
    VERSION="${KERNEL_PKG#linux-image-}"

    # Check if this VERSION is in the keep list
    if printf '%s\n' "${KEEP_LIST_SORTED_UNIQ[@]}" | grep -qx "$VERSION"; then
      echo "[KEEP]  $KERNEL_PKG"
    else
      echo "[REMOVE] $KERNEL_PKG"
      sudo apt-get purge -y "$KERNEL_PKG"
    fi
  done
fi

echo
echo "[INFO] Running autoremove for any unused dependencies..."
sudo apt-get autoremove -y
echo "[INFO] Autoremove completed."
echo

# -----------------------
# PURGE LEFTOVER CONFIG FILES
# -----------------------
echo "[INFO] Checking for packages in 'rc' (removed/config) state..."
RC_PACKAGES=$(dpkg --list | awk '/^rc/ { print $2 }')

if [ -n "$RC_PACKAGES" ]; then
  echo "[INFO] Purging leftover config files for these packages:"
  echo "      $RC_PACKAGES"
  sudo dpkg -P $RC_PACKAGES
else
  echo "[INFO] No leftover 'rc' packages found."
fi

echo
echo "[INFO] Final check of installed kernel packages:"
dpkg --list | grep linux-image

echo
echo "[INFO] Script complete. Current kernel remains: ${CURRENT_KERNEL}"
