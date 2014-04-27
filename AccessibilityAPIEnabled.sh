#!/bin/bash

# Enable Assistive Devices by turning on Accessibility API
echo -n 'a' | sudo tee /private/var/db/.AccessibilityAPIEnabled > /dev/null 2>&1; sudo chmod 444 /private/var/db/.AccessibilityAPIEnabled
