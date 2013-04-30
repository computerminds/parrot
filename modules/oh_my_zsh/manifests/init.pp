class oh_my_zsh {
  # We're just going to install it for the root user at the moment.
  # Should we actually install it for the vagrant user?
  install_for_user { root: }

  define install_for_user($path = '/usr/bin/zsh') {

    if(!defined(Package["git-core"])) {
      package { "git-core":
        ensure => present,
      }
    }
    exec { "chsh -s $path $name":
      path => "/bin:/usr/bin",
      unless => "grep -E '^${name}.+:${$path}$' /etc/passwd",
      require => Package["zsh"]
    }
    
    if(!defined(Package["zsh"])) {
	  package { "zsh":
	    ensure => latest,
	  }
    }

    if(!defined(Package["curl"])) {
      package { "curl":
        ensure => present,
      }
    }

    exec { "copy-zshrc":
      path => "/bin:/usr/bin",
      cwd => "/$name",
      user => $name,
      command => "cp .oh-my-zsh/templates/zshrc.zsh-template .zshrc",
      unless => "ls .zshrc",
      require => Exec["clone_oh_my_zsh"],
    }

    exec { "clone_oh_my_zsh":  
      path => "/bin:/usr/bin",
      cwd => "/$name",
      user => $name,
      command => "git clone https://github.com/robbyrussell/oh-my-zsh.git /$name/.oh-my-zsh",
      creates => "/$name/.oh-my-zsh",
      require => [Package["git-core"], Package["zsh"], Package["curl"]],
    }
  }
}