#!/bin/bash

# Only run once.
if [ ! -f /var/.parrot-bootstrapped ]; then
  # Run some bootstrapping stuff here.

  # Update Puppet to latest version (needed for npm package provider)
  wget -O /tmp/puppetlabs-release-precise.deb http://apt.puppetlabs.com/puppetlabs-release-precise.deb
  dpkg -i /tmp/puppetlabs-release-precise.deb
  apt-get update
  apt-get --assume-yes install puppet
  
  # Remove deprecated Puppet config
  sed -i '/templatedir/d' /etc/puppet/puppet.conf

  # Ensure that we only run once.
  touch /var/.parrot-bootstrapped
fi
