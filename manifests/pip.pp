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
  $virtualenv = 'system',
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

  if $virtualenv == 'system' and ($owner != 'root' or $group != 'root') {
    fail('python::pip: root user must be used when virtualenv is system')
  }

  $cwd = $virtualenv ? {
    'system' => '/',
    default  => "${virtualenv}",
  }

  $pip_env = $virtualenv ? {
    'system' => '`which pip`',
    default  => "${virtualenv}/bin/pip",
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
        command     => "$pip_env --log-file ${cwd}/pip.log install ${proxy_flag} ${source}",
        unless      => "$pip_env freeze | grep -i -e ${grep_regex}",
        user        => $owner,
        environment => $environment,
      }
    }

    default: {
      exec { "pip_uninstall_${name}":
        command     => "echo y | $pip_env uninstall ${proxy_flag} ${name}",
        onlyif      => "$pip_env freeze | grep -i -e ${grep_regex}",
        user        => $owner,
        environment => $environment,
      }
    }
  }

}
