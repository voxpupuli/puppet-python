# == Class: python
#
# Installs and manages python, python-dev, python-virtualenv and Gunicorn.
#
# === Parameters
#
# [*ensure*]
#  Desired installation state for the Python package. Valid options are absent,
#  present and latest. Default: present
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
#  Desired installation state for python-pip. Boolean values are deprecated.
#  Default: present
#  Allowed values: 'absent', 'present', 'latest'
#
# [*dev*]
#  Desired installation state for python-dev. Boolean values are deprecated.
#  Default: absent
#  Allowed values: 'absent', 'present', 'latest'
#
# [*virtualenv*]
#  Desired installation state for python-virtualenv. Boolean values are
#  deprecated. Default: absent
#  Allowed values: 'absent', 'present', 'latest
#
# [*gunicorn*]
#  Desired installation state for Gunicorn. Boolean values are deprecated.
#  Default: absent
#  Allowed values: 'absent', 'present', 'latest'
#
# [*manage_gunicorn*]
#  Allow Installation / Removal of Gunicorn. Default: true
#
# [*provider*]
#  What provider to use for installation of the packages, except gunicorn and
#  Python itself. Default: system default provider
#  Allowed values: 'pip'
#
# [*use_epel*]
#  Boolean to determine if the epel class is used. Default: true
#
# === Examples
#
# class { 'python':
#   version    => 'system',
#   pip        => 'present',
#   dev        => 'present',
#   virtualenv => 'present',
#   gunicorn   => 'present',
# }
#
# === Authors
#
# Sergey Stankevich
# Garrett Honeycutt <code@garretthoneycutt.com>
#

class python (
  Enum['absent', 'present', 'latest'] $ensure     = $python::params::ensure,
  $version                                        = $python::params::version,
  Enum['absent', 'present', 'latest'] $pip        = $python::params::pip,
  $dev                                            = $python::params::dev,
  Enum['absent', 'present', 'latest'] $virtualenv = $python::params::virtualenv,
  Enum['absent', 'present', 'latest'] $gunicorn   = $python::params::gunicorn,
  Boolean $manage_gunicorn                        = $python::params::manage_gunicorn,
  $gunicorn_package_name                          = $python::params::gunicorn_package_name,
  Optional[Enum['pip', 'scl', 'rhscl', '']] $provider = $python::params::provider,
  $valid_versions                                 = $python::params::valid_versions,
  Hash $python_pips                               = { },
  Hash $python_virtualenvs                        = { },
  Hash $python_pyvenvs                            = { },
  Hash $python_requirements                       = { },
  Hash $python_dotfiles                           = { },
  Boolean $use_epel                               = $python::params::use_epel,
  $rhscl_use_public_repository                    = $python::params::rhscl_use_public_repository,
) inherits python::params {

  $exec_prefix = $provider ? {
    'scl'   => "/usr/bin/scl enable ${version} -- ",
    'rhscl' => "/usr/bin/scl enable ${version} -- ",
    default => '',
  }

  #$allowed_versions = concat(['system', 'pypy'], $valid_versions)
  #unless $version =~ Enum[allowed_versions] {
    #fail("version needs to be within${allowed_versions}")
    #}
  validate_re($version, concat(['system', 'pypy'], $valid_versions))

  # Module compatibility check
  $compatible = [ 'Debian', 'RedHat', 'Suse', 'Gentoo' ]
  if ! ($facts['os']['family'] in $compatible) {
    fail("Module is not compatible with ${::operatingsystem}")
  }

  # Anchor pattern to contain dependencies
  anchor { 'python::begin': }
  -> class { 'python::install': }
  -> class { 'python::config': }
  -> anchor { 'python::end': }

  # Allow hiera configuration of python resources
  create_resources('python::pip', $python_pips)
  create_resources('python::pyvenv', $python_pyvenvs)
  create_resources('python::virtualenv', $python_virtualenvs)
  create_resources('python::requirements', $python_requirements)
  create_resources('python::dotfile', $python_dotfiles)

}
