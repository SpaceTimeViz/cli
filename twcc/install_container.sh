#!/bin/bash
#
# Install essentials with the base image: `pytorch-23.11-py3`
#
# Essentials: Miniconda, AWS CLI
#

install_miniconda() {
    # Define the Miniconda installation URL
    local MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    local MINICONDA_INSTALLER="Miniconda3-latest-Linux-x86_64.sh"

    # Update package lists
    sudo apt-get update > /dev/null 2>&1 || true

    # Download Miniconda installer
    curl -SL $MINICONDA_URL -o $MINICONDA_INSTALLER || { echo "Error: Failed to download Miniconda installer."; return 1; }

    # Run the Miniconda installer
    bash $MINICONDA_INSTALLER -b -p $HOME/miniconda || { echo "Error: Failed to install Miniconda."; return 1; }

    # Remove the installer
    rm $MINICONDA_INSTALLER

    # Initialize Miniconda
    eval "$($HOME/miniconda/bin/conda shell.bash hook)" || { echo "Error: Failed to initialize Miniconda."; return 1; }

    # Add Miniconda to the PATH in the current shell session
    export PATH="$HOME/miniconda/bin:$PATH"

    echo "Miniconda installation completed successfully."
}

install_aws_cli() {
    # Update package lists and install AWS CLI
    sudo apt-get update > /dev/null 2>&1 || true
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y awscli || { echo "Error: Failed to install AWS CLI."; return 1; }
    echo "AWS CLI installation completed successfully."
}

main() {
    echo "Installing Miniconda..."
    install_miniconda || { echo "Error: Failed to install Miniconda"; exit 1; }

    echo "Installing AWS CLI..."
    install_aws_cli || { echo "Error: Failed to install AWS CLI"; exit 1; }
}

main
