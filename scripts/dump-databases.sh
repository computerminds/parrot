#!/bin/sh

# Change to the directory that this script is stored in.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $DIR

# Ensure that the VM is up.
vagrant up

# And run the script in the VM.
vagrant ssh --command '/var/parrot-dump-databases.sh'
