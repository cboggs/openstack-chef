#
# Cookbook Name:: stacktach
# Attributes:: default
#
# Copyright 2012, Jay Pipes
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# The following are attributes for the StackTack worker service

# Path to the worker_conf.py location used when starting the worker
default[:stacktach][:worker][:conf_path] = "/etc/stacktach/worker_conf.py"

# Database where StackTach stores its log data
default[:stacktach][:worker][:db][:username] = "stacktach"
default[:stacktach][:worker][:db][:password] = "stacktach"
default[:stacktach][:worker][:db][:name] = "stacktach"
default[:stacktach][:worker][:db][:host] = "127.0.0.1"

# The deployments that StackTach monitors. This is an Array
# of Hash objects, with each Hash object having the following
# keys:
#
# "tenant_id":  This is the stacktach tenant, NOT an openstack tenant
# "name":  A name for the deployment
# "stacktach_uri": The url for the base of the django app
# "rabbit_host": ip/host name of the amqp server to listen to
# "rabbit_port": Port to grab mesages on, Rabbit's default is 5672
# "rabbit_user": User to connect to Rabbit with
# "rabbit_password": Password for user connecting to Rabbit with
# "rabbit_vhost": The vhost or queue to connecto to in Rabbit

default[:stacktach][:worker][:deployments] = []

# The following attributes control configuration and installation of the
# StackTach Django web application

# Directory to find the StackTach Django application
default[:stacktach][:http][:doc_root] = "/usr/share/stacktach"

# Directory to find the WSGI setup code for the application
default[:stacktach][:http][:wsgi_dir] = "#{node[:stacktach][:httpd][:doc_root]}/wsgi"

# Path to find the Django application's local settings file
case node[:platform]
when "fedora", "centos", "redhat"
  default[:stacktach][:local_settings_path] = "/etc/stacktach/local_settings"
when "ubuntu", "debian"
  default[:stacktach][:local_settings_path] = "/etc/stacktach/local_settings.py"
end
