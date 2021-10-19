# Consul Template config file that controls what templates to monitor and
# execute when its Consul keys change.
#
# This config file is part of a blog post about lossless MySQL semi-sync replication and
# automated failover. You can find the blog post here: https://datto.engineering

consul {
  auth {
    enabled = false
  }
  address = "localhost:8500"
  retry {
    enabled = true
    attempts = 0
    backoff = "250ms"
    max_backoff = "1m"
  }
  ssl {
    enabled = false
  }
}
reload_signal = "SIGHUP"
kill_signal = "SIGINT"
max_stale = "10m"
log_level = "info"
template {
  source = "/etc/haproxy/haproxy_mysql.cfg.tpl"
  destination = "/etc/haproxy/conf.d/mysql.cfg"
  command = "systemctl reload haproxy" 
     # We actually have a custom script to do some more checking here,
     # but it boils down to a reload
  command_timeout = "30s"
  perms = "0644"
  backup = false
  wait = "2s:35s"
}
