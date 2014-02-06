node.default['versions']['rvm'] = '18048d56515699dc8f97f1a85f36526b87b4a721'

node.default["rvm"] ||= {}
node.default["rvm"]["rubies"] = {
    #"ruby-1.9.2-p290" => { :env => "CC=gcc-4.2" },
    #"ruby-1.9.3-p194" => { :command_line_options => "--with-gcc=clang" },
    "ruby-2.0.0-p353" => { :command_line_options => "--verify-downloads 1" }
}

node.default["rvm"]["default_ruby"] = "ruby-2.0.0-p353"
