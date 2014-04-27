#!/bin/bash

# Add everyone to the lpadmin group so they can add printers. Only best for laptop users wishing to add home printers.

sudo dseditgroup -o edit -n /Local/Default -a everyone -t group lpadmin
