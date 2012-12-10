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

  exec { 'bootp_enabled':
    path    => '/bin:/usr/bin',
    command => 'defaults write /etc/bootpd bootp_enabled -bool true',
    unless  => 'defaults read /etc/bootpd bootp_enabled | grep -qx 1',
  }

  exec { 'dhcp_enabled_false':
    path    => '/bin:/usr/bin',
    command => 'defaults write /etc/bootpd dhcp_enabled -bool false',
    unless  => 'defaults read /etc/bootpd dchp_enabled | grep -qx 0',
  }

  exec { 'netboot_enabled':
    path    => '/bin:/usr/bin',
    command => "defaults write /etc/bootpd netboot_enabled\
                                          -array-add ${interface}",
    unless  => "defaults read /etc/bootpd netboot_enabled\
                                          | grep -q ${interface}",
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
    require => [ Exec['bootp_enabled'],
                      Exec['dhcp_enabled_false'],
                      Exec['netboot_enabled'],
                      Service['com.apple.tftpd']
                    ]
  }

  service { 'com.apple.tftpd':
    ensure  => running,
    enable  => true,
    require => File['/System/Library/LaunchDaemons/tftp.plist'],
  }
}
