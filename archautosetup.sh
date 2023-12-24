#!/bin/bash

# Check if script is run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Define a function for the progress bar
progress_bar() {
    local duration=${1}
    already_done() { for ((done=0; done<$elapsed; done++)); do printf "▇"; done }
    remaining() { for ((remain=$elapsed; remain<$duration; remain++)); do printf " "; done }
    percentage() { printf "| %s%%" $(( (($elapsed)*100)/($duration)*100/100 )); }
    clean_line() { printf "\r"; }

    # Progress bar loop
    for (( elapsed=1; elapsed<=$duration; elapsed++ )); do
        already_done; remaining; percentage
        sleep 1
        clean_line
    done

    echo
}

# Update system
echo "Updating system..."
progress_bar 5
sudo pacman -Syu --noconfirm > /dev/null 2>&1

# Install Nvidia drivers
echo "Installing Nvidia drivers..."
progress_bar 5
sudo pacman -S nvidia nvidia-utils --noconfirm > /dev/null 2>&1

# Remove any conflicting drivers
echo "Removing conflicting drivers..."
progress_bar 5
sudo pacman -Rns $(pacman -Qdtq) --noconfirm > /dev/null 2>&1

echo "Installation complete. Please reboot your system."
