maintainer          "Jay Pipes"
maintainer_email    "jaypipes@gmail.com"
license             "Apache 2.0"
description         "Installs the StackTach Debugging and Diagnostic tools for OpenStack Nova"
long_description    IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version             "0.1.1"

%w{ fedora redhat centos ubuntu debian }.each do |os|
  supports os
end

depends "apache2"
depends "database"
depends "mysql"
