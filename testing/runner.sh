#!/bin/bash -xe

# Destroy any previous VMs
vagrant destroy -f || true

cp -f testing/jenkins.config.yml config.yml
echo "box_name: Parrot-build-${BUILD_NUMBER}" >> config.yml

# Run a simple vagrant up.
vagrant up
vagrant provision
vagrant reload

# Now do some base testing
curl http://localhost:8181/qwertyuiop.php
curl -f http://localhost:8181/qwertyuiop.php

# Make sure we can execute Drush.
vagrant ssh -c 'drush --version'

# Test PHP 5.6.
#echo "php_version: 5.6" >> config.yml
#vagrant provision

# Now do some version testing
#curl http://localhost:8181/is_php_56.php
#curl -f http://localhost:8181/is_php_56.php
