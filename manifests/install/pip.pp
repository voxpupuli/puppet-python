# @summary Installs python pip packages
class python::install::pip {
  include python

  case $python::provider {
    'pip': {
      package { 'pip':
        ensure  => $python::pip,
        require => Package['python'],
      }
    }
    'scl': {
    }
    'rhscl': {
    }
    'anaconda': {
    }
    default: {
      case $facts['os']['family'] {
        'AIX': {
          unless String($python::version) =~ /^python3/ {
            package { 'python-pip':
              ensure   => $python::pip,
              require  => Package['python'],
              provider => 'yum',
            }
          }
        }
        default: {
          package { 'pip':
            ensure  => $python::pip,
            require => Package['python'],
          }
        }
      }
    }
  }
}
