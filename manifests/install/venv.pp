# @summary Installs python virtualenv packages
class python::install::venv {
  include python

  # Main python package bundle venv on some operating systems
  unless $facts['os']['family'] in ['Archlinux', 'RedHat', 'FreeBSD'] {
    package { 'python-venv':
      ensure  => $python::venv,
      name    => "${python::install::python}-venv",
      require => Package['python'],
    }
  }
}
