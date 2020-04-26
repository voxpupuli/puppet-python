# @api private
# @summary The python Module default configuration settings.
#
# The python Module default configuration settings.
#
class python::params {
  $ensure                    = 'present'
  $version                   = 'system'
  $pip                       = 'present'
  $dev                       = 'absent'
  $virtualenv                = 'absent'
  $gunicorn                  = 'absent'
  $manage_gunicorn           = true
  $manage_python_package     = true
  $manage_virtualenv_package = true
  $manage_pip_package        = true
  $provider                  = undef
  $valid_versions            = undef
  $manage_scl                = true

  if $facts['os']['family'] == 'RedHat' {
    if $facts['os']['name'] != 'Fedora' {
      $use_epel           = true
    } else {
      $use_epel           = false
    }
  } else {
    $use_epel             = false
  }

  $group = $facts['os']['family'] ? {
    'AIX' => 'system',
    default => 'root'
  }

  $pip_lookup_path = $facts['os']['family'] ? {
    'AIX' => [ '/bin', '/usr/bin', '/usr/local/bin', '/opt/freeware/bin/' ],
    default => [ '/bin', '/usr/bin', '/usr/local/bin' ]
  }

  $gunicorn_package_name = $facts['os']['family'] ? {
    'RedHat' => 'python-gunicorn',
    default  => 'gunicorn',
  }

  $rhscl_use_public_repository = true

  $anaconda_installer_url = 'https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh'
  $anaconda_install_path = '/opt/python'
}
