# @summary Installs python virtualenv packages
class python::install::venv {
  include python

  ##
  ## CentOS has no extra package for venv
  ##
  unless $facts['os']['family'] == 'RedHat' {
    package { 'python-venv':
      ensure  => $python::venv,
      name    => "${python::install::python}-venv",
      require => Package['python'],
    }
  }
}
