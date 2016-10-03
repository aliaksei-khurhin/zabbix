
node default {
  class { '::mysql::server':
    root_password    => 'p@$$w0rd'
  }

  mysql_user { 'zabbix@localhost':
    ensure => present,
  }

  mysql_database { 'zabbix':
    ensure  => present,
    charset => 'utf8',
    collate => 'utf8_bin'
  }

  mysql_grant { 'zabbix/zabbix.*':
    ensure     => present,
    options    => ['GRANT'],
    privileges => ['ALL'],
    table      => 'zabbix.*',
    user       => 'zabbix'
  }

  yumrepo { 'zabbix':
    ensure   => 'present',
    baseurl  => 'http://repo.zabbix.com/zabbix/2.2/rhel/6/$basearch/',
    descr    => 'Zabbix Official Repository - $basearch',
    enabled  => '1',
    gpgcheck => '1',
    gpgkey   => 'http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX',
    require => Mysql_grant['zabbix/zabbix.*']
  }
  
  $pack = {
  'zabbix-server'    => '2.2.14',
  'zabbix-web-mysql' => '2.2.14',
  'zabbix-agent'     => '2.2.14',
  'php'              => 'latest'
  }
  $pack.each | $p, $v |  
    package { :
      ensure  => v,
      name    => p,
      require => Yumrepo['zabbix']
    }
  end

  file { '/etc/httpd/conf.d/zabbix.conf':
    ensure  => file,
    content => template('templates/zabbix.erb'),
    owner   => root,
    group   => root,
    mode    => '0644',
    backup  => false,
    require => Package['install']
  }
  
  file { '/etc/zabbix/zabbix_server.conf':
    ensure  => file,
    content => template('templates/zabbix_server.erb'),
    owner   => root,
    group   => zabbix,
    mode    => '0644',
    backup  => false,
    require => File['/etc/httpd/conf.d/zabbix.conf']
  }

  serv=[ 'zabbix-server', 'zabbix-agent', 'httpd' ]
  serv.each do | sv |
    service { sv:
      ensure  => 'running',
      enable  => 'true',
      require => File['/etc/zabbix/zabbix_server.conf']
    }
  end
}
