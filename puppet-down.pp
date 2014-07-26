$zone = 'asia-east1-a'

gce_disk{'puppet-www-boot1':
  ensure => absent,
  zone => "$zone",
}

gce_disk{'puppet-www-boot2':
  ensure => absent,
  zone => "$zone",
}

gce_instance{'puppet-www2':
  ensure => absent,
  zone => "$zone",
}

gce_instance{'puppet-www1':
  ensure => absent,
  zone => "$zone",
}

gce_firewall{'puppet-www-http':
  ensure => absent,
}

Gce_instance["puppet-www1", "puppet-www2"] -> Gce_disk["puppet-www-boot1", "puppet-www-boot2"]
