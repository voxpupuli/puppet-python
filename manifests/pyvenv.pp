#
# @summary Create a Python3 virtualenv using pyvenv.
#
# @param ensure
# @param version Python version to use. Default: system default
# @param systempkgs Copy system site-packages into virtualenv
# @param venv_dir  Directory to install virtualenv to
# @param owner The owner of the virtualenv being manipulated
# @param group The group relating to the virtualenv being manipulated
# @param mode  Optionally specify directory mode
# @param path Specifies the PATH variable. Default: [ '/bin', '/usr/bin', '/usr/sbin' ]
# @param environment Optionally specify environment variables for pyvenv
#
# @example
#   python::venv { '/var/www/project1':
#     ensure       => present,
#     version      => 'system',
#     systempkgs   => true,
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

  include ::python

  if $ensure == 'present' {

    $virtualenv_cmd = $version ? {
      'system' => "${python::exec_prefix}pyvenv",
      default  => "${python::exec_prefix}pyvenv-${version}",
    }

    $_path = $::python::provider ? {
      'anaconda' => concat(["${::python::anaconda_install_path}/bin"], $path),
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

    exec { "python_virtualenv_${venv_dir}":
      command     => "${virtualenv_cmd} --clear ${system_pkgs_flag} ${venv_dir}",
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
