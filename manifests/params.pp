# /etc/puppet/modules/manifests/params.pp
class osx_netboot::params {
  # root directory of the netboot sets
  $root_dir = '/Library/NetBoot'
  $interface = 'en0'
}
