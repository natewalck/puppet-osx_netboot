# /etc/puppet/modules/applenetboot/manifests/config.pp

class applenetboot::config ( $interface = $applenetboot::params::interface)
{
  require applenetboot::install

  file { '/System/Library/LaunchDaemons/tftp.plist':
    ensure  => 'file',
    source  => 'puppet:///modules/applenetboot/tftp.plist',
    group   => '0',
    mode    => '0644',
    owner   => '0',
  }

  property_list_key { 'bootp_enabled':
    ensure     => present,
    path       => '/etc/bootpd',
    key        => 'bootp_enabled',
    value      => true,
    value_type => 'boolean',
  }

  property_list_key { 'detect_other_dhcp_server':
    ensure     => present,
    path       => '/etc/bootpd',
    key        => 'detect_other_dhcp_server',
    value      => true,
    value_type => 'boolean',
  }

  property_list_key { 'dhcp_enabled_false':
    ensure     => present,
    path       => '/etc/bootpd',
    key        => 'dhcp_enabled',
    value      => false,
    value_type => 'boolean',
  }

  property_list_key { 'netboot_enabled':
    ensure     => present,
    path       => '/etc/bootpd',
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
    content => template('applenetboot/exports.erb'),
    notify  => Service['com.apple.bootpd'],
  }

  service { 'com.apple.bootpd':
    ensure  => running,
    enable  => true,
    require => [ Property_list_key['bootp_enabled'],
                      Property_list_key['detect_other_dhcp_server'],
                      Property_list_key['dhcp_enabled_false'],
                      Property_list_key['netboot_enabled'],
                      Service['com.apple.tftpd']
                    ]
  }

  service { 'com.apple.tftpd':
    ensure  => running,
    enable  => true,
    require => File['/System/Library/LaunchDaemons/tftp.plist'],
  }
}
