# /etc/puppet/modules/osx_netboot/manifests/config.pp

class osx_netboot::config{
  $interface = $osx_netboot::interface

  file { '/System/Library/LaunchDaemons/tftp.plist':
    ensure  => 'file',
    source  => 'puppet:///modules/osx_netboot/tftp.plist',
    group   => '0',
    mode    => '0644',
    owner   => '0',
  }

  property_list_key { 'bootp_enabled':
    ensure     => present,
    path       => '/etc/bootpd.plist',
    key        => 'bootp_enabled',
    value      => true,
    value_type => 'boolean',
  }

  property_list_key { 'detect_other_dhcp_server':
    ensure     => present,
    path       => '/etc/bootpd.plist',
    key        => 'detect_other_dhcp_server',
    value      => true,
    value_type => 'boolean',
  }

  property_list_key { 'dhcp_enabled_false':
    ensure     => present,
    path       => '/etc/bootpd.plist',
    key        => 'dhcp_enabled',
    value      => false,
    value_type => 'boolean',
  }

  property_list_key { 'netboot_enabled':
    ensure     => present,
    path       => '/etc/bootpd.plist',
    key        => 'netboot_enabled',
    value      => ["${interface}"],
    value_type => 'array',
  }

  # Possibly not needed?
  #  exec { 'startTime':
  #    path    => '/bin:/usr/bin',
  #    command => 'defaults write /etc/bootpd startTime\
  #                                          "$(date "+%Y-%m-%d %H:%M:%S %z")"',
  #    unless  => 'defaults read /etc/bootpd bootp_enabled | grep -qx 1',
  #  }

  file { '/private/etc/exports':
    ensure  => present,
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('osx_netboot/exports.erb'),
    notify  => Service['com.apple.bootpd'],
  }
}
