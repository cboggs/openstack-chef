#
# Cookbook Name:: glance
# Recipe:: registry-setup
#
# Copyright 2012, Rackspace US, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)
include_recipe "mysql::client"
include_recipe "mysql::ruby"
include_recipe "glance::glance-rsyslog"
include_recipe "monitoring"

if not node["package_component"].nil?
  release = node["package_component"]
else
  release = "folsom"
end

platform_options = node["glance"]["platform"][release]

directory "/var/log/glance" do
  owner "glance"
  group "glance"
  mode 00777
  recursive true
end

file "/var/log/glance/registry.log" do
  owner "glance"
  group "glance"
  mode 00777
end

# make sure we die if there are glance-setups other than us
if get_role_count("glance-setup", false) > 0
  Chef::Application.fatal! "You can only have one node with the glance-setup role"
end

unless node["glance"]["db"]["password"]
  Chef::Log.info("Running glance setup - setting glance passwords")
end

if node["developer_mode"]
  node.set_unless["glance"]["db"]["password"] = "glance"
else
  node.set_unless["glance"]["db"]["password"] = secure_password
end
node.set_unless["glance"]["service_pass"] = secure_password

package "python-keystone" do
    action :install
end

ks_admin_endpoint = get_access_endpoint("keystone-api", "keystone", "admin-api")
ks_service_endpoint = get_access_endpoint("keystone-api", "keystone", "service-api")
keystone = get_settings_by_role("keystone", "keystone")

registry_endpoint = get_bind_endpoint("glance", "registry")

# creates db and user and returns connection info
mysql_info = create_db_and_user("mysql",
                                node["glance"]["db"]["name"],
                                node["glance"]["db"]["username"],
                                node["glance"]["db"]["password"])

mysql_connect_ip = get_access_endpoint('mysql-master', 'mysql', 'db')["host"]

package "curl" do
  action :install
end

platform_options["mysql_python_packages"].each do |pkg|
  package pkg do
    action :install
  end
end

platform_options["glance_packages"].each do |pkg|
  package pkg do
    action :install
    options platform_options["package_overrides"]
  end
end

file "/var/lib/glance/glance.sqlite" do
    action :delete
end

# Register Service Tenant
keystone_tenant "Register Service Tenant" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["scheme"]
  api_ver ks_admin_endpoint["path"]
  auth_token keystone["admin_token"]
  tenant_name node["glance"]["service_tenant_name"]
  tenant_description "Service Tenant"
  tenant_enabled "1" # Not required as this is the default
  action :create
end

# Register Service User
keystone_user "Register Service User" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["scheme"]
  api_ver ks_admin_endpoint["path"]
  auth_token keystone["admin_token"]
  tenant_name node["glance"]["service_tenant_name"]
  user_name node["glance"]["service_user"]
  user_pass node["glance"]["service_pass"]
  user_enabled "1" # Not required as this is the default
  action :create
end

## Grant Admin role to Service User for Service Tenant ##
keystone_role "Grant 'admin' Role to Service User for Service Tenant" do
  auth_host ks_admin_endpoint["host"]
  auth_port ks_admin_endpoint["port"]
  auth_protocol ks_admin_endpoint["scheme"]
  api_ver ks_admin_endpoint["path"]
  auth_token keystone["admin_token"]
  tenant_name node["glance"]["service_tenant_name"]
  user_name node["glance"]["service_user"]
  role_name node["glance"]["service_role"]
  action :grant
end

directory "/etc/glance" do
  action :create
  group "glance"
  owner "glance"
  mode "0700"
end

template "/etc/glance/logging.conf" do
  source "glance-logging.conf.erb"
  owner "glance"
  group "glance"
  mode "0600"
  variables(
    "use_syslog" => node["glance"]["syslog"]["use"],
    "log_facility" => node["glance"]["syslog"]["facility"]
  )
end

template "/etc/glance/glance-registry.conf" do
  source "#{release}/glance-registry.conf.erb"
  owner "glance"
  group "glance"
  mode "0600"
  variables(
    "registry_bind_address" => registry_endpoint["host"],
    "registry_port" => registry_endpoint["port"],
    "db_ip_address" => mysql_connect_ip,
    "db_user" => node["glance"]["db"]["username"],
    "db_password" => node["glance"]["db"]["password"],
    "db_name" => node["glance"]["db"]["name"],
    "use_syslog" => node["glance"]["syslog"]["use"],
    "log_facility" => node["glance"]["syslog"]["facility"]
  )
end

# TODO(breu): need to find out why this is happening
# Workaround an installation bug where glance-console gets owned by root
file "/var/log/glance/glance-console.log" do
  owner "glance"
  group "glance"
  action :touch
end

execute "glance-manage db_sync" do
  user "glance"
  group "glance"
  if platform?(%w{ubuntu debian})
    command "glance-manage version_control 0 && glance-manage db_sync"
  end
  if platform?(%w{redhat centos fedora scientific})
    command "glance-manage db_sync"
  end
  not_if "glance-manage db_version"
  action :run
end
