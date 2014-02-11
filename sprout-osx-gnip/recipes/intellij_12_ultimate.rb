intellij_version = "12.1.6"
dmg_package "IntelliJ IDEA 12" do
  source "https://gnipit.s3.amazonaws.com/sprout/ideaIU-#{intellij_version}.dmg"
  checksum "5220936c15538b6c7c0580f82fdafe1ee1200441f4a5f5ed2c43d69474748472"
  owner node["current_user"]
  action :install
end