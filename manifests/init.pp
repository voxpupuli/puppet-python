# @summary Installs and manages python, python-dev and gunicorn.
#
# @param ensure Desired installation state for the Python package.
# @param version Python version to install. Beware that valid values for this differ a) by the provider you choose and b) by the osfamily/operatingsystem you are using.
#  Allowed values:
#   - provider == pip: everything pip allows as a version after the 'python=='
#   - else: 'system', 'pypy', 3/3.3/...
#      - Be aware that 'system' usually means python 2.X.
#      - 'pypy' actually lets us use pypy as python.
#      - 3/3.3/... means you are going to install the python3/python3.3/...
#        package, if available on your osfamily.
# @param pip Desired installation state for the python-pip package.
# @param dev Desired installation state for the python-dev package.
# @param gunicorn Desired installation state for Gunicorn.
# @param manage_gunicorn Allow Installation / Removal of Gunicorn.
# @param provider What provider to use for installation of the packages, except gunicorn and Python itself.
# @param use_epel to determine if the epel class is used.
# @param manage_scl Whether to manage core SCL packages or not.
# @param umask The default umask for invoked exec calls.
# @param manage_gunicorn manage the state for package gunicorn
# @param manage_python_package manage the state for package python
# @param manage_venv_package manage the state for package venv
# @param manage_pip_package manage the state for package pip
#
# @example install python from system python
#   class { 'python':
#     version    => 'system',
#     pip        => 'present',
#     dev        => 'present',
#     gunicorn   => 'present',
#   }
# @example install python3 from scl repo
#   class { 'python' :
#     ensure      => 'present',
#     version     => 'rh-python36-python',
#     dev         => 'present',
#   }
#
class python (
  Python::Version            $version,
  Boolean                    $manage_venv_package,
  Boolean                    $manage_pip_package,
  String[1]                  $gunicorn_package_name,
  Boolean                    $use_epel,
  Python::Package::Ensure    $ensure                      = 'present',
  Python::Package::Ensure    $pip                         = 'present',
  Python::Package::Ensure    $dev                         = 'absent',
  Python::Package::Ensure    $venv                        = 'absent',
  Python::Package::Ensure    $gunicorn                    = 'absent',
  Boolean                    $manage_gunicorn             = true,
  Boolean                    $manage_python_package       = true,
  Optional[Python::Provider] $provider                    = undef,
  Hash                       $python_pips                 = {},
  Hash                       $python_pyvenvs              = {},
  Hash                       $python_requirements         = {},
  Hash                       $python_dotfiles             = {},
  Boolean                    $rhscl_use_public_repository = true,
  Stdlib::Httpurl            $anaconda_installer_url      = 'https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh',
  Stdlib::Absolutepath       $anaconda_install_path       = '/opt/python',
  Boolean                    $manage_scl                  = true,
  Optional[Python::Umask]    $umask                       = undef,
) {
  $exec_prefix = $provider ? {
    'scl'   => "/usr/bin/scl enable ${version} -- ",
    'rhscl' => "/usr/bin/scl enable ${version} -- ",
    default => '',
  }

  contain python::install
  contain python::config

  Class['python::install']
  -> Class['python::config']

  # Set default umask.
  exec { default:
    umask => $umask,
  }

  # Allow hiera configuration of python resources
  create_resources('python::pip', $python_pips)
  create_resources('python::pyvenv', $python_pyvenvs)
  create_resources('python::requirements', $python_requirements)
  create_resources('python::dotfile', $python_dotfiles)
}
