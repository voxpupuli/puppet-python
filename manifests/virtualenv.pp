# == Define: python::virtualenv
#
# Creates Python virtualenv.
#
# === Parameters
#
# [*ensure*]
#  present|absent. Default: present
#
# [*version*]
#  Python version to use. Default: system default
#
# [*requirements*]
#  Path to pip requirements.txt file. Default: none
#
# [*proxy*]
#  Proxy server to use for outbound connections. Default: none
#
# [*systempkgs*]
#  Copy system site-packages into virtualenv. Default: don't
#
# [*distribute*]
#  Include distribute in the virtualenv. Default: true
#
# === Examples
#
# python::virtualenv { '/var/www/project1':
#   ensure       => present,
#   version      => 'system',
#   requirements => '/var/www/project1/requirements.txt',
#   proxy        => 'http://proxy.domain.com:3128',
#   systempkgs   => true,
# }
#
# === Authors
#
# Sergey Stankevich
# Ashley Penney
# Marc Fournier
#
define python::virtualenv (
  $ensure       = present,
  $version      = 'system',
  $requirements = false,
  $proxy        = false,
  $systempkgs   = false,
  $distribute   = true,
) {

  $venv_dir = $name

  if $ensure == 'present' {

    $python = $version ? {
      'system' => 'python',
      default  => "python${version}",
    }

    $proxy_flag = $proxy ? {
      false    => '',
      default  => "--proxy=${proxy}",
    }

    $proxy_command = $proxy ? {
      false   => '',
      default => "&& export http_proxy=${proxy}",
    }

    $system_pkgs_flag = $systempkgs ? {
      false    => '',
      default  => '--system-site-packages',
    }

    $distribute_pkg = $distribute ? {
      true     => 'distribute',
      default  => '',
    }

    exec { "python_virtualenv_${venv_dir}":
      command => "mkdir -p ${venv_dir} \
        ${proxy_command} \
        && virtualenv -p `which ${python}` ${system_pkgs_flag} ${venv_dir} \
        && ${venv_dir}/bin/pip install ${proxy_flag} --upgrade ${distribute_pkg} pip",
      creates => $venv_dir,
    }

    if $requirements {
      exec { "python_requirements_initial_install_${requirements}_${venv_dir}":
        command     => "${venv_dir}/bin/pip install ${proxy_flag} --requirement ${requirements}",
        refreshonly => true,
        timeout     => 1800,
        subscribe   => Exec["python_virtualenv_${venv_dir}"],
      }

      python::requirements { "${requirements}_${venv_dir}":
        requirements => $requirements,
        virtualenv   => $venv_dir,
        proxy        => $proxy,
        require      => Exec["python_virtualenv_${venv_dir}"],
      }
    }

  } elsif $ensure == 'absent' {

    file { $venv_dir:
      ensure  => absent,
      force   => true,
      recurse => true,
      purge   => true,
    }

  }

}
