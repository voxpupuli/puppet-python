class { 'python':
  pip=>false,
  version=>'3',
}

python::pyvenv { "/opt/uwsgi":
}

python::pip { "uwsgi":
  virtualenv => "/opt/uwsgi",
  ensure => "latest"
}
