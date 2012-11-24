# /etc/puppet/modules/manifests/params.pp
class applenetboot::params {
  # root directory of the netboot sets
  $root_dir = "/Library/NetBoot"
  $interface = "en0"
}
