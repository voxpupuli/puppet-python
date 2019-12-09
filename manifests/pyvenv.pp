#
# @summary Create a Python3 virtualenv using pyvenv.
#
# @param ensure
# @param version Python version to use.
# @param systempkgs Copy system site-packages into virtualenv
# @param venv_dir  Directory to install virtualenv to
# @param owner The owner of the virtualenv being manipulated
# @param group The group relating to the virtualenv being manipulated
# @param mode  Optionally specify directory mode
# @param path Specifies the PATH variable.
# @param environment Optionally specify environment variables for pyvenv
#
# @example
#   python::pyvenv { '/var/www/project1' :
#     ensure       => present,
#     version      => 'system',
#     systempkgs   => true,
#     venv_dir     => '/home/appuser/virtualenvs',
#     owner        => 'appuser',
#     group        => 'apps',
#   }
#
define python::pyvenv (
  $ensure           = present,
  $version          = 'system',
  $systempkgs       = false,
  $venv_dir         = $name,
  $owner            = 'root',
  $group            = 'root',
  $mode             = '0755',
  $path             = [ '/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
  $environment      = [],
) {
  include python

  if $ensure == 'present' {
    $python_version = $version ? {
      'system' => $facts['python3_version'],
      default  => $version,
    }

    $python_version_parts = split($python_version, '[.]')
    $normalized_python_version = sprintf('%s.%s', $python_version_parts[0], $python_version_parts[1])

    # Debian splits the venv module into a seperate package
    if ( $facts['os']['family'] == 'Debian'){
      $python3_venv_package="python${normalized_python_version}-venv"
      case $facts['os']['distro']['codename'] {
        'xenial','bionic','cosmic','disco',
        'jessie','stretch','buster': {
          ensure_packages ($python3_venv_package)
          Package[$python3_venv_package] -> File[$venv_dir]
        }
        default: {}
      }
    }

    # pyvenv is deprecated since 3.6 and will be removed in 3.8
    if (versioncmp($normalized_python_version, '3.6') >=0) {
      $virtualenv_cmd = "${python::exec_prefix}python${normalized_python_version} -m venv"
    } else {
      $virtualenv_cmd = "${python::exec_prefix}pyvenv-${normalized_python_version}"
    }

    $_path = $python::provider ? {
      'anaconda' => concat(["${python::anaconda_install_path}/bin"], $path),
      default    => $path,
    }

    if ( $systempkgs == true ) {
      $system_pkgs_flag = '--system-site-packages'
    } else {
      $system_pkgs_flag = ''
    }

    file { $venv_dir:
      ensure => directory,
      owner  => $owner,
      group  => $group,
      mode   => $mode,
    }

    $pip_cmd   = "${python::exec_prefix}${venv_dir}/bin/pip"

    exec { "python_virtualenv_${venv_dir}":
      command     => "${virtualenv_cmd} --clear ${system_pkgs_flag} ${venv_dir} && ${pip_cmd} --log ${venv_dir}/pip.log install --upgrade pip && ${pip_cmd} --log ${venv_dir}/pip.log install --upgrade setuptools",
      user        => $owner,
      creates     => "${venv_dir}/bin/activate",
      path        => $_path,
      cwd         => '/tmp',
      environment => $environment,
      unless      => "grep '^[\\t ]*VIRTUAL_ENV=[\\\\'\\\"]*${venv_dir}[\\\"\\\\'][\\t ]*$' ${venv_dir}/bin/activate", #Unless activate exists and VIRTUAL_ENV is correct we re-create the virtualenv
      require     => File[$venv_dir],
    }
  } elsif $ensure == 'absent' {
    file { $venv_dir:
      ensure  => absent,
      force   => true,
      recurse => true,
      purge   => true,
    }
  } else {
    fail( "Illegal ensure value: ${ensure}. Expected (present or absent)")
  }
}
