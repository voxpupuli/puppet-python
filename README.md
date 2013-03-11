[puppet-python](https://github.com/stankevich/puppet-python)
======

Puppet module for installing and managing python, pip, virtualenvs and Gunicorn virtual hosts.

## Usage

### python

Installs and manages python, python-dev, python-virtualenv and Gunicorn.

**version** — Python version to install. Default: system default

**dev** — Install python-dev. Default: false

**virtualenv** — Install python-virtualenv. Default: false

**gunicorn** — Install Gunicorn. Default: false

	class { 'python':
	  version    => 'system',
	  dev        => true,
	  virtualenv => true,
	  gunicorn   => true,
	}

### python::pip

Installs and manages packages from pip.

**ensure** — present/absent. Default: present

**virtualenv** — virtualenv to run pip in.

**proxy** — Proxy server to use for outbound connections. Default: none

	python::pip { 'flask':
	  virtualenv => '/var/www/project1',
	  proxy      => 'http://proxy.domain.com:3128',
	}

### python::requirements

Installs and manages Python packages from requirements file.

**virtualenv** — virtualenv to run pip in. Default: system-wide

**proxy** — Proxy server to use for outbound connections. Default: none

	python::requirements { '/var/www/project1/requirements.txt':
	  virtualenv => '/var/www/project1',
	  proxy      => 'http://proxy.domain.com:3128',
	}

### python::virtualenv

Creates Python virtualenv.

**ensure** — present/absent. Default: present

**version** — Python version to use. Default: system default

**requirements** — Path to pip requirements.txt file. Default: none

**proxy** — Proxy server to use for outbound connections. Default: none

**systempkgs** — Copy system site-packages into virtualenv. Default: don't

**distribute** — Include distribute in the virtualenv. Default: true

	python::virtualenv { '/var/www/project1':
	  ensure       => present,
	  version      => 'system',
	  requirements => '/var/www/project1/requirements.txt',
	  proxy        => 'http://proxy.domain.com:3128',
	  systempkgs   => true,
	  distribute   => false,
	}

### python::gunicorn

Manages Gunicorn virtual hosts.

**ensure** — present/absent. Default: present

**virtualenv** — Run in virtualenv, specify directory. Default: disabled

**mode** — Gunicorn mode. wsgi/django. Default: wsgi

**dir** — Application directory.

**bind** — Bind on: 'HOST', 'HOST:PORT', 'unix:PATH'. Default: unix:/tmp/gunicorn-$name.socket or unix:${virtualenv}/${name}.socket

**environment** — Set ENVIRONMENT variable. Default: none

**template** — Which ERB template to use. Default: python/gunicorn.erb

	python::gunicorn { 'vhost':
	  ensure      => present,
	  virtualenv  => '/var/www/project1',
	  mode        => 'wsgi',
	  dir         => '/var/www/project1/current',
	  bind        => 'unix:/tmp/gunicorn.socket',
	  environment => 'prod',
	  template    => 'python/gunicorn.erb',
	}

## Authors

[Sergey Stankevich](https://github.com/stankevich)
[Ashley Penney](https://github.com/apenney)
[Marc Fournier](https://github.com/mfournier)
