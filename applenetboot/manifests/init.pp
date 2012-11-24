# /etc/puppet/modules/applenetboot/manifests/init.pp
class applenetboot ( $root_dir = $applenetboot::params::root_dir)
inherits applenetboot::params {

  class {
    "applenetboot::install":
      root_dir => $root_dir
  }

}
