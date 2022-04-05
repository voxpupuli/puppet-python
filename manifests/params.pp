# @api private
# @summary The python Module default configuration settings.
#
# The python Module default configuration settings.
#
class python::params {
  # Module compatibility check
  unless $facts['os']['family'] in ['AIX', 'Debian', 'FreeBSD', 'Gentoo', 'RedHat', 'Suse'] {
    fail("Module is not compatible with ${facts['os']['name']}")
  }

  $ensure                      = 'present'
  $pip                         = 'present'
  $dev                         = 'absent'
  $venv                        = 'absent'
  $gunicorn                    = 'absent'
  $manage_gunicorn             = true
  $manage_python_package       = true
  $manage_venv_package         = true
  $manage_pip_package          = true
  $provider                    = undef
  $valid_versions              = undef
  $manage_scl                  = true
  $rhscl_use_public_repository = true
  $anaconda_installer_url      = 'https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh'
  $anaconda_install_path       = '/opt/python'

  if $facts['os']['family'] == 'RedHat' and $facts['os']['name'] != 'Fedora' {
    $use_epel = true
  } else {
    $use_epel = false
  }

  $group = $facts['os']['family'] ? {
    'AIX' => 'system',
    default => 'root'
  }

  $pip_lookup_path = $facts['os']['family'] ? {
    'AIX'   => ['/bin', '/usr/bin', '/usr/local/bin', '/opt/freeware/bin/',],
    default => ['/bin', '/usr/bin', '/usr/local/bin',]
  }

  $gunicorn_package_name = $facts['os']['family'] ? {
    'RedHat' => $facts['os']['release']['major'] ? {
      '8' => 'python3-gunicorn',
      default => 'python-gunicorn',
    },
    default  => 'gunicorn',
  }
}
