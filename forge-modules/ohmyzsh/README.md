# acme-ohmyzsh Puppet Module

This is the [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) module. It installs oh-my-zsh for a user and changes their shell to zsh. It also can configure themes and plugins for users.

oh-my-zsh is a community-driven framework for managing your zsh configuration. See [https://github.com/robbyrussell/oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) for more details.

This module is called ohmyzsh as Puppet does not support hyphens in module names.

## Installation

### From Puppet Forge

```bash
  $ puppet module install acme/ohmyzsh
```

### From source

```bash
  $ cd PUPPET_MODULEDIR
  $ git clone https://github.com/acme/puppet-acme-oh-my-zsh ohmyzsh
```

## Usage

```
class { 'ohmyzsh': }

# for a single user
ohmyzsh::install { 'acme': }

# for multiple users in one shot
ohmyzsh::install { ['root', 'acme']: }

# set a theme for a user
ohmyzsh::theme { ['root', 'acme']: } # would install 'clean' theme as default

ohmyzsh::theme { ['root', 'acme']: theme => 'robbyrussell' } # specific theme

# activate plugins for a user
ohmyzsh::plugins { 'acme': plugins => 'git github' }

# upgrade oh-my-zsh for a single user
ohmyzsh::upgrade { 'acme': }
```

License
-------

Apache License, Version 2.0.


Contact
-------

Leon Brocard acme@astray.com


Support
-------

Please log tickets and issues at [GitHub](https://github.com/acme/puppet-acme-oh-my-zsh)
