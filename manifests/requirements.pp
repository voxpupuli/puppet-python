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
# [*owner*]
#  The owner of the virtualenv being manipulated. Default: root
#
# [*group*]
#  The group relating to the virtualenv being manipulated. Default: root
#
# [*proxy*]
#  Proxy server to use for outbound connections. Default: none
#
# [*src*]
# Pip --src parameter; if the requirements file contains --editable resources,
# this parameter specifies where they will be installed. See the pip
# documentation for more. Default: none (i.e. use the pip default).
#
# [*environment*]
#  Additional environment variables required to install the packages. Default: none
#
# [*forceupdate*]
#  Run a pip install requirements even if we don't receive an event from the
# requirements file - Useful for when the requirements file is written as part of a
# resource other than file (E.g vcsrepo)
#
# [*cwd*]
#  The directory from which to run the "pip install" command. Default: undef
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
# Fotis Gimian
#
define python::requirements (
  $requirements = $name,
  $virtualenv   = 'system',
  $owner        = 'root',
  $group        = 'root',
  $proxy        = false,
  $src          = false,
  $environment  = [],
  $forceupdate  = false,
  $cwd          = undef,
) {

  if $virtualenv == 'system' and ($owner != 'root' or $group != 'root') {
    fail('python::pip: root user must be used when virtualenv is system')
  }

  $rootdir = $virtualenv ? {
    'system' => '/',
    default  => $virtualenv,
  }

  $pip_env = $virtualenv ? {
    'system' => 'pip',
    default  => "${virtualenv}/bin/pip",
  }

  $proxy_flag = $proxy ? {
    false    => '',
    default  => "--proxy=${proxy}",
  }

  $src_flag = $src ? {
    false   => '',
    default => "--src=${src}",
  }

  # This will ensure multiple python::virtualenv definitions can share the
  # the same requirements file.
  if !defined(File[$requirements]) {
    file { $requirements:
      ensure  => present,
      mode    => '0644',
      owner   => $owner,
      group   => $group,
      audit   => content,
      replace => false,
      content => '# Puppet will install and/or update pip packages listed here',
    }
  }

  exec { "python_requirements${name}":
    provider    => shell,
    command     => "${pip_env} --log ${rootdir}/pip.log install ${proxy_flag} ${src_flag} -r ${requirements}",
    refreshonly => !$forceupdate,
    timeout     => 1800,
    cwd         => $cwd,
    user        => $owner,
    subscribe   => File[$requirements],
    environment => $environment,
    path        => ['/usr/local/bin','/usr/bin','/bin', '/usr/sbin'],
  }

}
