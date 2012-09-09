# == Class: python
#
# Installs and manages python, python-dev, python-virtualenv and Gunicorn.
#
# === Parameters
#
# [*version*]
#  Python version to install. Default: system default
#
# [*dev*]
#  Install python-dev. Default: false
#
# [*virtualenv*]
#  Install python-virtualenv. Default: false
#
# [*gunicorn*]
#  Install Gunicorn. Default: false
#
# === Examples
#
# class { 'python':
#   version    => 'system',
#   dev        => true,
#   virtualenv => true,
#   gunicorn   => true,
# }
#
# === Authors
#
# Sergey Stankevich
#
class python (
  $version    = 'system',
  $dev        = false,
  $virtualenv = false,
  $gunicorn   = false
) {

  # Module compatibility check
  $compatible = [ 'Debian', 'Ubuntu' ]
  if ! ($::operatingsystem in $compatible) {
    fail("Module is not compatible with ${::operatingsystem}")
  }

  Class['python::install'] -> Class['python::config']

  include python::install
  include python::config

}
