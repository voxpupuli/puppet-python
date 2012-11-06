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

    exec { "python_virtualenv_${venv_dir}":
      command => "mkdir -p ${venv_dir} \
        ${proxy_command} \
        && virtualenv -p `which ${python}` ${system_pkgs_flag} ${venv_dir} \
        && ${venv_dir}/bin/pip install ${proxy_flag} --upgrade distribute pip",
      creates => $venv_dir,
    }

    if $requirements {
      Exec["python_virtualenv_${venv_dir}"]
      -> Python::Requirements[$requirements]

      python::requirements { $requirements:
        virtualenv => $venv_dir,
        proxy      => $proxy,
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
