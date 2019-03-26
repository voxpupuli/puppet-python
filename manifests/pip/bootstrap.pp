#
# @summary allow to bootstrap pip when python is managed from other module
#
# @param version should be pip or pip3
# @param manage_python if python module will manage deps
#
# @example 
#   class { 'python::pip::bootstrap':
#     version => 'pip',
#   }
class python::pip::bootstrap (
  Enum['pip', 'pip3'] $version            = 'pip',
  Variant[Boolean, String] $manage_python = false,
  String $http_proxy                      = '',
) inherits ::python::params {
  if $manage_python {
    include python
  } else {
    $target_src_pip_path = $facts['os']['family'] ? {
      'AIX' => '/opt/freeware/bin',
      default => '/usr/bin'
    }
    if $version == 'pip3' {
      exec { 'bootstrap pip3':
        command => '/usr/bin/curl https://bootstrap.pypa.io/get-pip.py | python3',
        environment = [ "HTTP_PROXY=${http_proxy}", "HTTPS_PROXY=${http_proxy}" ],
        unless  => 'which pip3',
        path    => $python::params::pip_lookup_path,
        require => Package['python3'],
      }
      # puppet is opinionated about the pip command name
      file { 'pip3-python':
        ensure  => link,
        path    => '/usr/bin/pip3',
        target  => "${target_src_pip_path}/pip${::facts['python3_release']}",
        require => Exec['bootstrap pip3'],
      }
    } else {
        exec { 'bootstrap pip':
          command => '/usr/bin/curl https://bootstrap.pypa.io/get-pip.py | python',
          environment = [ "HTTP_PROXY=${http_proxy}", "HTTPS_PROXY=${http_proxy}" ],
          unless  => 'which pip',
          path    => $python::params::pip_lookup_path,
          require => Package['python'],
        }
        # puppet is opinionated about the pip command name
        file { 'pip-python':
          ensure  => link,
          path    => '/usr/bin/pip',
          target  => "${target_src_pip_path}/pip${::facts['python2_release']}",
          require => Exec['bootstrap pip'],
        }
    }
  }
}
