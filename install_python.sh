#!/bin/bash

# Update the package list and upgrade any existing packages
sudo apt update
sudo apt upgrade

# Install Python and pip
sudo apt install python3 python3-pip

# Verify that Python and pip have been installed correctly
python3 --version
pip3 --version
