Parrot development VM
=====================

Parrot is a utility VM for Drupal development. It's not your development environment,
but it's the complex, hard to set up, servers you'll need.


Name
----

Simple and repeatable, that is what the Parrot VM is all about.


Requirements
------------

* [Vagrant](http://www.vagrantup.com/) and [Virtualbox](https://www.virtualbox.org/)
* Unix based host system
* [Lots of free RAM](http://lmgtfy.com/?q=computer+memory+upgrade)


Installation
------------

You will need to clone this repo to your host machine, and then `cd` into the directory and run:

    vagrant up

That's it!


Usage
-----

For detailed instructions on how to use all the features provided by Parrot, see the wiki.


Features
--------

* [A Solr 4 server running customisable configs.](https://github.com/computerminds/parrot/wiki/Solr-4-server)
* [A MySQL server](https://github.com/computerminds/parrot/wiki/Mysql-server)
* [SSH agent forwarding](https://github.com/computerminds/parrot/wiki/SSH-agent-forwarding)
