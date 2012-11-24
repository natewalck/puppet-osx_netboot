# /etc/puppet/modules/applenetboot/manifests/init.pp
class applenetboot {

  include applenetboot::params
  include applenetboot::install
  include applenetboot::config

}
