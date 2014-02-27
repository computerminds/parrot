# This module is distributed under the GNU Affero General Public License:
# 
# Pear module for puppet
# Copyright (C) 2009 Sarava Group
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Uses pear provider from http://projects.reductivelabs.com/issues/1823
#                         http://www.mit.edu/~marthag/puppet/pear.rb
# Uses pecl provider from http://projects.reductivelabs.com/issues/2926
#                         http://web.mit.edu/~marthag/www/puppet/pecl.rb
class pear {
  # Provides "phpize" command for pear
  package { "php5-dev":
    ensure => installed,
  }

  # Make is a pear dependency
  if !defined(Package['make']) {
    package { "make":
      ensure => installed,
    }
  }

  # Pear
  package { "php-pear":
    ensure  => installed,
    require => Package["php5-dev", "make"],
  }

  package { "uploadprogress":
    ensure   => installed,
    provider => pecl,
  } 

  file { "/etc/php5/apache2/conf.d/uploadprogress.ini":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => "extension=uploadprogress.so\n",
    require => Package["uploadprogress"],
  }

  package { "xhprof-beta":
      ensure   => installed,
      provider => pecl,
    }

  file {"/tmp/xhprof":
    ensure  => 'directory',
    owner   => root,
    group   => root,
    mode    => 0777,
  }

  file { "/etc/php5/apache2/conf.d/xhprof.ini":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => "extension=xhprof.so\nxhprof.output_dir='/tmp/xhprof'",
    require => Package["xhprof-beta"],
  }
}
