# /etc/puppet/modules/osx_netboot/manifests/init.pp
class osx_netboot {

  include osx_netboot::params
  include osx_netboot::install
  include osx_netboot::config

}
