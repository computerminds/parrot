#!/bin/bash -xe

# Destroy any previous VMs
vagrant destroy -f || true

cp -f testing/jenkins.config.yml config.yml
echo "box_name: Parrot-build-${BUILD_NUMBER}" >> config.yml

# Run a simple vagrant up.
vagrant up

# Now do some testing
curl http://localhost:8181/qwertyuiop.php

# Make sure we can execute Drush.
vagrant ssh -c 'drush --version'
