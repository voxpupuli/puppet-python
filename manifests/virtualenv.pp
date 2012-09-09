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
# === Examples
#
# python::virtualenv { '/var/www/project1':
#   ensure       => present,
#   version      => 'system',
#   requirements => '/var/www/project1/requirements.txt',
#   proxy        => 'http://proxy.domain.com:3128',
# }
#
# === Authors
#
# Sergey Stankevich
#
define python::virtualenv (
  $ensure       = present,
  $version      = 'system',
  $requirements = false,
  $proxy        = false
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

    exec { "python_virtualenv_${venv_dir}":
      command => "mkdir -p ${venv_dir} \
        && export http_proxy=${proxy} \
        && virtualenv -p `which ${python}` ${venv_dir} \
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
