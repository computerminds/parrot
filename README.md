Parrot development VM
=====================

[![Build Status](https://jenkins.computerminds.co.uk/buildStatus/icon?job=Parrot%20master%20branch%20Testing)](https://jenkins.computerminds.co.uk/job/Parrot%20master%20branch%20Testing)

Parrot is a utility VM for Drupal development. It's not your development environment,
but it's the complex, hard to set up, servers you'll need.


Name
----

Simple and repeatable, that is what the Parrot VM is all about.


Requirements
------------

* [Vagrant](http://www.vagrantup.com/) (version 1.3.0 or higher)
* [Virtualbox](https://www.virtualbox.org/) or [VMWare Fusion](http://www.vmware.com/uk/products/fusion)  or [Parallels](http://www.parallels.com)
* Unix based host system (Windows hosts may work nicely with https://github.com/winnfsd/vagrant-winnfsd)
* [Lots of free RAM](http://lmgtfy.com/?q=computer+memory+upgrade)
* [Vagrant cachier plugin](https://github.com/fgrehm/vagrant-cachier#installation) (optional)


Installation
------------

You will need to clone this repo to your host machine, and then `cd` into the directory and run:

    vagrant up

That's it!

If you want to use your [VMWare Fusion Vagrant provider](http://www.vagrantup.com/vmware), then run:

    vagrant up --provider=vmware_fusion
    
If you want to use your [Parallels Vagrant provider](http://parallels.github.io/vagrant-parallels/), then run:

    vagrant up --provider=parallels


Usage
-----

For detailed instructions on how to use all the features provided by Parrot, see the wiki.


Config
------
You can configure the VM that Parrot provisions read the [configuration page](https://github.com/computerminds/parrot/wiki/Configuration) in the wiki for more details.


Features
--------

* [A Solr 4 server running customisable configs.](https://github.com/computerminds/parrot/wiki/Solr-4-server)
* [A MySQL server](https://github.com/computerminds/parrot/wiki/Mysql-server)
* [SSH agent forwarding](https://github.com/computerminds/parrot/wiki/SSH-agent-forwarding)
* [HTTP Stack](https://github.com/computerminds/parrot/wiki/HTTP-stack)
  * [Varnish 3](https://github.com/computerminds/parrot/wiki/Varnish-3)
  * [Apache 2](https://github.com/computerminds/parrot/wiki/Apache-2)
* [PHP](https://github.com/computerminds/parrot/wiki/PHP) 5.6 and 7.0 using PHP-FPM for extra cool points.
* [XDebug](https://github.com/computerminds/parrot/wiki/PHP-XDebug)
