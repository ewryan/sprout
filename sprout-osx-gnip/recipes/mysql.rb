#http://solutions.treypiepmeier.com/2010/02/28/installing-mysql-on-snow-leopard-using-homebrew/
require 'pathname'

PASSWORD = node["mysql_root_password"]
# The next two directories will be owned by WS_USER
DATA_DIR = "/usr/local/var/mysql"
PARENT_DATA_DIR = "/usr/local/var"
WS_USER = node["current_user"]
WS_HOME = node['sprout']['home']

[ "/Users/#{WS_USER}/Library/LaunchAgents",
  PARENT_DATA_DIR,
  DATA_DIR ].each do |dir|
  directory dir do
    owner WS_USER
    action :create
  end
end

dmg_package "mysql-5.1.69-osx10.6-x86_64" do
  volumes_dir "mysql-5.1.69-osx10.6-x86_64"
  source "http://gnipit.s3.amazonaws.com/sprout/mysql-5.1.69-osx10.6-x86_64.dmg"
  checksum "7fa018dc2ba36f0c07b4696a764ed5d26e3c39ec0c9057946ae9cec8b802d161"
  package_id "com.mysql.mysql"
  type "pkg"
  action :install
end

dmg_package "MySQLStartupItem" do
  volumes_dir "mysql-5.1.69-osx10.6-x86_64"
  source "http://gnipit.s3.amazonaws.com/sprout/MySQLStartupItem.dmg"
  checksum "7fa018dc2ba36f0c07b4696a764ed5d26e3c39ec0c9057946ae9cec8b802d161"
  package_id "com.mysql.mysqlstartup"
  type "pkg"
  action :install
end

execute "Add Mysql to PATH" do
  command "echo 'export PATH=\"/usr/local/mysql/bin:$PATH\"' >> #{WS_HOME}/.bash_profile && export PATH=\"/usr/local/mysql/bin:$PATH\""
  not_if "grep 'export PATH=\"/usr/local/mysql/bin:$PATH\"' #{WS_HOME}/.bash_profile"
end

execute "your current user owns /usr/local" do
  command "chown -R mysql /usr/local/mysql/*"
end

execute "fix permissions" do
  command "chmod -R 777 /usr/local/mysql/*"
end

execute "fix permissions 2" do
  command "chmod -R 755 /usr/local/mysql/bin"
end

execute "load the mysql plist into the mac daemon startup thing" do
  command "/Library/StartupItems/MySQLCOM/MySQLCOM start"
  user WS_USER
  not_if { system("ps aux | grep mysqld | grep -v grep") }
end

ruby_block "Checking that mysql is running" do
  block do
    Timeout::timeout(60) do
      until system("ls /tmp/mysql.sock")
        sleep 1
      end
    end
  end
end

execute "set the root password to the default" do
  command "/usr/local/mysql/bin/mysqladmin -uroot password #{PASSWORD}"
  not_if "/usr/local/mysql/bin/mysql -uroot -p#{PASSWORD} -e 'show databases'"
end