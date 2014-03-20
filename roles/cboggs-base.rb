name "cboggs-base"
description "Cody's Base role for a server"
run_list(
  "recipe[cboggs-base::default]",
  "recipe[java::default]",
  "recipe[yum-epel::default]"
)
default_attributes(
  "ntp" => {
    "servers" => ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org"]
  },
  "java" => {
    "jdk_version" => "7",
    "install_flavor" => "openjdk"
  }
)
