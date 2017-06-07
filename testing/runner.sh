#!/bin/bash -xe

# Destroy any previous VMs
vagrant destroy -f || true

cp -f testing/jenkins.config.yml config.yml
echo "box_name: Parrot-build-${BUILD_TAG}" >> config.yml

# Run a simple vagrant up.
vagrant up
vagrant reload

rm -f testing/sites/localhost/.parrot-php7
rm -f testing/sites/localhost/.parrot-php7.0
rm -f testing/sites/localhost/.parrot-php7.1

# Now do some base testing
curl http://localhost:8181/qwertyuiop.php
curl -f http://localhost:8181/qwertyuiop.php

# Now do some version testing
curl http://localhost:8181/is_php_56.php
curl -f http://localhost:8181/is_php_56.php

# Make sure we can execute Drush.
vagrant ssh -c 'drush --version'

# Test PHP 7.0.
touch testing/sites/localhost/.parrot-php7.0
vagrant provision

# Now do some base testing
curl http://localhost:8181/qwertyuiop.php
curl -f http://localhost:8181/qwertyuiop.php

# Now do some version testing
curl http://localhost:8181/is_php_70.php
curl -f http://localhost:8181/is_php_70.php

rm testing/sites/localhost/.parrot-php7.0

# Test PHP 7.1.
touch testing/sites/localhost/.parrot-php7.1
vagrant provision

# Now do some base testing
curl http://localhost:8181/qwertyuiop.php
curl -f http://localhost:8181/qwertyuiop.php

# Now do some version testing
curl http://localhost:8181/is_php_71.php
curl -f http://localhost:8181/is_php_71.php

rm testing/sites/localhost/.parrot-php7.1
