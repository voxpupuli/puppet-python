# puppet-python

[![Build Status](https://github.com/voxpupuli/puppet-python/workflows/CI/badge.svg)](https://github.com/voxpupuli/puppet-python/actions?query=workflow%3ACI)
[![Release](https://github.com/voxpupuli/puppet-python/actions/workflows/release.yml/badge.svg)](https://github.com/voxpupuli/puppet-python/actions/workflows/release.yml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/puppet/python.svg)](https://forge.puppetlabs.com/puppet/python)
[![Puppet Forge - downloads](https://img.shields.io/puppetforge/dt/puppet/python.svg)](https://forge.puppetlabs.com/puppet/python)
[![Puppet Forge - endorsement](https://img.shields.io/puppetforge/e/puppet/python.svg)](https://forge.puppetlabs.com/puppet/python)
[![Puppet Forge - scores](https://img.shields.io/puppetforge/f/puppet/python.svg)](https://forge.puppetlabs.com/puppet/python)
[![puppetmodule.info docs](http://www.puppetmodule.info/images/badge.png)](http://www.puppetmodule.info/m/puppet-python)
[![License](https://img.shields.io/github/license/voxpupuli/puppet-python.svg)](https://github.com/voxpupuli/puppet-python/blob/master/LICENSE)

Puppet module for installing and managing python, pip, virtualenvs and Gunicorn virtual hosts.

**Please note:** The module [stankevich/python](https://forge.puppet.com/stankevich/python) has been deprecated and is now available under Vox Pupuli: [puppet/python](https://forge.puppet.com/puppet/python).

## Usage
For class usage refer to the [Reference]("https://github.com/voxpupuli/puppet-python/blob/master/REFERENCE.md). If contributing, this is updated with
```shell
bundle exec rake strings:generate\[',,,,false,true']
```

### Install Python package to a user's default install directory

The following code simulates

```shell
python3 -m pip install pandas --user
```
where pip installs packages to a user's default install directory --
typically  `~/.local/` on Linux.

```puppet
# Somewhat hackishly, install Python PIP module PANDAS for Oracle Cloud API queries.
python::pyvenv { 'user_python_venv':
  ensure     => present,
  version    => 'system',
  systempkgs => true,
  venv_dir   => '/home/example/.local',
  owner      => 'example',
  group      => 'example',
  mode       => '0750',
}

python::pip { 'pandas':
  virtualenv   => '/home/example/.local',
  owner        => 'example',
  group        => 'example',
}
```

### hiera configuration

This module supports configuration through hiera. The following example
creates two python3 virtualenvs. The configuration also pip installs a
package into each environment.

```yaml
python::python_pyvenvs:
  "/opt/env1":
    version: "system"
  "/opt/env2":
    version: "system"
python::python_pips:
  "nose":
    virtualenv: "/opt/env1"
  "coverage":
    virtualenv: "/opt/env2"
python::python_dotfiles:
  "/var/lib/jenkins/.pip/pip.conf":
    config:
      global:
        index-url: "https://mypypi.acme.com/simple/"
        extra-index-url: "https://pypi.risedev.at/simple/"
```

### Using SCL packages from RedHat or CentOS

To use this module with Linux distributions in the Red Hat family and python distributions
from softwarecollections.org, set python::provider to 'rhscl' and python::version to the name
of the collection you want to use (e.g., 'python27', 'python33', or 'rh-python34').

## Release Notes

See [Changelog](https://github.com/voxpupuli/puppet-python/blob/master/CHANGELOG.md)

## Contributors

Check out [Github contributors](https://github.com/voxpupuli/puppet-python/graphs/contributors).
