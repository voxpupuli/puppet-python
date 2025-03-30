# @summary Installs python development packages
class python::install::dev {
  include python

  case $python::provider {
    'pip': {
      package { 'python-dev':
        ensure => $python::dev,
        name   => $python::install::pythondev,
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
          package { 'python-dev':
            ensure   => $python::dev,
            name     => $python::install::pythondev,
            alias    => $python::install::pythondev,
            provider => 'yum',
          }
        }
        default: {
          package { 'python-dev':
            ensure => $python::dev,
            name   => $python::install::pythondev,
            alias  => $python::install::pythondev,
          }
        }
      }
    }
  }
}
