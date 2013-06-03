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

    exec { "postfix-virtual-config" :
        command => '/bin/echo "/@.*/ vagrant" > /etc/postfix/virtual_forwardings.pcre ; /bin/echo "/^.*/ OK" > /etc/postfix/virtual_domains.pcre',
        require => Package[$packages],
        notify  => Service["postfix"],
    }

    # Setup maildir
    exec { 'vagrant-maildir' :
        command => '/bin/mkdir -p /home/vagrant/Maildir/{cur,new,tmp}',
        require => Package[$packages],
    }
    exec { 'maildir-permissions' :
        command => '/bin/chown -R vagrant:vagrant /home/vagrant/Maildir',
        require => [
            Package[$packages],
            Exec["vagrant-maildir"],
        ],
    }
}