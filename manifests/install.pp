# == Define: python::install
#
# Installs core python packages
#
# === Examples
#
# include python::install
#
# === Authors
#
# Sergey Stankevich
# Ashley Penney
# Fotis Gimian
#

class python::install {

  $python = $::python::version ? {
    'system' => 'python',
    'pypy'   => 'pypy',
    default  => "python${python::version}",
  }

  $pythondev = $::osfamily ? {
    'RedHat' => "${python}-devel",
    'Debian' => "${python}-dev",
    'Suse'   => "${python}-devel"
  }

  # pip version: use only for installation via os package manager!
  if $::python::version =~ /^3/ {
    $pip = 'python3-pip'
  } else {
    $pip = 'python-pip'
  }

  $dev_ensure = $python::dev ? {
    true    => present,
    default => absent,
  }

  $pip_ensure = $python::pip ? {
    true    => present,
    default => absent,
  }

  $venv_ensure = $python::virtualenv ? {
    true    => present,
    default => absent,
  }

  # Install latest from pip if pip is the provider
  case $python::provider {
    pip: {
      package { 'virtualenv': ensure => latest, provider => pip }
      package { 'pip': ensure => latest, provider => pip }
      package { "python==${python::version}": ensure => latest, provider => pip }
    }
    default: {
      if $::osfamily == 'RedHat' {
        if $pip_ensure == present {
          include 'epel'
          Class['epel'] -> Package[$pip]
        }
        if ($venv_ensure == present) and ($::operatingsystemrelease =~ /^6/) {
          include 'epel'
          Class['epel'] -> Package['python-virtualenv']
        }
      }
      package { 'python-virtualenv': ensure => $venv_ensure }
      package { $pip: ensure => $pip_ensure }
      package { $pythondev: ensure => $dev_ensure }
      package { $python: ensure => present }
    }
  }

  if $python::manage_gunicorn {
    $gunicorn_ensure = $python::gunicorn ? {
      true    => present,
      default => absent,
    }
    package { 'gunicorn': ensure => $gunicorn_ensure }
  }

}
