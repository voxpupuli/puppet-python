# == Class: python
#
# Installs and manages python, python-dev, python-virtualenv and Gunicorn.
#
# === Parameters
#
# [*version*]
#  Python version to install. Beware that valid values for this differ a) by
#  the provider you choose and b) by the osfamily/operatingsystem you are using.
#  Default: system default
#  Allowed values:
#   - provider == pip: everything pip allows as a version after the 'python=='
#   - else: 'system', 'pypy', 3/3.3/...
#      - Be aware that 'system' usually means python 2.X.
#      - 'pypy' actually lets us use pypy as python.
#      - 3/3.3/... means you are going to install the python3/python3.3/...
#        package, if available on your osfamily.
#
# [*pip*]
#  Install python-pip. Default: true
#
# [*dev*]
#  Install python-dev. Default: false
#
# [*virtualenv*]
#  Install python-virtualenv. Default: false, also accepts 'pip' which will
#  install latest virtualenv from pip rather than package manager
#
# [*gunicorn*]
#  Install Gunicorn. Default: false
#
# [*manage_gunicorn*]
#  Allow Installation / Removal of Gunicorn. Default: true
#
# [*provider*]
#  What provider to use for installation of the packages, except gunicorn.
#  Default: system default provider
#  Allowed values: 'pip'
#
# === Examples
#
# class { 'python':
#   version    => 'system',
#   pip        => true,
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
  $version         = 'system',
  $pip             = true,
  $dev             = false,
  $virtualenv      = false,
  $gunicorn        = false,
  $manage_gunicorn = true,
  $provider        = undef
) {

  # validate inputs
  if $provider != undef {
    validate_re($provider, ['^pip$'], 'Only "pip" is a valid provider besides the system default.')
  }

  if $provider == 'pip' {
    validate_re($version, ['^(2\.[4-7]\.\d|3\.\d\.\d)$','^system$'])
  # this will only be checked if not pip, every other string would be rejected by provider check
  } else {
    validate_re($version, concat(['system', 'pypy'], $::python::install::valid_versions))
  }

  validate_bool($pip)
  validate_bool($dev)
  validate_bool($virtualenv)
  validate_bool($gunicorn)
  validate_bool($manage_gunicorn)

  # Module compatibility check
  $compatible = [ 'Debian', 'RedHat']
  if ! ($::osfamily in $compatible) {
    fail("Module is not compatible with ${::operatingsystem}")
  }

  # Anchor pattern to contain dependencies
  anchor { 'python::begin': } ->
  class { 'python::install': } ->
  class { 'python::config': } ->
  anchor { 'python::end': }

}
