# @api private
# @summary The python Module default configuration settings.
#
# The python Module default configuration settings.
#
class python::params {
  # Module compatibility check
  unless $facts['os']['family'] in ['AIX', 'Debian', 'FreeBSD', 'Gentoo', 'RedHat', 'Suse', 'Archlinux'] {
    fail("Module is not compatible with ${facts['os']['name']}")
  }

  if $facts['os']['family'] == 'RedHat' and $facts['os']['name'] != 'Fedora' {
    $use_epel = true
  } else {
    $use_epel = false
  }

  $group = $facts['os']['family'] ? {
    'AIX'     => 'system',
    'FreeBSD' => 'wheel',
    default   => 'root'
  }

  $pip_lookup_path = $facts['os']['family'] ? {
    'AIX'   => ['/bin', '/usr/bin', '/usr/local/bin', '/opt/freeware/bin/',],
    default => ['/bin', '/usr/bin', '/usr/local/bin',]
  }

  $gunicorn_package_name = $facts['os']['family'] ? {
    'RedHat' => $facts['os']['release']['major'] ? {
      '7'     => 'python-gunicorn',
      default => 'python3-gunicorn',
    },
    default  => 'gunicorn',
  }

  $manage_pip_package = $facts['os']['family'] ? {
    'Archlinux' => false,
    default     => true,
  }
  $manage_venv_package = $facts['os']['family'] ? {
    'Archlinux' => false,
    'FreeBSD'   => false,
    'RedHat'    => false,
    default     => true,
  }
}
