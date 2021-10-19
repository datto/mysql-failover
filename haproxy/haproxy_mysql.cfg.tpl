# Consul Template file that generates the HAproxy configuration for the MySQL
# source hosts. The template is re-rendered every time any of the consul keys in it change.
#
# This config file is part of a blog post about lossless MySQL semi-sync replication and
# automated failover. You can find the blog post here: https://datto.engineering

{{- range ls "mysql/master/" -}}
{{- $cluster := .Key -}}
{{- if keyExists (printf "mysql/master/%s/managed" $cluster) -}}
    {{- $dbgroup := ($cluster | replaceAll "g" "" | parseInt) -}}
    {{- $haproxyport := add $dbgroup 3400 -}}
    {{- if keyExists (printf "mysql/master/%s/failed" $cluster)  }}
    listen mysql-{{ $cluster }}
        bind           127.0.0.1:{{ $haproxyport }}
        mode           tcp
        option         tcplog
        server         dead-end 127.0.0.1:1337
    {{- else  }}
    {{ $clusterhost := key ( printf "mysql/master/%s/hostname" $cluster) }}
    {{ $clusterip := key ( printf "mysql/master/%s/ipv4" $cluster) }}
    {{ $clusterport := key ( printf "mysql/master/%s/port" $cluster) }}
    listen mysql-{{ $cluster }}
        bind 127.0.0.1:{{ $haproxyport }}
        {{- if keyExists "mysql/maintenance" }}
        # Cluster is down for maintenance
        {{ else }}
        server {{ $clusterhost }} {{ $clusterip }}:{{ $clusterport }}
        mode tcp
        option tcplog
        {{- end }}
      {{- end }}
  {{- end }}
{{- end }}
