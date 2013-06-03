# == Define: python::pip
#
# Installs and manages packages from pip.
#
# === Parameters
#
# [*ensure*]
#  present|absent. Default: present
#
# [*virtualenv*]
#  virtualenv to run pip in.
#
# [*url*]
#  URL to install from. Default: none
#
# [*proxy*]
#  Proxy server to use for outbound connections. Default: none
#
# === Examples
#
# python::pip { 'flask':
#   virtualenv => '/var/www/project1',
#   proxy      => 'http://proxy.domain.com:3128',
# }
#
# === Authors
#
# Sergey Stankevich
#
define python::pip (
  $virtualenv,
  $ensure     = present,
  $url        = false,
  $owner      = 'root',
  $group      = 'root',
  $proxy      = false,
  environment = []
) {

  # Parameter validation
  if ! $virtualenv {
    fail('python::pip: virtualenv parameter must not be empty')
  }

  $proxy_flag = $proxy ? {
    false    => '',
    default  => "--proxy=${proxy}",
  }

  $grep_regex = $name ? {
    /==/    => "^${name}\$",
    default => "^${name}==",
  }

  $source = $url ? {
    false   => $name,
    default => "${url}#egg=${name}",
  }

  case $ensure {
    present: {
      exec { "pip_install_${name}":
        command     => "${virtualenv}/bin/pip install ${proxy_flag} ${source}",
        unless      => "${virtualenv}/bin/pip freeze | grep -i -e ${grep_regex}",
        user        => $owner,
        environment => $environment,
      }
    }

    default: {
      exec { "pip_uninstall_${name}":
        command     => "echo y | ${virtualenv}/bin/pip uninstall ${proxy_flag} ${name}",
        onlyif      => "${virtualenv}/bin/pip freeze | grep -i -e ${grep_regex}",
        user        => $owner,
        environment => $environment,
      }
    }
  }

}
