# @api private
# @summary Optionally installs the gunicorn service
#
# @example
#  include python::config
#
class python::config {
  Class['python::install'] -> Python::Pip <| |>
  Class['python::install'] -> Python::Requirements <| |>

  if $python::manage_gunicorn {
    unless $python::gunicorn == 'absent' {
      Class['python::install'] -> Python::Gunicorn <| |>

      Python::Gunicorn <| |> ~> Service['gunicorn']

      service { 'gunicorn':
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => false,
        pattern    => '/usr/bin/gunicorn',
      }
    }
  }
}
