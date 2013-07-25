#
# Cookbook Name:: openstack-yum
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
major = node['platform_version'].split('.')[0]

yum_repository 'openstack' do
  name 'openstack-grizzly'
  description 'Openstack Grizzly Repo'
  url "http://repos.fedorapeople.org/repos/openstack/openstack-grizzly/epel-#{major}/"
  action :add
end