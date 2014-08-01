class openresty {
  include openresty::config
  include homebrew

  # tap the brew
  homebrew::tap { 'killercup/homebrew-openresty': }

  # custom plist for openresty
  file { '/Library/LaunchDaemons/dev.openresty.plist':
    content => template('openresty/dev.openresty.plist.erb'),
    owner   => 'root',
    group   => 'wheel',
    notify  => Service['dev.openresty'],
  }

  # Set up all the files and directories nginx expects. We go
  # nonstandard on this mofo to make things as clearly accessible as
  # possible under $BOXEN_HOME.

  file { [
    $openresty::config::configdir,
    $openresty::config::datadir,
    $openresty::config::logdir,
    $openresty::config::sitesdir
  ]:
    ensure => directory
  }

  # nginx config files
  file { $openresty::config::configfile:
    content => template('openresty/nginx.conf.erb'),
    notify  => Service['dev.openresty']
  }

  file { "${openresty::config::configdir}/cors":
    source  => 'puppet:///modules/openresty/cors',
    notify  => Service['dev.openresty'],
  }

  file { "${openresty::config::configdir}/mime.types":
    source  => 'puppet:///modules/openresty/mime.types',
    notify  => Service['dev.openresty'],
  }

  # Remove Homebrew's nginx config to avoid confusion.
  file { "${boxen::config::home}/homebrew/etc/openresty":
    ensure  => absent,
    force   => true,
    recurse => true,
    require => Package['ngx_openresty'],
  }

  # install openresty
  package { 'ngx_openresty':
    ensure => present,
    notify => Service['dev.openresty'],
  }

  # set up the service
  service { 'dev.openresty':
    ensure  => running,
    require => Package['ngx_openresty'],
  } 
}
