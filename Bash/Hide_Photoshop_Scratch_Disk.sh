#!/bin/bash

# Hide the Photoshop Scratch Volume
chflags hidden /Volumes/SCRATCHDISK

# Hide Users Directory
chflags hidden V /Users

# Making sure users have read and write permissions to the Photoshop Scratch Volume
diskutil disableOwnership /Volumes/SCRATCHDISK



