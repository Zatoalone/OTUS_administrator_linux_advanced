[cluster_hosts]
%{ for hostname in cluster_hosts ~}
${hostname}
%{ endfor ~}

[storage_hosts]
%{ for hostname in storage_hosts ~}
${hostname}
%{ endfor ~}

[ansible_host]
localhost
