# /etc/puppet/modules/macnetboot/manifests.init.pp
class macnetboot (
  $root_dir = $macnetboot::params::root_dir
) inherits macnetboot::params{
  file { '/private/etc/exports':
    ensure  => present,
    group   => '0',
    mode    => '0644',
    owner   => '0',
    content => template('macnetboot/exports.erb'),
# wouldn't it be nice if this worked?
#    notify  => Service['/System/Library/LaunchDaemons/bootps.plist'],
  }
  file { $root_dir:
    ensure => 'directory',
    group  => '80',
    mode   => '0775',
    owner  => '0',
  }
  file { "${root_dir}/NetBootClients0":
    ensure => 'directory',
    group  => '80',
    mode   => '0775',
    owner  => '0',
  }
  file { "${root_dir}/NetBootSP0":
    ensure => 'directory',
    group  => '80',
    mode   => '0775',
    owner  => '0',
  }
  file { '/private/tftpboot/NetBoot':
    ensure => 'directory',
    group  => '80',
    mode   => '0755',
    owner  => '0',
  }
  file { '/private/tftpboot/NetBoot/NetBootSP0':
    ensure => 'link',
    target => "${root_dir}/NetBootSP0",
  }
  file { "${root_dir}/.clients":
    ensure => 'link',
    target => 'NetBootClients0',
  }
  file { "${root_dir}/.sharepoint":
    ensure => 'link',
    target => 'NetBootSP0',
  }
  file { '/System/Library/LaunchDaemons/tftp.plist':
    ensure  => 'file',
    source  => 'puppet:///modules/macnetboot/tftp.plist',
    group   => '0',
    mode    => '0644',
    owner   => '0',
  }
  file { '/private/etc/bootpd.plist':
    ensure  => 'file',
    source  => 'puppet:///modules/macnetboot/bootpd.plist',
    group   => '0',
    mode    => '0644',
    owner   => '0',
  }
# as stated previously, does not work
#  service { '/System/Library/LaunchDaemons/bootps.plist':
#    ensure  => running,
#    enable  => true,
#    require => [File['/private/etc/bootpd.plist']],
#  }
}