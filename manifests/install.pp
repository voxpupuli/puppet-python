# == Class: python::install
#
# Installs core python packages,
#
# === Examples
#
# include python::install
#
# === Authors
#
# Sergey Stankevich
# Ashley Penney
# Fotis Gimian
# Garrett Honeycutt <code@garretthoneycutt.com>
#
class python::install {

  $python = $::python::version ? {
    'system' => 'python',
    'pypy'   => 'pypy',
    default  => "python${python::version}",
  }

  $pythondev = $::osfamily ? {
    'RedHat' => "${python}-devel",
    'Debian' => "${python}-dev",
    'Suse'   => "${python}-devel",
  }

  $dev_ensure = $python::dev ? {
    true    => 'present',
    false   => 'absent',
    default => $python::dev,
  }

  $pip_ensure = $python::pip ? {
    true    => 'present',
    false   => 'absent',
    default => $python::pip,
  }

  $venv_ensure = $python::virtualenv ? {
    true    => 'present',
    false   => 'absent',
    default => $python::virtualenv,
  }

  package { 'python':
    ensure => $python::ensure,
    name   => $python,
  }

  package { 'python-dev':
    ensure => $dev_ensure,
    name   => $pythondev,
  }

  package { 'pip':
    ensure  => $pip_ensure,
    require => Package['python'],
  }

  package { 'virtualenv':
    ensure  => $venv_ensure,
    require => Package['python'],
  }

  case $python::provider {
    pip: {
      # Install pip without pip, see https://pip.pypa.io/en/stable/installing/.
      exec { 'bootstrap pip':
        command => 'curl https://bootstrap.pypa.io/get-pip.py | python',
        unless  => 'which pip',
        require => Package['python'],
      }
      Exec['bootstrap pip'] -> Package <| provider == pip |>

      Package <| title == 'pip' |> {
        name     => 'pip',
        provider => 'pip',
      }
      Package <| title == 'virtualenv' |> {
        name     => 'virtualenv',
        provider => 'pip',
      }
    }
    scl: {
      # SCL is only valid in the RedHat family. If RHEL, package must be
      # enabled using the subscription manager outside of puppet. If CentOS,
      # the centos-release-SCL will install the repository.
      $install_scl_repo_package = $::operatingsystem ? {
        'CentOS' => 'present',
        default  => 'absent',
      }

      package { 'centos-release-SCL':
        ensure => $install_scl_repo_package,
        before => Package['scl-utils'],
      }
      package { 'scl-utils':
        ensure => 'latest',
        before => Package['python'],
      }

      # This gets installed as a dependency anyway
      # package { "${python::version}-python-virtualenv":
      #   ensure  => $venv_ensure,
      #   require => Package['scl-utils'],
      # }
      package { "${python::version}-scldev":
        ensure  => $dev_ensure,
        require => Package['scl-utils'],
      }
      if $pip_ensure != 'absent' {
        exec { 'python-scl-pip-install':
          command => "${python::params::exec_prefix}easy_install pip",
          path    => ['/usr/bin', '/bin'],
          creates => "/opt/rh/${python::version}/root/usr/bin/pip",
          require => Package['scl-utils'],
        }
      }
    }
    rhscl: {
      # rhscl is RedHat SCLs from softwarecollections.org
      $scl_package = "rhscl-${::python::version}-epel-${::operatingsystemmajrelease}-${::architecture}"
      package { $scl_package:
        source   => "https://www.softwarecollections.org/en/scls/rhscl/${::python::version}/epel-${::operatingsystemmajrelease}-${::architecture}/download/${scl_package}.noarch.rpm",
        provider => 'rpm',
        tag      => 'python-scl-repo',
      }

      Package <| title == 'python' |> {
        tag => 'python-scl-package',
      }

      package { "${python::version}-scldev":
        ensure => $dev_ensure,
        tag    => 'python-scl-package',
      }

      if $pip_ensure != 'absent' {
        exec { 'python-scl-pip-install':
          command => "${python::exec_prefix}easy_install pip",
          path    => ['/usr/bin', '/bin'],
          creates => "/opt/rh/${python::version}/root/usr/bin/pip",
        }
      }

      Package <| tag == 'python-scl-repo' |> ->
      Package <| tag == 'python-scl-package' |> ->
      Exec['python-scl-pip-install']
    }

    default: {
      if $::osfamily == 'RedHat' {
        if $pip_ensure != 'absent' {
          if $python::use_epel == true {
            include 'epel'
            Class['epel'] -> Package['pip']
          }
        }
        if ($venv_ensure != 'absent') and ($::operatingsystemrelease =~ /^6/) {
          if $python::use_epel == true {
            include 'epel'
            Class['epel'] -> Package['virtualenv']
          }
        }
      }

      if $::python::version =~ /^3/ {
        $pip_package = 'python3-pip'
      } else {
        $pip_package = 'python-pip'
      }

      $virtualenv_package = $::lsbdistcodename ? {
        'jessie' => 'virtualenv',
        default  => 'python-virtualenv',
      }

      Package <| title == 'pip' |> {
        name => $pip_package,
      }

      Package <| title == 'virtualenv' |> {
        name => $virtualenv_package,
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
    }
  }
}
