#!/bin/bash

# Only run once.
if [ ! -f /var/.parrot-bootstrapped ]; then
  # Run some bootstrapping stuff here.

  wget -O /tmp/puppetlabs-release-precise.deb http://apt.puppetlabs.com/puppetlabs-release-precise.deb
  dpkg -i /tmp/puppetlabs-release-precise.deb
  apt-get update
  apt-get --assume-yes install puppet

  # Ensure that we only run once.
  touch /var/.parrot-bootstrapped
fi
