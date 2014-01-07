#!/bin/bash

# Only run once.
if [ ! -f /var/.parrot-bootstrapped ]; then
  # Run some bootstrapping stuff here.

  # Need to update the apt cache.
  apt-get update

  # Need to make sure we have the latest version of puppet.
  DEBIAN_FRONTEND=noninteractive apt-get -q -y install puppet

  # Ensure that we only run once.
  touch /var/.parrot-bootstrapped
fi
