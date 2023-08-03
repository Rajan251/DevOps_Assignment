#!/bin/bash

# Function to check Linux OS and distribution
function check_linux_distribution() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        echo "Linux distribution: $NAME"
    else
        echo "Linux distribution not found."
        exit 1
    fi
}

# Function to check if 'httpd' is installed
function check_httpd_installed() {
    if command -v httpd &>/dev/null; then
        echo "httpd is already installed."
    else
        echo "httpd is not installed. Installing httpd..."
        sudo yum install -y httpd
    fi
}

# Function to check the status of 'httpd' and start if not running
function check_httpd_status() {
    httpd_status=$(systemctl is-active httpd)
    if [ "$httpd_status" == "active" ]; then
        echo "httpd is running."
    else
        echo "httpd is not running. Starting httpd..."
        sudo systemctl start httpd
    fi
}

# Main script
check_linux_distribution
check_httpd_installed
check_httpd_status

