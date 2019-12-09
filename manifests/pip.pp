# @summary Installs and manages packages from pip.
#
# @param name must be unique
# @param pkgname the name of the package.
# @param ensure Require pip to be available.
# @param virtualenv virtualenv to run pip in.
# @param pip_provider version of pip you wish to use.
# @param url URL to install from.
# @param owner The owner of the virtualenv being manipulated.
# @param group The group of the virtualenv being manipulated.
# @param index Base URL of Python package index.
# @param proxy Proxy server to use for outbound connections.
# @param editable If true the package is installed as an editable resource.
# @param environment Additional environment variables required to install the packages.
# @param extras Extra features provided by the package which should be installed.
# @param timeout The maximum time in seconds the "pip install" command should take.
# @param install_args Any additional installation arguments that will be supplied when running pip install.
# @param uninstall_args Any additional arguments that will be supplied when running pip uninstall.
# @param log_dir Log directory
# @param egg The egg name to use
# @param umask
#
# @example Install Flask to /var/www/project1 using a proxy
#   python::pip { 'flask':
#     virtualenv => '/var/www/project1',
#     proxy      => 'http://proxy.domain.com:3128',
#     index      => 'http://www.example.com/simple/',
#   }
# @example Install cx_Oracle with pip
#   python::pip { 'cx_Oracle' :
#     pkgname       => 'cx_Oracle',
#     ensure        => '5.1.2',
#     virtualenv    => '/var/www/project1',
#     owner         => 'appuser',
#     proxy         => 'http://proxy.domain.com:3128',
#     environment   => 'ORACLE_HOME=/usr/lib/oracle/11.2/client64',
#     install_args  => '-e',
#     timeout       => 1800,
#   }
# @example Install Requests with pip3
#   python::pip { 'requests' :
#     ensure        => 'present',
#     pkgname       => 'requests',
#     pip_provider  => 'pip3',
#     virtualenv    => '/var/www/project1',
#     owner         => 'root',
#     timeout       => 1800
#   }
#
define python::pip (
  String $pkgname                                            = $name,
  Variant[Enum[present, absent, latest], String[1]] $ensure  = present,
  Variant[Enum['system'], Stdlib::Absolutepath] $virtualenv  = 'system',
  String[1] $pip_provider                                    = 'pip',
  Variant[Boolean, String] $url                              = false,
  String[1] $owner                                           = 'root',
  $group                                                     = getvar('python::params::group'),
  $umask                                                     = undef,
  $index                                                     = false,
  Optional[Stdlib::HTTPUrl] $proxy                           = undef,
  $egg                                                       = false,
  Boolean $editable                                          = false,
  $environment                                               = [],
  $extras                                                    = [],
  String $install_args                                       = '',
  String $uninstall_args                                     = '',
  Numeric $timeout                                           = 1800,
  String[1] $log_dir                                         = '/tmp',
  Array[String] $path                                        = ['/usr/local/bin','/usr/bin','/bin', '/usr/sbin'],
  String[1] $exec_provider                                   = 'shell',
){
  $python_provider = getparam(Class['python'], 'provider')
  $python_version  = getparam(Class['python'], 'version')

  if $virtualenv != 'system' {
    Python::Pyvenv <| |> -> Python::Pip[$name]
    Python::Virtualenv <| |> -> Python::Pip[$name]
  }

  # Get SCL exec prefix
  # NB: this will not work if you are running puppet from scl enabled shell
  $exec_prefix = $python_provider ? {
    'scl'   => "scl enable ${python_version} -- ",
    'rhscl' => "scl enable ${python_version} -- ",
    default => '',
  }

  $_path = $python_provider ? {
    'anaconda' => concat(["${python::anaconda_install_path}/bin"], $path),
    default    => $path,
  }

  # Parameter validation
  if $virtualenv == 'system' and $owner != 'root' {
    fail('python::pip: root user must be used when virtualenv is system')
  }

  $cwd = $virtualenv ? {
    'system' => '/',
    default  => $virtualenv,
  }

  $log = $virtualenv ? {
    'system' => $log_dir,
    default  => $virtualenv,
  }

  $pip_env = $virtualenv ? {
    'system' => "${exec_prefix}${pip_provider}",
    default  => "${exec_prefix}${virtualenv}/bin/${pip_provider}",
  }

  $pypi_index = $index ? {
      false   => '',
      default => "--index-url=${index}",
    }

  $proxy_flag = $proxy ? {
    undef    => '',
    default  => "--proxy=${proxy}",
  }

  if $editable == true {
    $install_editable = ' -e '
  }
  else {
    $install_editable = ''
  }

  #TODO: Do more robust argument checking, but below is a start
  if ($ensure == absent) and ($install_args != '') {
    fail('python::pip cannot provide install_args with ensure => absent')
  }

  if ($ensure == present) and ($uninstall_args != '') {
    fail('python::pip cannot provide uninstall_args with ensure => present')
  }

  if $pkgname =~ /==/ {
    $parts = split($pkgname, '==')
    $real_pkgname = $parts[0]
    $_ensure = $ensure ? {
      'absent' => 'absent',
      default => $parts[1],
    }
  } else {
    $real_pkgname = $pkgname
    $_ensure = $ensure
  }

  # Check if searching by explicit version.
  if $_ensure =~ /^((19|20)[0-9][0-9]-(0[1-9]|1[1-2])-([0-2][1-9]|3[0-1])|[0-9]+\.\w+\+?\w*(\.\w+)*)$/ {
    $grep_regex = "^${real_pkgname}[[:space:]]\\+(\\?${_ensure}\\()$\\|$\\|, \\|[[:space:]]\\)"
  } else {
    $grep_regex = "^${real_pkgname}[[:space:]].*$"
  }

  $extras_string = empty($extras) ? {
    true    => '',
    default => sprintf('[%s]',join($extras,',')),
  }

  $egg_name = $egg ? {
    false   => "${real_pkgname}${extras_string}",
    default => $egg
  }

  $source = $url ? {
    false               => "${real_pkgname}${extras_string}",
    /^(\/|[a-zA-Z]\:)/  => "'${url}'",
    /^(git\+|hg\+|bzr\+|svn\+)(http|https|ssh|svn|sftp|ftp|lp|git)(:\/\/).+$/ => "'${url}'",
    default             => "'${url}#egg=${egg_name}'",
  }

  $pip_install = "${pip_env} --log ${log}/pip.log install"
  $pip_common_args = "${pypi_index} ${proxy_flag} ${install_args} ${install_editable} ${source}"

  # Explicit version out of VCS when PIP supported URL is provided
  if $source =~ /^'(git\+|hg\+|bzr\+|svn\+)(http|https|ssh|svn|sftp|ftp|lp|git)(:\/\/).+'$/ {
    if $_ensure != present and $_ensure != latest {
      $command = "${pip_install} ${install_args} ${pip_common_args}@${_ensure}#egg=${egg_name}"
      $unless_command = "${pip_env} list | grep -i -e '${grep_regex}'"
    } else {
      $command = "${pip_install} ${install_args} ${pip_common_args}"
      $unless_command = "${pip_env} list | grep -i -e '${grep_regex}'"
    }
  } else {
    case $_ensure {
      /^((19|20)[0-9][0-9]-(0[1-9]|1[1-2])-([0-2][1-9]|3[0-1])|[0-9]+\.\w+\+?\w*(\.\w+)*)$/: {
        # Version formats as per http://guide.python-distribute.org/specification.html#standard-versioning-schemes
        # Explicit version.
        $command = "${pip_install} ${install_args} ${pip_common_args}==${_ensure}"
        $unless_command = "${pip_env} list | grep -i -e '${grep_regex}'"
      }

      'present': {
        # Whatever version is available.
        $command = "${pip_install} ${pip_common_args}"
        $unless_command = "${pip_env} list | grep -i -e '${grep_regex}'"
      }

      'latest': {
        # Unfortunately this is the smartest way of getting the latest available package version with pip as of now
        # Note: we DO need to repeat ourselves with "from version" in both grep and sed as on some systems pip returns
        # more than one line with paretheses.
        $latest_version = join(["${pip_install} ${pypi_index} ${proxy_flag} ${install_args} ${install_editable} ${real_pkgname}==notreallyaversion 2>&1",
                                ' | grep -oP "\(from versions: .*\)" | sed -E "s/\(from versions: (.*?, )*(.*)\)/\2/g"',
                                ' | tr -d "[:space:]"'])

        # Packages with underscores in their names are listed with dashes in their place in `pip freeze` output
        $pkgname_with_dashes = regsubst($real_pkgname, '_', '-', 'G')
        $grep_regex_pkgname_with_dashes = "^${pkgname_with_dashes}=="
        $installed_version = join(["${pip_env} freeze --all",
                                  " | grep -i -e ${grep_regex_pkgname_with_dashes} | cut -d= -f3",
                                  " | tr -d '[:space:]'"])

        $command = "${pip_install} --upgrade ${pip_common_args}"
        $unless_command = "[ \$(${latest_version}) = \$(${installed_version}) ]"
      }

      default: {
        # Anti-action, uninstall.
        $command = "echo y | ${pip_env} uninstall ${uninstall_args} ${proxy_flag} ${name}"
        $unless_command = "! ${pip_env} list | grep -i -e '${grep_regex}'"
      }
    }
  }

  $pip_installer = ($ensure == 'absent') ? {
    true  => "pip_uninstall_${name}",
    false => "pip_install_${name}",
  }

  exec { $pip_installer:
    command     => $command,
    unless      => $unless_command,
    user        => $owner,
    group       => $group,
    umask       => $umask,
    cwd         => $cwd,
    environment => $environment,
    timeout     => $timeout,
    path        => $_path,
    provider    => $exec_provider,
  }

}
