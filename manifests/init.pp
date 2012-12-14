# /etc/puppet/modules/osx_netboot/manifests/init.pp
class osx_netboot(
  $root_dir = '/Library/NetBoot',
  $interface = 'en0'
) {
  class{'osx_netboot::install': } ->
  class{'osx_netboot::config': } ~>
  class{'osx_netboot::service': } ->
  Class['osx_netboot']
}
