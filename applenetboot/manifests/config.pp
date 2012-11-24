# /etc/puppet/modules/applenetboot/manifests/config.pp

class applenetboot::config ( $interface = $applenetboot::params::interface)
inherits applenetboot::params {

  Property_list_key {
    notify => Service['com.apple.bootpd'],
    before => File['/private/etc/bootpd.plist'],
  }

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
  }

  ## bootpd.plist keys ##
  #
  #  Note: There are others that can be exposed; these are the basics
  property_list_key { 'set_netboot_interfaces':
    ensure     => present,
    path       => '/private/etc/bootpd.plist',
    key        => 'netboot_enabled',
    value      => [$interface],
    value_type => 'array',
  }

  property_list_key { 'bootp_enabled':
    ensure     => present,
    path       => '/private/etc/bootpd.plist',
    key        => 'bootp_enabled',
    value      => true,
    value_type => 'boolean',
  }

  property_list_key { 'dhcp_enabled':
    ensure     => present,
    path       => '/private/etc/bootpd.plist',
    key        => 'dhcp_enabled',
    value      => false,
    value_type => 'boolean',
  }

  property_list_key { 'old_netboot_enabled':
    ensure     => present,
    path       => '/private/etc/bootpd.plist',
    key        => 'old_netboot_enabled',
    value      => false,
    value_type => 'boolean',
  }

  property_list_key { 'relay_enabled':
    ensure     => present,
    path       => '/private/etc/bootpd.plist',
    key        => 'relay_enabled',
    value      => false,
    value_type => 'boolean',
  }

  file { '/private/etc/exports':
    ensure  => present,
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('applenetboot/exports.erb'),
    notify  => Service['com.apple.bootpd'],
  }

  service { 'com.apple.bootpd':
    ensure  => running,
    enable  => true,
    require => [ File['/private/etc/bootpd.plist'],
                      Service['com.apple.tftp']
                    ]
  }

  service { 'com.apple.tftpd':
    ensure  => running,
    enable  => true,
    require => File['/System/Library/LaunchDaemons/tftp.plist'],
  }
}
