#
# Cookbook Name:: zuul
# Recipe:: worker
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

db_info = node[:stacktach][:worker][:db]

# create database
mysql_database "create #{db_info[:name]} database" do
  connection db_info
  database_name db_name
  action :create
end

# create user
mysql_database_user db_info[:username] do
  connection db_info
  password db_info[:password]
  action :create
end

# grant privs to user
mysql_database_user db_info[:username] do
  connection db_info
  password db_info[:password]
  database_name db_info[:name]
  host '%'
  privileges [:all]
  action :grant
end

conf_path = node[:stacktach][:worker][:conf_path]
template "#{conf_path}" do
  source "worker_conf.py.erb"
  notifies :restart, "service[stacktach_worker]"
  variables({
    :deployments => node[:stacktach][:worker][:deployments] 
  })
end

python_pip "stacktach" do
  action [:install]
end
