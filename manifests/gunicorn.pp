#
# @summary Manages Gunicorn virtual hosts.
#
# @param ensure
# @param config_dir Configure the gunicorn config directory path.
# @param manage_config_dir Set if the gunicorn config directory should be created.
# @param virtualenv Run in virtualenv, specify directory.
# @param mode Gunicorn mode.
# @param dir Application directory.
# @param bind Bind on: 'HOST', 'HOST:PORT', 'unix:PATH'.
#  Default: system-wide: unix:/tmp/gunicorn-$name.socket
#           virtualenv:  unix:${virtualenv}/${name}.socket
# @param environment Set ENVIRONMENT variable.
# @param appmodule Set the application module name for gunicorn to load when not using Django.
# @param osenv Allows setting environment variables for the gunicorn service. Accepts a hash of 'key': 'value' pairs.
# @param timeout Allows setting the gunicorn idle worker process time before being killed. The unit of time is seconds.
# @param template Which ERB template to use.
# @param args Custom arguments to add in gunicorn config file.
#
# @example run gunicorn on vhost in virtualenv /var/www/project1
#  python::gunicorn { 'vhost':
#    ensure      => present,
#    virtualenv  => '/var/www/project1',
#    mode        => 'wsgi',
#    dir         => '/var/www/project1/current',
#    bind        => 'unix:/tmp/gunicorn.socket',
#    environment => 'prod',
#    owner       => 'www-data',
#    group       => 'www-data',
#    appmodule   => 'app:app',
#    osenv       => { 'DBHOST' => 'dbserver.example.com' },
#    timeout     => 30,
#    template    => 'python/gunicorn.erb',
#  }
#
define python::gunicorn (
  Stdlib::Absolutepath                  $dir,
  Enum['present', 'absent']             $ensure            = present,
  Stdlib::Absolutepath                  $config_dir        = '/etc/gunicorn.d',
  Booloean                              $manage_config_dir = false,
  Variant[Boolean,Stdlib::Absolutepath] $virtualenv        = false,
  Enum['wsgi', 'django']                $mode              = 'wsgi',
  Variant[String[1],Boolean]            $bind              = false,
  Variant[String[1],Boolean]            $environment       = false,
  String[1]                             $owner             = 'www-data',
  String[1]                             $group             = 'www-data',
  String[1]                             $appmodule         = 'app:app',
  Variant[Boolean,Hash]                 $osenv             = false,
  Integer                               $timeout           = 30,
  Variant[Boolean,Integer]              $workers           = false,
  Variant[Boolean,String[1]]            $access_log_format = false,
  Variant[Boolean,Stdlib::Absolutepath] $accesslog         = false,
  Variant[Boolean,Stdlib::Absolutepath] $errorlog          = false,
  Python::Loglevel                      $log_level         = 'error',
  String[1]                             $template          = 'python/gunicorn.erb',
  Array                                 $args              = [],
) {
  if $manage_config_dir {
    file { $config_dir:
      ensure => directory,
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
    }

    file { "${config_dir}/${name}":
      ensure  => $ensure,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template($template),
      require => File[$config_dir],
    }
  } else {
    file { "${config_dir}/${name}":
      ensure  => $ensure,
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template($template),
    }
  }
}
