# puppet-python [![Build Status](https://travis-ci.org/voxpupuli/puppet-python.svg?branch=master)](https://travis-ci.org/voxpupuli/puppet-python)

Puppet module for installing and managing python, pip, virtualenvs and Gunicorn virtual hosts.

**Please note:** The module [stankevich/python](https://forge.puppet.com/stankevich/python) has been deprecated and is now available under Vox Pupuli: [puppet/python](https://forge.puppet.com/puppet/python).

## Compatibility #

See `.travis.yml` for compatibility matrix.

* Puppet v4
* Puppet v5

### OS Distributions ##

This module has been tested to work on the following systems.

* Debian 8
* Debian 9
* EL 6
* EL 7
* CentOS 7
* Gentoo (and Sabayon)
* Suse 11
* Ubuntu 14.04
* Ubuntu 16.04
* Ubuntu 18.04

## Installation

```shell
git submodule add https://github.com/stankevich/puppet-python.git /path/to/python
```
OR

``` shell
puppet module install puppet-python
```

## Usage
For class usage refer to the <a href="https://github.com/voxpupuli/puppet-python/blob/master/REFERENCE.md">REFERENCE.md</a>. If contributing, this is updated with
```shell
bundle exec rake strings:generate\[',,,,false,true']
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

**Version 1.9.8 Notes**
The `pip`, `virtualenv` and `gunicorn` parameters of `Class['python']` have changed. These parameters now accept `absent`, `present` and `latest` rather than `true` and `false`. The boolean values are still supported and are equivalent to `present` and `absent` respectively. Support for these boolean parameters is deprecated and will be removed in a later release.

**Version 1.7.10 Notes**

Installation of python-pip previously defaulted to `false` and was not installed. This default is now `true` and python-pip is installed. To prevent the installation of python-pip specify `pip => false` as a parameter when instantiating the `python` puppet class.

**Version 1.1.x Notes**

Version `1.1.x` makes several fundamental changes to the core of this module, adding some additional features, improving performance and making operations more robust in general.

Please note that several changes have been made in `v1.1.x` which make manifests incompatible with the previous version.  However, modifying your manifests to suit is trivial.  Please see the notes below.

Currently, the changes you need to make are as follows:

* All pip definitions MUST include the owner field which specifies which user owns the virtualenv that packages will be installed in.  Adding this greatly improves performance and efficiency of this module.
* You must explicitly specify pip => true in the python class if you want pip installed.  As such, the pip package is now independent of the dev package and so one can exist without the other.

## Contributors

Check out [Github contributors](https://github.com/voxpupuli/puppet-python/graphs/contributors).
