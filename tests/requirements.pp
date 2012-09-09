class { 'python':
  version    => 'system',
  dev        => true,
  virtualenv => true,
}

python::requirements { '/var/www/project1/requirements.txt':
  virtualenv => '/var/www/project1',
  proxy      => 'http://proxy.domain.com:3128',
}
