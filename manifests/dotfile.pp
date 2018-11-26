#
# @summary Manages any python dotfiles with a simple config hash.
#
# @param ensure
# @param filename Filename.
# @param mode File mode.
# @param owner user owner of dotfile
# @param group group owner of dotfile
# @param config Config hash. This will be expanded to an ini-file.
#
# @example Create a pip config in /var/lib/jenkins/.pip/
#   python::dotfile { '/var/lib/jenkins/.pip/pip.conf':
#     ensure => present,
#     owner  => 'jenkins',
#     group  => 'jenkins',
#     config => {
#       'global' => {
#         'index-url'       => 'https://mypypi.acme.com/simple/'
#         'extra-index-url' => 'https://pypi.risedev.at/simple/'
#       }
#     }
#   }
#
#
define python::dotfile (
  Enum['absent', 'present'] $ensure   = 'present',
  String[1] $filename                 = $title,
  String[1] $owner                    = 'root',
  String[1] $group                    = 'root',
  Stdlib::Filemode $mode              = '0644',
  Hash $config                        = {},
) {
  $parent_dir = dirname($filename)

  exec { "create ${title}'s parent dir":
    command => "install -o ${owner} -g ${group} -d ${parent_dir}",
    path    => [ '/usr/bin', '/bin', '/usr/local/bin', ],
    creates => $parent_dir,
  }

  file { $filename:
    ensure  => $ensure,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => template("${module_name}/inifile.erb"),
    require => Exec["create ${title}'s parent dir"],
  }
}
