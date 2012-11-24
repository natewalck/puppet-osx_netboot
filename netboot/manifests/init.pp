# /etc/puppet/modules/applenetboot/manifests/init.pp
class applenetboot
inherits applenetboot::params{

  class { "applenetboot::install" }

}
