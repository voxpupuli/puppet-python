#
# @summary Installs and manages Python packages from requirements file.
#
# @param requirements Path to the requirements file.
# @param virtualenv virtualenv to run pip in.
# @param pip_provider version of pip you wish to use.
# @param owner The owner of the virtualenv being manipulated.
# @param group  The group relating to the virtualenv being manipulated.
# @param proxy Proxy server to use for outbound connections.
# @param src Pip --src parameter to; if the requirements file contains --editable resources, this parameter specifies where they will be installed. See the pip documentation for more.
# @param environment Additional environment variables required to install the packages.
# @param forceupdate Run a pip install requirements even if we don't receive an event from the requirements file - Useful for when the requirements file is written as part of a resource other than file (E.g vcsrepo)
# @param cwd  The directory from which to run the "pip install" command.
# @param extra_pip_args Extra arguments to pass to pip after the requirements file
# @param manage_requirements Create the requirements file if it doesn't exist.
# @param fix_requirements_owner Change owner and group of requirements file.
# @param log_dir Log directory.
# @param timeout The maximum time in seconds the "pip install" command should take.
#
# @example install pip requirements from /var/www/project1/requirements.txt
#   python::requirements { '/var/www/project1/requirements.txt' :
#     virtualenv => '/var/www/project1',
#     proxy      => 'http://proxy.domain.com:3128',
#     owner      => 'appuser',
#     group      => 'apps',
#   }
#
define python::requirements (
  $requirements                       = $name,
  $virtualenv                         = 'system',
  Enum['pip', 'pip3'] $pip_provider   = 'pip',
  $owner                              = 'root',
  $group                              = 'root',
  Optional[Stdlib::HTTPUrl] $proxy    = undef,
  $src                                = false,
  $environment                        = [],
  $forceupdate                        = false,
  $cwd                                = undef,
  $extra_pip_args                     = '',
  $manage_requirements                = true,
  $fix_requirements_owner             = true,
  $log_dir                            = '/tmp',
  $timeout                            = 1800,
) {

  include python

  if $virtualenv == 'system' and ($owner != 'root' or $group != 'root') {
    fail('python::pip: root user must be used when virtualenv is system')
  }

  if $fix_requirements_owner {
    $owner_real = $owner
    $group_real = $group
  } else {
    $owner_real = undef
    $group_real = undef
  }

  $log = $virtualenv ? {
    'system' => $log_dir,
    default  => $virtualenv,
  }

  $pip_env = $virtualenv ? {
    'system' => "${python::exec_prefix} ${pip_provider}",
    default  => "${python::exec_prefix} ${virtualenv}/bin/${pip_provider}",
  }

  $proxy_flag = $proxy ? {
    undef   => '',
    default => "--proxy=${proxy}",
  }

  $src_flag = $src ? {
    false   => '',
    default => "--src=${src}",
  }

  # This will ensure multiple python::virtualenv definitions can share the
  # the same requirements file.
  if !defined(File[$requirements]) and $manage_requirements == true {
    file { $requirements:
      ensure  => present,
      mode    => '0644',
      owner   => $owner_real,
      group   => $group_real,
      audit   => content,
      replace => false,
      content => '# Puppet will install and/or update pip packages listed here',
    }
    $local_subscribe = File[$requirements]
  } else {
    $local_subscribe = undef
  }

  exec { "python_requirements${name}":
    provider    => shell,
    command     => "${pip_env} --log ${log}/pip.log install ${proxy_flag} ${src_flag} -r ${requirements} ${extra_pip_args}",
    refreshonly => !$forceupdate,
    timeout     => $timeout,
    cwd         => $cwd,
    user        => $owner,
    subscribe   => $local_subscribe,
    environment => $environment,
  }
}
