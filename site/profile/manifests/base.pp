class profile::base {

  #the base profile should include component modules that will be on all nodes
  class { '::ntp':
    servers => [ 'ntp1.corp.com', 'ntp2.corp.com' ],
}
class{'network':
  config_file_notify => '',
  }
network::mroute { 'eth0':
  routes => {
    '192.168.2.0/24' => '192.168.1.1',
    '80.81.82.0/16'  => 'eth0',
  }
}
class profile::netbackup {
 archive { '/tmp/r':
  ensure        => present,
  extract       => true,
  extract_path  => '/tmp',
  source        => 'http://10.147.8.18/Sw/backup/NetBackup_7.7.2_CLIENTS2-tar',
  creates       => '/tmp/NetBackup_7.7.2_CLIENTS2',
  cleanup       => true,
  }
class { 'netbackup::client':
    installer       => '/tmp/NetBackup_7.7.2_CLIENTS2/install',
    version         => '7.7.2',
    service_enabled => true,
    masterserver    => 'emhco039.svc',
    mediaservers    => ['mediasrv1.xyz.com', 'mediasrv2.xyz.com'],
    excludes        => ['/tmp'],
}
}
}
