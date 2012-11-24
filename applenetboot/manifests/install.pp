# /etc/puppet/modules/applenetboot/manifests/install.pp

class applenetboot::install( $root_dir = $applenetboot::params::root_dir)
inherits applenetboot::params{

  file { $root_dir:
    ensure => 'directory',
    group  => '80',
    mode   => '0775',
    owner  => '0',
    before => Class["applenetboot::config"],
  }

  file { "${root_dir}/NetBootClients0":
    ensure  => 'directory',
    group   => '80',
    mode    => '0775',
    owner   => '0',
    require => File[$root_dir],
  }
  
  file { "${root_dir}/NetBootSP0":
    ensure => 'directory',
    group  => '80',
    mode   => '0775',
    owner  => '0',
    require => File[$root_dir],
  }
  
  file { '/private/tftpboot/NetBoot':
    ensure => 'directory',
    group  => '80',
    mode   => '0755',
    owner  => '0',
    before => Class["applenetboot::config"],
  }
  
  file { '/private/tftpboot/NetBoot/NetBootSP0':
    ensure => 'link',
    target => "${root_dir}/NetBootSP0",
    require => File['/private/tftpboot/NetBoot'],
  }
  
  file { "${root_dir}/.clients":
    ensure => 'link',
    target => 'NetBootClients0',
    require => File[$root_dir],
  }
  
  file { "${root_dir}/.sharepoint":
    ensure => 'link',
    target => 'NetBootSP0',
    require => File[$root_dir],
  }
}
