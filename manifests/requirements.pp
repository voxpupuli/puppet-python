# == Define: python::requirements
#
# Installs and manages Python packages from requirements file.
#
# === Parameters
#
# [*requirements*]
#  Path to the requirements file. Defaults to the resource name
#
# [*virtualenv*]
#  virtualenv to run pip in. Default: system-wide
#
# [*proxy*]
#  Proxy server to use for outbound connections. Default: none
#
# === Examples
#
# python::requirements { '/var/www/project1/requirements.txt':
#   virtualenv => '/var/www/project1',
#   proxy      => 'http://proxy.domain.com:3128',
# }
#
# === Authors
#
# Sergey Stankevich
# Ashley Penney
#
define python::requirements (
  $requirements = $name,
  $virtualenv   = 'system',
  $proxy        = false
) {

  $pip_env = $virtualenv ? {
    'system' => '`which pip`',
    default  => "${virtualenv}/bin/pip",
  }

  $proxy_flag = $proxy ? {
    false    => '',
    default  => "--proxy=${proxy}",
  }

  $req_crc = "${requirements}.sha1"

   # This will ensure multiple python::virtualenv definitions can share the
   # the same requirements file.
   if !defined(File[$requirements]) {
	file { $requirements:
      ensure  => present,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      replace => false,
      content => '# Puppet will install and/or update pip packages listed here',
    }
  }

  # SHA1 checksum to detect changes
  exec { "python_requirements_check_${name}":
    command => "sha1sum ${requirements} > ${req_crc}",
    unless  => "sha1sum -c ${req_crc}",
    require => File[$requirements],
  }

  exec { "python_requirements_update_${name}":
    command     => "${pip_env} install ${proxy_flag} -Ur ${requirements}",
    cwd         => $virtualenv,
    refreshonly => true,
    timeout     => 1800,
    subscribe   => Exec["python_requirements_check_${name}"],
  }

}
