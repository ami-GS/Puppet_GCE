$zone = 'asia-east1-a'

gce_firewall { 'puppet-www-http':
 ensure      => present,
 network     => 'default',
 description => 'allows incoming HTTP connections',
 allowed     => 'tcp:80',
}

gce_disk { 'puppet-www-boot1':
  ensure       => present,
  source_image => 'debian-7',
  size_gb      => '10',
  zone         => "$zone",
}

gce_disk { 'puppet-www-boot2':
  ensure       => present,
  source_image => 'debian-7',
  size_gb      => '10',
  zone         => "$zone",
}


gce_instance { 'puppet-www1':
  ensure       => present,
  description  => 'Basic web server',
  machine_type => f1-micro,
  disk         => 'puppet-www-boot1,boot',
  zone         => "$zone",
  network      => 'default',

  require   => Gce_disk['puppet-www-boot1'],

  puppet_master => "",
  manifest     => '
    class apache ($version = "latest") {
      package {"apache2":
        ensure => $version,
      }
      file {"/var/www/index.html":
        ensure  => present,
        content => "<html>\n<body>\n\t<h2>Hi, this is $hostname ($gce_external_ip).</h2>\n</body>\n</html>\n",
        require => Package["apache2"],
      }
      service {"apache2":
        ensure => running,
        enable => true,
        require => File["/var/www/index.html"],
      }
    }

    include apache',
}

gce_instance { 'puppet-www2':
  ensure       => present,
  description  => 'Basic web server',
  machine_type => f1-micro,
  disk         => 'puppet-www-boot2,boot',
  zone         => "$zone",
  network      => 'default',

  require   => Gce_disk['puppet-www-boot2'],

  puppet_master => "",
  manifest     => '
    class apache ($version = "latest") {
      package {"apache2":
        ensure => $version,
      }
      file {"/var/www/index.html":
        ensure  => present,
        content => "<html>\n<body>\n\t<h2>Hi, this is $hostname ($gce_external_ip).</h2>\n</body>\n</html>\n",
        require => Package["apache2"],
      }
      service {"apache2":
        ensure => running,
        enable => true,
        require => File["/var/www/index.html"],
      }
    }

    include apache',
}
