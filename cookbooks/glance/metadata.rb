maintainer        "Rackspace US, Inc."
license           "Apache 2.0"
description       "Installs and configures the Glance Image Registry and Delivery Service"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.18"
recipe            "glance::setup", "Handles glance keystone registration and database creation"
recipe            "glance::api", "Installs packages required for a glance api server"
recipe            "glance::registry", "Installs packages required for a glance registry server"
recipe            "glance::glance-rsyslog", "Creates rsyslog configuration for glance"
recipe            "glance::replicator", "Drops in cronjobs to sync glance images when running 2 node HA setup w/ file storage"

%w{ centos ubuntu }.each do |os|
  supports os
end

%w{ database dsh monitoring mysql openssl osops-utils }.each do |dep|
  depends dep
end

depends "keystone", ">= 1.0.18"
