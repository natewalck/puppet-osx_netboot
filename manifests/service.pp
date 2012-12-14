# /etc/puppet/modules/osx_netboot/manifests/service.pp

class osx_netboot::service{
  service { 'com.apple.bootpd':
    ensure  => running,
    enable  => true,
  }

  service { 'com.apple.tftpd':
    ensure  => running,
    enable  => true,
  }
}
