name "graphite"
description "Cody's Graphite role for a server"
run_list(
  "recipe[graphite]"
)
default_attributes(
  "graphite" => {
    "django_root" => "/usr/lib64/python2.6/site-packages/django",
    "version" => "0.10.0"
  }
)
