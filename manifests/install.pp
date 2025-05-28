# @api private
# @summary Installs core python packages
#
# @example
#  include python::install
#
class python::install {
  $python = $python::version ? {
    'system'                 => 'python',
    'pypy'                   => 'pypy',
    /\A(python[23]\.[0-9]+)/ => $1,
    /\A(python)?([0-9]+)/    => "python${2}",
    /\Arh-python[0-9]{2}/    => $python::version,
    default                  => "python${python::version}",
  }

  $pythondev = $facts['os']['family'] ? {
    'AIX'       => "${python}-devel",
    'Debian'    => "${python}-dev",
    'FreeBSD'   => undef,
    'Gentoo'    => undef,
    'Archlinux' => undef,
    'RedHat'    => "${python}-devel",
    'Suse'      => "${python}-devel",
  }

  if $python::manage_setuptools {
    package { 'python-distutils-extra':
      ensure => 'installed',
    }
  }

  if $python::manage_python_package {
    package { 'python':
      ensure => $python::ensure,
      name   => $python,
    }
  }

  if $python::manage_venv_package {
    ##
    ## CentOS has no extra package for venv
    ##
    unless $facts['os']['family'] == 'RedHat' {
      package { 'python-venv':
        ensure  => $python::venv,
        name    => "${python}-venv",
        require => Package['python'],
      }
    }
  }

  case $python::provider {
    'pip': {
      if $python::manage_pip_package {
        package { 'pip':
          ensure  => $python::pip,
          require => Package['python'],
        }
      }

      if $python::manage_dev_package and $pythondev {
        package { 'python-dev':
          ensure => $python::dev,
          name   => $pythondev,
        }
      }

      # Respect the $python::pip setting
      unless $python::pip == 'absent' {
        # Install pip without pip, see https://pip.pypa.io/en/stable/installing/.
        include python::pip::bootstrap

        Exec['bootstrap pip'] -> File['pip-python'] -> Package <| provider == pip |>

        Package <| title == 'pip' |> {
          name     => 'pip',
          provider => 'pip',
        }
      }
    }
    'scl': {
      # SCL is only valid in the RedHat family. If RHEL, package must be
      # enabled using the subscription manager outside of puppet. If CentOS,
      # the centos-release-SCL will install the repository.
      if $python::manage_scl {
        $install_scl_repo_package = $facts['os']['name'] ? {
          'CentOS' => 'present',
          default  => 'absent',
        }

        package { 'centos-release-scl':
          ensure => $install_scl_repo_package,
          before => Package['scl-utils'],
        }

        package { 'scl-utils':
          ensure => 'present',
          before => Package['python'],
        }

        Package['scl-utils'] -> Package["${python}-scldevel"]

        if $python::pip != 'absent' {
          Package['scl-utils'] -> Exec['python-scl-pip-install']
        }
      }

      package { "${python}-scldevel":
        ensure => $python::dev,
      }

      if $python::pip != 'absent' {
        exec { 'python-scl-pip-install':
          command => "${python::exec_prefix}easy_install pip",
          path    => ['/usr/bin', '/bin'],
          creates => "/opt/rh/${python::version}/root/usr/bin/pip",
        }
      }
    }
    'rhscl': {
      # rhscl is RedHat SCLs from softwarecollections.org
      if $python::rhscl_use_public_repository {
        $scl_package = "rhscl-${python::version}-epel-${facts['os']['release']['major']}-${facts['os']['architecture']}"

        package { $scl_package:
          source   => "https://www.softwarecollections.org/en/scls/rhscl/${python::version}/epel-${facts['os']['release']['major']}-${facts['os']['architecture']}/download/${scl_package}.noarch.rpm",
          provider => 'rpm',
          tag      => 'python-scl-repo',
        }
      }

      Package <| title == 'python' |> {
        tag => 'python-scl-package',
      }

      package { "${python}-scldevel":
        ensure => $python::dev,
        tag    => 'python-scl-package',
      }

      package { "${python}-python-pip":
        ensure => $python::pip,
        tag    => 'python-pip-package',
      }

      if $python::rhscl_use_public_repository {
        Package <| tag == 'python-scl-repo' |>
        -> Package <| tag == 'python-scl-package' |>
      }

      Package <| tag == 'python-scl-package' |> -> Package <| tag == 'python-pip-package' |>
    }
    'anaconda': {
      $installer_path = '/var/tmp/anaconda_installer.sh'

      file { $installer_path:
        source => $python::anaconda_installer_url,
        mode   => '0700',
      }
      -> exec { 'install_anaconda_python':
        command   => "${installer_path} -b -p ${python::anaconda_install_path}",
        creates   => $python::anaconda_install_path,
        logoutput => true,
      }
      -> exec { 'install_anaconda_virtualenv':
        command => "${python::anaconda_install_path}/bin/pip install virtualenv",
        creates => "${python::anaconda_install_path}/bin/virtualenv",
      }
    }
    default: {
      case $facts['os']['family'] {
        'AIX': {
          if String($python::version) =~ /^python3/ {
            class { 'python::pip::bootstrap':
              version => 'pip3',
            }
          } else {
            if $python::manage_pip_package {
              package { 'python-pip':
                ensure   => $python::pip,
                require  => Package['python'],
                provider => 'yum',
              }
            }
          }

          if $python::manage_dev_package and $pythondev {
            package { 'python-dev':
              ensure   => $python::dev,
              name     => $pythondev,
              alias    => $pythondev,
              provider => 'yum',
            }
          }
        }
        default: {
          if $python::manage_pip_package {
            package { 'pip':
              ensure  => $python::pip,
              require => Package['python'],
            }
          }

          if $python::manage_dev_package and $pythondev {
            package { 'python-dev':
              ensure => $python::dev,
              name   => $pythondev,
              alias  => $pythondev,
            }
          }
        }
      }

      if $facts['os']['family'] == 'RedHat' {
        if $python::pip != 'absent' and $python::use_epel and ($python::manage_pip_package or $python::manage_python_package) {
          require epel
        }
      }

      if String($python::version) =~ /^python3/ {
        $pip_package  = "${python}-pip"
        $pip_provider = $python.regsubst(/^.*python3\.?/,'pip3.').regsubst(/\.$/,'')
      } elsif $facts['os']['family'] == 'RedHat' {
        $pip_package  = 'python3-pip'
        $pip_provider = pip3
      } elsif $facts['os']['family'] == 'FreeBSD' {
        $pip_package  = "py${python::version}-pip"
        $pip_provider = 'pip'
      } elsif $facts['os']['family'] == 'Gentoo' {
        $pip_package  = 'dev-python/pip'
        $pip_provider = 'pip'
      } elsif $facts['os']['name'] == 'Ubuntu' {
        $pip_package  = 'python3-pip'
        $pip_provider = 'pip3'
      } elsif $facts['os']['name'] == 'Debian' {
        $pip_package  = 'python3-pip'
        $pip_provider = 'pip3'
      } else {
        $pip_package  = 'python-pip'
        $pip_provider = 'pip'
      }

      Package <| title == 'pip' |> {
        name => $pip_package,
      }
    }
  }

  if $python::manage_gunicorn {
    $gunicorn_ensure = $python::gunicorn ? {
      true    => 'present',
      false   => 'absent',
      default => $python::gunicorn,
    }

    package { 'gunicorn':
      ensure => $gunicorn_ensure,
      name   => $python::gunicorn_package_name,
    }
  }
}
