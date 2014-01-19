class mailcollect {
    $packages = [ "postfix", "postfix-pcre", "dovecot-imapd" ]

    package { $packages :
        ensure => present,
    }

    service { "postfix" :
        ensure => running,
        require => Package[$packages],
    }

    service { "dovecot" :
        ensure => running,
        require => Package[$packages],
    }

    file { "/etc/dovecot/conf.d/10-mail.conf":
        source => 'puppet:///modules/mailcollect/10-mail.conf',
        require => Package[$packages],
        notify => Service['dovecot'],
        owner => 'root',
        group => 'root',
    }

    file { "/etc/dovecot/conf.d/10-auth.conf":
        source => 'puppet:///modules/mailcollect/10-auth.conf',
        require => Package[$packages],
        notify => Service['dovecot'],
        owner => 'root',
        group => 'root',
    }

    augeas { "postfix" :
        context => "/files/etc/postfix/main.cf",
        changes => [
            'clear virtual_alias_domains',
            'set virtual_alias_maps pcre:/etc/postfix/virtual_forwardings.pcre',
            'set virtual_mailbox_domains pcre:/etc/postfix/virtual_domains.pcre',
            'set home_mailbox Maildir/',
        ],
        require => Package[$packages],
        notify  => Service["postfix"],
    }

    file { "/etc/postfix/virtual_forwardings.pcre":
        owner => 'root',
        group => 'root',
        require => Package[$packages],
        notify  => Service["postfix"],
        content => "/@.*/ vagrant
"
    }

    file { "/etc/postfix/virtual_domains.pcre":
        owner => 'root',
        group => 'root',
        require => Package[$packages],
        notify  => Service["postfix"],
        content => "/^.*/ OK
",
    }

    # Setup maildir
    file { '/home/vagrant/Maildir':
      owner => 'vagrant',
      group => 'vagrant',
      ensure => 'directory',
    }
    file { '/home/vagrant/Maildir/cur':
      owner => 'vagrant',
      group => 'vagrant',
      ensure => 'directory',
      require => File['/home/vagrant/Maildir'],
    }
    file { '/home/vagrant/Maildir/new':
      owner => 'vagrant',
      group => 'vagrant',
      ensure => 'directory',
      require => File['/home/vagrant/Maildir'],
    }
    file { '/home/vagrant/Maildir/tmp':
      owner => 'vagrant',
      group => 'vagrant',
      ensure => 'directory',
      require => File['/home/vagrant/Maildir'],
    }

    exec { 'maildir-permissions' :
        command => '/bin/chown -R vagrant:vagrant /home/vagrant/Maildir',
        require => [
            Package[$packages],
        ],
        subscribe => File['/home/vagrant/Maildir/cur', '/home/vagrant/Maildir/new', '/home/vagrant/Maildir/tmp'],
        refreshonly => true,
    }
}
