dmg_properties   = node["sprout"]["jdk7"]["dmg"]
dmg_source       = dmg_properties["source"]
dmg_volumes_dir  = dmg_properties["volumes_dir"]
dmg_checksum     = dmg_properties["checksum"]

dmg_package "jdk7u51" do
  source dmg_source
  volumes_dir dmg_volumes_dir
  action :install
  type "pkg"
  package_id "com.oracle.jdk7u51"
  checksum dmg_checksum
end
