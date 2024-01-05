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
# @param prompt Optionally specify the virtualenv prompt (python >= 3.6)
# @param index Optionally specify an index location from where pip and setuptools should be installed
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
  Python::Package::Ensure     $ensure      = present,
  Python::Version             $version     = 'system',
  Boolean                     $systempkgs  = false,
  Stdlib::Absolutepath        $venv_dir    = $name,
  String[1]                   $owner       = 'root',
  String[1]                   $group       = 'root',
  Stdlib::Filemode            $mode        = '0755',
  Array[Stdlib::Absolutepath] $path        = ['/bin', '/usr/bin', '/usr/sbin', '/usr/local/bin',],
  Array                       $environment = [],
  Optional[String[1]]         $prompt      = undef,
  Python::Venv::PipVersion    $pip_version = 'latest',
  Optional[String[1]]         $index       = undef,
) {
  include python

  if $ensure == 'present' {
    $python_version = $version ? {
      'system' => $facts['python3_version'],
      default  => $version,
    }

    $python_version_parts      = split($python_version, '[.]')
    $normalized_python_version = sprintf('%s.%s', $python_version_parts[0], $python_version_parts[1])

    # pyvenv is deprecated since 3.6 and will be removed in 3.8
    if versioncmp($normalized_python_version, '3.6') >=0 {
      $virtualenv_cmd = "${python::exec_prefix}python${normalized_python_version} -m venv"
    } else {
      $virtualenv_cmd = "${python::exec_prefix}pyvenv-${normalized_python_version}"
    }

    $_path = $python::provider ? {
      'anaconda' => concat(["${python::anaconda_install_path}/bin"], $path),
      default    => $path,
    }

    if $systempkgs == true {
      $system_pkgs_flag = '--system-site-packages'
    } else {
      $system_pkgs_flag = ''
    }

    if versioncmp($normalized_python_version, '3.6') >=0 and $prompt {
      $prompt_arg = "--prompt ${shell_escape($prompt)}"
    } else {
      $prompt_arg = ''
    }

    file { $venv_dir:
      ensure  => directory,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      require => Class['python::install'],
    }

    $pip_cmd = "${python::exec_prefix}${venv_dir}/bin/pip"

    $index_config = $index ? {
      undef   => '',
      default => "-i ${shell_escape($index)}"
    }

    $pip_upgrade = ($pip_version != 'latest') ? {
      true  => "--upgrade 'pip ${pip_version}'",
      false => '--upgrade pip',
    }

    exec { "python_virtualenv_${venv_dir}":
      command     => "${virtualenv_cmd} --clear ${system_pkgs_flag} ${prompt_arg} ${venv_dir} && ${pip_cmd} --log ${venv_dir}/pip.log install ${index_config} ${pip_upgrade} && ${pip_cmd} --log ${venv_dir}/pip.log install ${index_config} --upgrade setuptools",
      user        => $owner,
      creates     => "${venv_dir}/bin/activate",
      path        => $_path,
      cwd         => '/tmp',
      environment => $environment,
      timeout     => 600,
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
