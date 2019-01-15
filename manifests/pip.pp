
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
  Enum['pip', 'pip3'] $pip_provider                          = 'pip',
  Variant[Boolean, String] $url                              = false,
  String[1] $owner                                           = 'root',
  $group                                                     = undef,
  $umask                                                     = undef,
  $index                                                     = false,
  Variant[Boolean, String] $proxy                            = false,
  $egg                                                       = false,
  Boolean $editable                                          = false,
  $environment                                               = [],
  $extras                                                    = [],
  String $install_args                                       = '',
  String $uninstall_args                                     = '',
  Numeric $timeout                                           = 1800,
  String[1] $log_dir                                         = '/tmp',
  Array[String] $path                                        = ['/usr/local/bin','/usr/bin','/bin', '/usr/sbin'],
){
  $python_provider = getparam(Class['python'], 'provider')
  $python_version  = getparam(Class['python'], 'version')
  if $group {
    $_group = $group
  } else {
    include ::python::params
    $_group = $python::params::group
  }
  # Get SCL exec prefix
  # NB: this will not work if you are running puppet from scl enabled shell
  $exec_prefix = $python_provider ? {
    'scl'   => "scl enable ${python_version} -- ",
    'rhscl' => "scl enable ${python_version} -- ",
    default => '',
  }

  $_path = $python_provider ? {
    'anaconda' => concat(["${::python::anaconda_install_path}/bin"], $path),
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
    false    => '',
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

  # Check if searching by explicit version.
  if $ensure =~ /^((19|20)[0-9][0-9]-(0[1-9]|1[1-2])-([0-2][1-9]|3[0-1])|[0-9]+\.\w+\+?\w*(\.\w+)*)$/ {
    $grep_regex = "^${pkgname}==${ensure}\$"
  } else {
    $grep_regex = $pkgname ? {
      /==/    => "^${pkgname}\$",
      default => "^${pkgname}==",
    }
  }

  $extras_string = empty($extras) ? {
    true    => '',
    default => sprintf('[%s]',join($extras,',')),
  }

  $egg_name = $egg ? {
    false   => "${pkgname}${extras_string}",
    default => $egg
  }

  $source = $url ? {
    false               => "${pkgname}${extras_string}",
    /^(\/|[a-zA-Z]\:)/  => $url,
    /^(git\+|hg\+|bzr\+|svn\+)(http|https|ssh|svn|sftp|ftp|lp)(:\/\/).+$/ => $url,
    default             => "${url}#egg=${egg_name}",
  }

  # We need to jump through hoops to make sure we issue the correct pip command
  # depending on wheel support and versions.
  #
  # Pip does not support wheels prior to version 1.4.0
  # Pip wheels require setuptools/distribute > 0.8
  # Python 2.6 and older does not support setuptools/distribute > 0.8
  # Pip >= 1.5 tries to use wheels by default, even if wheel package is not
  # installed, in this case the --no-use-wheel flag needs to be passed
  # Versions prior to 1.5 don't support the --no-use-wheel flag
  #
  # To check for this we test for wheel parameter using help and then using
  # show, this makes sure we only use wheels if they are supported and
  # installed
  $wheel_check = "${pip_env} wheel --help > /dev/null 2>&1 && { ${pip_env} show wheel > /dev/null 2>&1 || wheel_support_flag='--no-binary :all:'; }"

  $pip_install = "${pip_env} --log ${log}/pip.log install"
  $pip_common_args = "${pypi_index} ${proxy_flag} ${install_args} ${install_editable} ${source}"

  # Explicit version out of VCS when PIP supported URL is provided
  if $source =~ /^(git\+|hg\+|bzr\+|svn\+)(http|https|ssh|svn|sftp|ftp|lp)(:\/\/).+$/ {
    if $ensure != present and $ensure != latest {
      exec { "pip_install_${name}":
        command     => "${wheel_check} ; { ${pip_install} ${install_args} \$wheel_support_flag ${pip_common_args}@${ensure}#egg=${egg_name} || ${pip_install} ${install_args} ${pip_common_args}@${ensure}#egg=${egg_name} ;}",
        unless      => "${pip_env} freeze --all | grep -i -e ${grep_regex}",
        user        => $owner,
        group       => $_group,
        umask       => $umask,
        cwd         => $cwd,
        environment => $environment,
        timeout     => $timeout,
        path        => $_path,
      }
    } else {
      exec { "pip_install_${name}":
        command     => "${wheel_check} ; { ${pip_install} ${install_args} \$wheel_support_flag ${pip_common_args} || ${pip_install} ${install_args} ${pip_common_args} ;}",
        unless      => "${pip_env} freeze --all | grep -i -e ${grep_regex}",
        user        => $owner,
        group       => $_group,
        umask       => $umask,
        cwd         => $cwd,
        environment => $environment,
        timeout     => $timeout,
        path        => $_path,
      }
    }
  } else {
    case $ensure {
      /^((19|20)[0-9][0-9]-(0[1-9]|1[1-2])-([0-2][1-9]|3[0-1])|[0-9]+\.\w+\+?\w*(\.\w+)*)$/: {
        # Version formats as per http://guide.python-distribute.org/specification.html#standard-versioning-schemes
        # Explicit version.
        exec { "pip_install_${name}":
          command     => "${wheel_check} ; { ${pip_install} ${install_args} \$wheel_support_flag ${pip_common_args}==${ensure} || ${pip_install} ${install_args} ${pip_common_args}==${ensure} ;}",
          unless      => "${pip_env} freeze --all | grep -i -e ${grep_regex} || ${pip_env} list | sed -e 's/[ ]\\+/==/' -e 's/[()]//g' | grep -i -e ${grep_regex}",
          user        => $owner,
          group       => $_group,
          umask       => $umask,
          cwd         => $cwd,
          environment => $environment,
          timeout     => $timeout,
          path        => $_path,
        }
      }
#
      'present': {
        # Whatever version is available.
        exec { "pip_install_${name}":
          command     => "${wheel_check} ; { ${pip_install} \$wheel_support_flag ${pip_common_args} || ${pip_install} ${pip_common_args} ;}",
          unless      => "${pip_env} freeze --all | grep -i -e ${grep_regex} || ${pip_env} list | sed -e 's/[ ]\\+/==/' -e 's/[()]//g' | grep -i -e ${grep_regex}",
          user        => $owner,
          group       => $_group,
          umask       => $umask,
          cwd         => $cwd,
          environment => $environment,
          timeout     => $timeout,
          path        => $_path,
        }
      }

      'latest': {
        # Unfortunately this is the smartest way of getting the latest available package version with pip as of now
        # Note: we DO need to repeat ourselves with "from version" in both grep and sed as on some systems pip returns
        # more than one line with paretheses.
        $latest_version = join(["${pip_env} install ${proxy_flag} ${pkgname}==notreallyaversion 2>&1",
                                ' | grep -oP "\(from versions: .*\)" | sed -E "s/\(from versions: (.*?, )*(.*)\)/\2/g"',
                                ' | tr -d "[:space:]"'])

        # Packages with underscores in their names are listed with dashes in their place in `pip freeze` output
        $pkgname_with_dashes = regsubst($pkgname, '_', '-', 'G')
        $grep_regex_pkgname_with_dashes = "^${pkgname_with_dashes}=="
        $installed_version = join(["${pip_env} freeze --all",
                                  " | grep -i -e ${grep_regex_pkgname_with_dashes} | cut -d= -f3",
                                  " | tr -d '[:space:]'"])

        $unless_command = "[ \$(${latest_version}) = \$(${installed_version}) ]"

        # Latest version.
        exec { "pip_install_${name}":
          command     => "${wheel_check} ; { ${pip_install} --upgrade \$wheel_support_flag ${pip_common_args} || ${pip_install} --upgrade ${pip_common_args} ;}",
          unless      => $unless_command,
          user        => $owner,
          group       => $_group,
          umask       => $umask,
          cwd         => $cwd,
          environment => $environment,
          timeout     => $timeout,
          path        => $_path,
        }
      }

      default: {
        # Anti-action, uninstall.
        exec { "pip_uninstall_${name}":
          command     => "echo y | ${pip_env} uninstall ${uninstall_args} ${proxy_flag} ${name}",
          onlyif      => "${pip_env} freeze --all | grep -i -e ${grep_regex}",
          user        => $owner,
          group       => $_group,
          umask       => $umask,
          cwd         => $cwd,
          environment => $environment,
          timeout     => $timeout,
          path        => $_path,
        }
      }
    }
  }
}
