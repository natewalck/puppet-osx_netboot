# /etc/puppet/modules/applenetboot/manifests/config.pp

class applenetboot::config ( $interface = $applenetboot::params::interface)
inherits applenetboot::params {

  file { '/System/Library/LaunchDaemons/tftp.plist':
    ensure  => 'file',
    source  => 'puppet:///modules/applenetboot/tftp.plist',
    group   => '0',
    mode    => '0644',
    owner   => '0',
  }

  file { '/private/etc/bootpd.plist':
    ensure  => present,
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('applenetboot/bootpd.plist.erb')
  }

  file { '/private/etc/exports':
    ensure  => present,
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('applenetboot/exports.erb'),
    notify  => Service['/System/Library/LaunchDaemons/bootps.plist'],
  }

  service { '/System/Library/LaunchDaemons/bootps.plist':
    ensure  => running,
    enable  => true,
    require => [File['/private/etc/bootpd.plist']],
  }
}
