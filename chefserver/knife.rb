repo_dir                 "#{ENV['OPENSTACK_CHEF']}/chefserver"
log_level                :info
log_location             STDOUT
node_name                "operations"
client_key               "#{repo_dir}/.chef/operations.pem"
validation_client_name   "chef-validator"
validation_key           "#{repo_dir}/.chef/chef-validator.pem"
chef_server_url          "https://chefserver.localdomain:443"
syntax_check_cache_path  "#{repo_dir}/.chef/syntax_check_cache"
cache_options(  :path => "#{repo_dir}/.chef/checksums" )
cookbook_path [ "#{ENV['OPENSTACK_CHEF']}/cookbooks" ]
