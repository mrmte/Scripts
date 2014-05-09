#!/bin/bash

# Check to see if FireWire network service is enabled. If it is then disable it.
if networksetup -getnetworkserviceenabled "FireWire" | grep "Enabled" ;then
networksetup -setnetworkserviceenabled "FireWire" off
fi

# Check to see if Bluetooth PAN network service is enabled. If it is then disable it.
if networksetup -getnetworkserviceenabled "Bluetooth PAN" | grep "Enabled" ;then
networksetup -setnetworkserviceenabled "Bluetooth PAN" off
fi

