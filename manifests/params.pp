# == Class: python::params
#
# The python Module default configuration settings.
#
class python::params {
  $version                = 'system'
  $pip                    = true
  $dev                    = false
  $virtualenv             = false
  $gunicorn               = false
  $manage_gunicorn        = true
  $provider               = undef
  $valid_versions = $::osfamily ? {
    'RedHat'  => ['3'],
    'Debian'  => ['3', '3.3', '2.7'],
    'Suse'    => [],
    'FreeBSD' => ['3', '34', '2', '27']
  }
  $use_epel               = true
}
