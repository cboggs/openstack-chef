#
# Cookbook Name:: rsyslog
# Attributes:: rsyslog
#
# Copyright 2009, Opscode, Inc.
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

default["rsyslog"]["log_dir"]       = "/srv/rsyslog"                        # node_attribute
default["rsyslog"]["server"]        = false                                 # node_attribute
default["rsyslog"]["protocol"]      = "tcp"                                 # node_attribute
default["rsyslog"]["port"]          = "514"                                 # node_attribute
default["rsyslog"]["server_ip"]     = nil                                   # node_attribute (inherited from cluster?)
default["rsyslog"]["server_search"] = "role:loghost"                        # node_attribute
default["rsyslog"]["remote_logs"]   = true                                  # node_attribute
default["rsyslog"]["per_host_dir"]  = "%$YEAR%/%$MONTH%/%$DAY%/%HOSTNAME%"  # node_attribute

case platform
  when "fedora", "redhat", "centos", "scientific", "amazon"
    default["rsyslog"]["platform"] = {                                      # node_attribute
      "rsyslog_user" => "root",
      "rsyslog_group" => "root"
    }
  when "ubuntu"
    default["rsyslog"]["platform"] = {                                      # node_attribute
      "rsyslog_user" => "syslog",
      "rsyslog_group" => "adm"
    }
end
