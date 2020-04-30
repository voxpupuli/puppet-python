# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v4.1.1](https://github.com/voxpupuli/puppet-python/tree/v4.1.1) (2020-04-30)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/v4.1.0...v4.1.1)

**Fixed bugs:**

- Fixes for virtualenv\_version fact when virtualenv \> 20.x [\#537](https://github.com/voxpupuli/puppet-python/pull/537) ([pjonesIDBS](https://github.com/pjonesIDBS))

## [v4.1.0](https://github.com/voxpupuli/puppet-python/tree/v4.1.0) (2020-04-26)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/v4.0.0...v4.1.0)

**Implemented enhancements:**

- Add option for not managing python and virtualenv packages. [\#500](https://github.com/voxpupuli/puppet-python/pull/500) ([tdukaric](https://github.com/tdukaric))

**Fixed bugs:**

- Wrong pip referenced inside virtualenv [\#505](https://github.com/voxpupuli/puppet-python/issues/505)
- CentOS: Fix ordering dependency [\#546](https://github.com/voxpupuli/puppet-python/pull/546) ([bastelfreak](https://github.com/bastelfreak))
- switch from stahnma/epel to puppet/epel / Ubuntu 16.04: Execute tests on Python 3 [\#545](https://github.com/voxpupuli/puppet-python/pull/545) ([bastelfreak](https://github.com/bastelfreak))
- Remove resource collector overriding pip\_provider [\#511](https://github.com/voxpupuli/puppet-python/pull/511) ([jplindquist](https://github.com/jplindquist))

**Closed issues:**

- python3.6+  venv proper installation command [\#533](https://github.com/voxpupuli/puppet-python/issues/533)
- Virtualenv doesn't install with the right python [\#384](https://github.com/voxpupuli/puppet-python/issues/384)

**Merged pull requests:**

- Use voxpupuli-acceptance [\#543](https://github.com/voxpupuli/puppet-python/pull/543) ([ekohl](https://github.com/ekohl))
- update repo links to https [\#531](https://github.com/voxpupuli/puppet-python/pull/531) ([bastelfreak](https://github.com/bastelfreak))

## [v4.0.0](https://github.com/voxpupuli/puppet-python/tree/v4.0.0) (2019-12-10)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/v3.0.1...v4.0.0)

**Breaking changes:**

- Drop Ubuntu 14.04 support [\#515](https://github.com/voxpupuli/puppet-python/pull/515) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Allow python::version to contain a point \(e.g. python3.7\) [\#523](https://github.com/voxpupuli/puppet-python/pull/523) ([baurmatt](https://github.com/baurmatt))
- Fix duplicate declaration for python-venv package [\#518](https://github.com/voxpupuli/puppet-python/pull/518) ([baurmatt](https://github.com/baurmatt))
- Use shell to exec pip commands by default [\#498](https://github.com/voxpupuli/puppet-python/pull/498) ([jamebus](https://github.com/jamebus))
- Fix a reassigned variable [\#497](https://github.com/voxpupuli/puppet-python/pull/497) ([SaschaDoering](https://github.com/SaschaDoering))

**Closed issues:**

- Duplicate declaration for python$version-venv [\#517](https://github.com/voxpupuli/puppet-python/issues/517)
- Python 3.6 on ubuntu 18.04 not working [\#508](https://github.com/voxpupuli/puppet-python/issues/508)
- Module does not recognize Debian python package name [\#506](https://github.com/voxpupuli/puppet-python/issues/506)
- Gunicorn via Hiera [\#499](https://github.com/voxpupuli/puppet-python/issues/499)
- Python::Pip fails if $ensure='absent' [\#496](https://github.com/voxpupuli/puppet-python/issues/496)

**Merged pull requests:**

- Clean up requirements\_spec.rb [\#521](https://github.com/voxpupuli/puppet-python/pull/521) ([ekohl](https://github.com/ekohl))
- Switch to int\_date for acceptance test [\#519](https://github.com/voxpupuli/puppet-python/pull/519) ([baurmatt](https://github.com/baurmatt))
- Upgrade pip and setuptools on venv creation [\#516](https://github.com/voxpupuli/puppet-python/pull/516) ([baurmatt](https://github.com/baurmatt))
- Recognize Debian python package name, fixes: \#506 [\#514](https://github.com/voxpupuli/puppet-python/pull/514) ([lordievader](https://github.com/lordievader))
- Clean up acceptance spec helper [\#512](https://github.com/voxpupuli/puppet-python/pull/512) ([ekohl](https://github.com/ekohl))
- Add badges to README [\#495](https://github.com/voxpupuli/puppet-python/pull/495) ([alexjfisher](https://github.com/alexjfisher))

## [v3.0.1](https://github.com/voxpupuli/puppet-python/tree/v3.0.1) (2019-06-13)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/v3.0.0...v3.0.1)

**Merged pull requests:**

- Fix travis secret [\#493](https://github.com/voxpupuli/puppet-python/pull/493) ([alexjfisher](https://github.com/alexjfisher))

## [v3.0.0](https://github.com/voxpupuli/puppet-python/tree/v3.0.0) (2019-06-13)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/v2.2.2...v3.0.0)

**Breaking changes:**

- modulesync 2.5.1 and drop Puppet 4 [\#467](https://github.com/voxpupuli/puppet-python/pull/467) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Allow HTTP\_PROXY on bootstrap. [\#488](https://github.com/voxpupuli/puppet-python/pull/488) ([pillarsdotnet](https://github.com/pillarsdotnet))
- Modern pip can install wheels without wheel installed [\#483](https://github.com/voxpupuli/puppet-python/pull/483) ([asottile](https://github.com/asottile))
- Allow arbitrary pip providers [\#480](https://github.com/voxpupuli/puppet-python/pull/480) ([ethanhs](https://github.com/ethanhs))
- Add manage\_scl boolean to control managing SCL [\#464](https://github.com/voxpupuli/puppet-python/pull/464) ([bodgit](https://github.com/bodgit))
- Allow pip to work in AIX systems [\#461](https://github.com/voxpupuli/puppet-python/pull/461) ([feltra](https://github.com/feltra))
- move pip bootstrap into a seperate class [\#460](https://github.com/voxpupuli/puppet-python/pull/460) ([feltra](https://github.com/feltra))
- Allow custom python versions and environments [\#451](https://github.com/voxpupuli/puppet-python/pull/451) ([jradmacher](https://github.com/jradmacher))

**Fixed bugs:**

- Installing from git repo runs install on every Puppet run [\#193](https://github.com/voxpupuli/puppet-python/issues/193)
- Fix python::pip installing $editable VCS packages every Puppet run [\#491](https://github.com/voxpupuli/puppet-python/pull/491) ([mlow](https://github.com/mlow))
- Fix $subscribe overloading [\#490](https://github.com/voxpupuli/puppet-python/pull/490) ([nward](https://github.com/nward))
- Fix version-check. [\#489](https://github.com/voxpupuli/puppet-python/pull/489) ([pillarsdotnet](https://github.com/pillarsdotnet))
- Update version validation [\#472](https://github.com/voxpupuli/puppet-python/pull/472) ([bodgit](https://github.com/bodgit))
- Normalize Python version in `python::pyvenv` [\#466](https://github.com/voxpupuli/puppet-python/pull/466) ([thaiphv](https://github.com/thaiphv))
- Fix Ubuntu bionic package installation [\#450](https://github.com/voxpupuli/puppet-python/pull/450) ([ekohl](https://github.com/ekohl))
- Fix $filename and $mode types in python::dotfile [\#446](https://github.com/voxpupuli/puppet-python/pull/446) ([gdubicki](https://github.com/gdubicki))
- Stop using 'pip search' for ensure =\> latest [\#434](https://github.com/voxpupuli/puppet-python/pull/434) ([gdubicki](https://github.com/gdubicki))

**Closed issues:**

- Should set permissive umask before exec. [\#486](https://github.com/voxpupuli/puppet-python/issues/486)
- When updating pip via puppet-python, an error occurs. [\#484](https://github.com/voxpupuli/puppet-python/issues/484)
- Not possible to install Python-3 with this module [\#482](https://github.com/voxpupuli/puppet-python/issues/482)
- Cannot install pre-commit pip. [\#481](https://github.com/voxpupuli/puppet-python/issues/481)
- Allow the use of pip3.4 and pip3.6 [\#476](https://github.com/voxpupuli/puppet-python/issues/476)
- python3\_version fact doesn't work on SCL [\#475](https://github.com/voxpupuli/puppet-python/issues/475)
- missing https\_proxy when using https pypi of other https indexes [\#473](https://github.com/voxpupuli/puppet-python/issues/473)
- Unable to use SCL version [\#471](https://github.com/voxpupuli/puppet-python/issues/471)
- Variable $subscribe shoud not be overwritten [\#470](https://github.com/voxpupuli/puppet-python/issues/470)
- Add switch to not manage SCL setup [\#463](https://github.com/voxpupuli/puppet-python/issues/463)
- update dependencies to stdlib \>= 4.19 [\#458](https://github.com/voxpupuli/puppet-python/issues/458)
- Impossible to use version number in Ubuntu 16.04 [\#448](https://github.com/voxpupuli/puppet-python/issues/448)
- Documentation still includes the deprecated stankevich-python module for installation [\#441](https://github.com/voxpupuli/puppet-python/issues/441)
- No puppet strings docs/class reference docs [\#439](https://github.com/voxpupuli/puppet-python/issues/439)
- python::pip ensure =\> latest triggers refresh on each puppet run for some packages [\#433](https://github.com/voxpupuli/puppet-python/issues/433)
- Support for Python3.6 executables [\#420](https://github.com/voxpupuli/puppet-python/issues/420)
- Python 3 + virtualenv + centos 7 not working [\#354](https://github.com/voxpupuli/puppet-python/issues/354)
- --no-use-wheel argument fails requirement installation [\#173](https://github.com/voxpupuli/puppet-python/issues/173)

**Merged pull requests:**

- 486 Set permissive umask. [\#487](https://github.com/voxpupuli/puppet-python/pull/487) ([pillarsdotnet](https://github.com/pillarsdotnet))
- Update `puppetlabs/stdlib` dependency to allow 6.x and require at least 4.19.0 \(where the `fact()` function was introduced\) [\#485](https://github.com/voxpupuli/puppet-python/pull/485) ([pillarsdotnet](https://github.com/pillarsdotnet))
- Update pip url regex to support 'git+git://\<url\>' [\#477](https://github.com/voxpupuli/puppet-python/pull/477) ([gharper](https://github.com/gharper))
- README.md: remove obsolete and redundant sections [\#453](https://github.com/voxpupuli/puppet-python/pull/453) ([kenyon](https://github.com/kenyon))
- remove .DS\_Store [\#452](https://github.com/voxpupuli/puppet-python/pull/452) ([kenyon](https://github.com/kenyon))
- Change default indent to 2 Spaces in .editorconfig [\#449](https://github.com/voxpupuli/puppet-python/pull/449) ([jradmacher](https://github.com/jradmacher))
- Replace deprecated validate\_\* functions [\#443](https://github.com/voxpupuli/puppet-python/pull/443) ([baurmatt](https://github.com/baurmatt))
- Update modules with defined types for variables as described in docs/Add reference.md [\#440](https://github.com/voxpupuli/puppet-python/pull/440) ([danquack](https://github.com/danquack))

## [v2.2.2](https://github.com/voxpupuli/puppet-python/tree/v2.2.2) (2018-10-20)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/v2.2.0...v2.2.2)

**Closed issues:**

- Make a new release to the forge [\#437](https://github.com/voxpupuli/puppet-python/issues/437)

## [v2.2.0](https://github.com/voxpupuli/puppet-python/tree/v2.2.0) (2018-10-19)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/v2.1.1...v2.2.0)

**Implemented enhancements:**

- Add Ubuntu 18.04 support [\#399](https://github.com/voxpupuli/puppet-python/issues/399)
- Add ubuntu 18.04 support [\#426](https://github.com/voxpupuli/puppet-python/pull/426) ([danquack](https://github.com/danquack))

**Fixed bugs:**

- Pip: freeze all to be able to control setuptools, distribute, wheel, pip [\#418](https://github.com/voxpupuli/puppet-python/pull/418) ([Feandil](https://github.com/Feandil))

**Merged pull requests:**

- modulesync 2.2.0 and allow puppet 6.x [\#435](https://github.com/voxpupuli/puppet-python/pull/435) ([bastelfreak](https://github.com/bastelfreak))

## [v2.1.1](https://github.com/voxpupuli/puppet-python/tree/v2.1.1) (2018-08-20)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/v2.1.0...v2.1.1)

**Fixed bugs:**

- CentOS Acceptance testing, and more.... [\#424](https://github.com/voxpupuli/puppet-python/pull/424) ([danquack](https://github.com/danquack))

**Closed issues:**

- enable acceptance tests for centos [\#423](https://github.com/voxpupuli/puppet-python/issues/423)
- Run acceptance tests on travis [\#402](https://github.com/voxpupuli/puppet-python/issues/402)
- \[CentOS7 + Python 2.7\]: python::virtualenv fails [\#365](https://github.com/voxpupuli/puppet-python/issues/365)

**Merged pull requests:**

- Updated README for python::virtualenv [\#421](https://github.com/voxpupuli/puppet-python/pull/421) ([tprestegard](https://github.com/tprestegard))
- enable acceptance tests [\#419](https://github.com/voxpupuli/puppet-python/pull/419) ([bastelfreak](https://github.com/bastelfreak))

## [v2.1.0](https://github.com/voxpupuli/puppet-python/tree/v2.1.0) (2018-07-09)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- support for providing pip3 provider w/ tests. Modified readme 4 examples [\#414](https://github.com/voxpupuli/puppet-python/pull/414) ([danquack](https://github.com/danquack))

**Closed issues:**

- How to deploy pip package to rhscl python34 [\#377](https://github.com/voxpupuli/puppet-python/issues/377)
- CentOS 7 with Python3 does not work [\#303](https://github.com/voxpupuli/puppet-python/issues/303)

## [v2.0.0](https://github.com/voxpupuli/puppet-python/tree/v2.0.0) (2018-06-25)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.19.0...v2.0.0)

**Breaking changes:**

- Drop Puppet \<4.10 support [\#401](https://github.com/voxpupuli/puppet-python/issues/401)
- Drop Ruby 1.8 support [\#400](https://github.com/voxpupuli/puppet-python/issues/400)
- Drop EOL operatingsystem: Ubuntu 12.04 [\#397](https://github.com/voxpupuli/puppet-python/issues/397)
- Drop EOL operatingsystem: Ubuntu 10.04 [\#396](https://github.com/voxpupuli/puppet-python/issues/396)
- Drop EOL operatingsystem: Debian 7 [\#395](https://github.com/voxpupuli/puppet-python/issues/395)
- Drop EOL operatingsystem: Debian 6 [\#394](https://github.com/voxpupuli/puppet-python/issues/394)
- Drop EOL operatingsystem: CentOS 5 [\#393](https://github.com/voxpupuli/puppet-python/issues/393)

**Implemented enhancements:**

- Add Debian 9 Support [\#398](https://github.com/voxpupuli/puppet-python/issues/398)
- Add support for Anaconda [\#409](https://github.com/voxpupuli/puppet-python/pull/409) ([jb-abbadie](https://github.com/jb-abbadie))
- Add umask parameter to pip execs [\#368](https://github.com/voxpupuli/puppet-python/pull/368) ([jstaph](https://github.com/jstaph))

**Closed issues:**

- Activity on this project? [\#371](https://github.com/voxpupuli/puppet-python/issues/371)
- module is not compatible with setuptools v34 [\#361](https://github.com/voxpupuli/puppet-python/issues/361)
- So many Warnings [\#351](https://github.com/voxpupuli/puppet-python/issues/351)
- Spec tests time out with ruby 2.3.1 [\#336](https://github.com/voxpupuli/puppet-python/issues/336)
- how to used pip2.7 as provider in RHEL6 [\#290](https://github.com/voxpupuli/puppet-python/issues/290)
- Cannot determine if a package named in the form packagename\[subfeature\] is installed. [\#284](https://github.com/voxpupuli/puppet-python/issues/284)
- Pip install runs on every puppet run. [\#218](https://github.com/voxpupuli/puppet-python/issues/218)

**Merged pull requests:**

- Fix Python version regex in install.pp [\#410](https://github.com/voxpupuli/puppet-python/pull/410) ([fklajn](https://github.com/fklajn))
- Remove docker nodesets [\#408](https://github.com/voxpupuli/puppet-python/pull/408) ([bastelfreak](https://github.com/bastelfreak))
- Update README compatibility section [\#405](https://github.com/voxpupuli/puppet-python/pull/405) ([rkcpi](https://github.com/rkcpi))
- add secret for forge deployment via travis [\#404](https://github.com/voxpupuli/puppet-python/pull/404) ([bastelfreak](https://github.com/bastelfreak))
- Add deprecation notice for the old repository [\#403](https://github.com/voxpupuli/puppet-python/pull/403) ([stankevich](https://github.com/stankevich))
- virtualenv.pp: make creation of $venv\_dir optional [\#391](https://github.com/voxpupuli/puppet-python/pull/391) ([daylicron](https://github.com/daylicron))
- add pip support for setuptools extras [\#390](https://github.com/voxpupuli/puppet-python/pull/390) ([bryangwilliam](https://github.com/bryangwilliam))
- Fix pip wheel checks [\#389](https://github.com/voxpupuli/puppet-python/pull/389) ([genebean](https://github.com/genebean))

## [1.19.0](https://github.com/voxpupuli/puppet-python/tree/1.19.0) (2018-04-28)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.18.2...1.19.0)

**Closed issues:**

- travis build failures since december? [\#372](https://github.com/voxpupuli/puppet-python/issues/372)
- python-pip has been renamed to python2-pip on el7 epel repo [\#348](https://github.com/voxpupuli/puppet-python/issues/348)
- --no-use-wheel renamed to --no-binary :all: in pip 7.0 and newer [\#309](https://github.com/voxpupuli/puppet-python/issues/309)
- duplicate resource [\#259](https://github.com/voxpupuli/puppet-python/issues/259)
- python::virtualenv does not accept the string 'pip' as per the documentation [\#205](https://github.com/voxpupuli/puppet-python/issues/205)

**Merged pull requests:**

- fix for latest versions of setuptools and pip [\#388](https://github.com/voxpupuli/puppet-python/pull/388) ([vchepkov](https://github.com/vchepkov))
- Fix tests: Pin rake for ruby 1.9.3 [\#387](https://github.com/voxpupuli/puppet-python/pull/387) ([waipeng](https://github.com/waipeng))
- Support virtualenv for Ubuntu 16.04 [\#386](https://github.com/voxpupuli/puppet-python/pull/386) ([waipeng](https://github.com/waipeng))
- Set virtualenv package name for Debian stretch [\#383](https://github.com/voxpupuli/puppet-python/pull/383) ([sergiik](https://github.com/sergiik))
- Update gunicorn.pp - Add manage\_config\_dir [\#382](https://github.com/voxpupuli/puppet-python/pull/382) ([bc-bjoern](https://github.com/bc-bjoern))
- Support latest puppet versions [\#376](https://github.com/voxpupuli/puppet-python/pull/376) ([ghoneycutt](https://github.com/ghoneycutt))
- Add python release as available facts [\#355](https://github.com/voxpupuli/puppet-python/pull/355) ([jcpunk](https://github.com/jcpunk))
- Allow hiera config for dotfiles [\#344](https://github.com/voxpupuli/puppet-python/pull/344) ([chaozhang0326](https://github.com/chaozhang0326))
- Ensure value is a string for =~ comparison [\#342](https://github.com/voxpupuli/puppet-python/pull/342) ([ghoneycutt](https://github.com/ghoneycutt))
- add an alias to the python-dev package [\#334](https://github.com/voxpupuli/puppet-python/pull/334) ([dannygoulder](https://github.com/dannygoulder))

## [1.18.2](https://github.com/voxpupuli/puppet-python/tree/1.18.2) (2016-12-12)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.18.1...1.18.2)

**Closed issues:**

- EPEL7 python-pip package is called python2-pip; puppet-python won't recognize that it is installed [\#346](https://github.com/voxpupuli/puppet-python/issues/346)

**Merged pull requests:**

- Improve support for pip on CentOS7/EPEL [\#347](https://github.com/voxpupuli/puppet-python/pull/347) ([ju5t](https://github.com/ju5t))

## [1.18.1](https://github.com/voxpupuli/puppet-python/tree/1.18.1) (2016-12-08)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.4.2...1.18.1)

**Closed issues:**

- New release on the forge? [\#339](https://github.com/voxpupuli/puppet-python/issues/339)

**Merged pull requests:**

- Fix testing [\#345](https://github.com/voxpupuli/puppet-python/pull/345) ([ghoneycutt](https://github.com/ghoneycutt))
- Add name of package to pip uninstall command [\#340](https://github.com/voxpupuli/puppet-python/pull/340) ([dontreboot](https://github.com/dontreboot))
- EPEL only makes sense on RH systems but not Fedora [\#297](https://github.com/voxpupuli/puppet-python/pull/297) ([jcpunk](https://github.com/jcpunk))

## [2.4.2](https://github.com/voxpupuli/puppet-python/tree/2.4.2) (2016-10-28)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.18.0...2.4.2)

## [1.18.0](https://github.com/voxpupuli/puppet-python/tree/1.18.0) (2016-10-12)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.4.1...1.18.0)

**Merged pull requests:**

- Allow failure for Ruby 2.3.1 [\#337](https://github.com/voxpupuli/puppet-python/pull/337) ([ghoneycutt](https://github.com/ghoneycutt))
- Add support, tests and documentation for Gentoo [\#335](https://github.com/voxpupuli/puppet-python/pull/335) ([optiz0r](https://github.com/optiz0r))

## [2.4.1](https://github.com/voxpupuli/puppet-python/tree/2.4.1) (2016-09-19)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.17.0...2.4.1)

## [1.17.0](https://github.com/voxpupuli/puppet-python/tree/1.17.0) (2016-09-16)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.16.0...1.17.0)

**Closed issues:**

- No tags [\#330](https://github.com/voxpupuli/puppet-python/issues/330)

**Merged pull requests:**

- Fix unescaped backslash in previous pip list addition [\#332](https://github.com/voxpupuli/puppet-python/pull/332) ([rikwasmus](https://github.com/rikwasmus))
- Do not try to reinstall packages installed via the OS [\#331](https://github.com/voxpupuli/puppet-python/pull/331) ([rikwasmus](https://github.com/rikwasmus))

## [1.16.0](https://github.com/voxpupuli/puppet-python/tree/1.16.0) (2016-09-10)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.4.0...1.16.0)

**Merged pull requests:**

- RHSCL Repository installation made optional [\#328](https://github.com/voxpupuli/puppet-python/pull/328) ([diLLec](https://github.com/diLLec))

## [2.4.0](https://github.com/voxpupuli/puppet-python/tree/2.4.0) (2016-09-04)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.3.1...2.4.0)

## [2.3.1](https://github.com/voxpupuli/puppet-python/tree/2.3.1) (2016-08-29)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.3.0...2.3.1)

## [2.3.0](https://github.com/voxpupuli/puppet-python/tree/2.3.0) (2016-08-29)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.15.0...2.3.0)

## [1.15.0](https://github.com/voxpupuli/puppet-python/tree/1.15.0) (2016-08-24)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.14.2...1.15.0)

**Merged pull requests:**

- Strict vars [\#299](https://github.com/voxpupuli/puppet-python/pull/299) ([ghoneycutt](https://github.com/ghoneycutt))

## [1.14.2](https://github.com/voxpupuli/puppet-python/tree/1.14.2) (2016-08-23)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.14.1...1.14.2)

**Merged pull requests:**

- Add support for Ruby 2.3.1 [\#326](https://github.com/voxpupuli/puppet-python/pull/326) ([ghoneycutt](https://github.com/ghoneycutt))

## [1.14.1](https://github.com/voxpupuli/puppet-python/tree/1.14.1) (2016-08-22)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.14.0...1.14.1)

**Closed issues:**

- Not using index when doing pip search for latest [\#321](https://github.com/voxpupuli/puppet-python/issues/321)
- regex for pip explicit version \( ensure =\> '1.0a1' \) broken [\#310](https://github.com/voxpupuli/puppet-python/issues/310)
- python::pip install args needs extra space to separate multiple args [\#162](https://github.com/voxpupuli/puppet-python/issues/162)

**Merged pull requests:**

- Fix travis [\#324](https://github.com/voxpupuli/puppet-python/pull/324) ([ghoneycutt](https://github.com/ghoneycutt))
- Search index when staying at the latest version [\#322](https://github.com/voxpupuli/puppet-python/pull/322) ([mterzo](https://github.com/mterzo))
- Use a single grep instead of a double pipe [\#320](https://github.com/voxpupuli/puppet-python/pull/320) ([rcalixte](https://github.com/rcalixte))
- Add "args" option to gunicorn config [\#319](https://github.com/voxpupuli/puppet-python/pull/319) ([kronos-pbrideau](https://github.com/kronos-pbrideau))
- Patch to support Centos 7 in bootstrap [\#318](https://github.com/voxpupuli/puppet-python/pull/318) ([asasfu](https://github.com/asasfu))

## [1.14.0](https://github.com/voxpupuli/puppet-python/tree/1.14.0) (2016-07-20)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.2.1...1.14.0)

**Merged pull requests:**

- Fix regex for pip package versions [\#317](https://github.com/voxpupuli/puppet-python/pull/317) ([mdean](https://github.com/mdean))

## [2.2.1](https://github.com/voxpupuli/puppet-python/tree/2.2.1) (2016-07-20)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.13.0...2.2.1)

## [1.13.0](https://github.com/voxpupuli/puppet-python/tree/1.13.0) (2016-07-18)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.2.0...1.13.0)

**Closed issues:**

- SCL package installation returns an error [\#308](https://github.com/voxpupuli/puppet-python/issues/308)
- Can't install pip3 with Ubuntu [\#287](https://github.com/voxpupuli/puppet-python/issues/287)
- SCL python27: add a workaround for libpython2.7.so.1.0 issue \(LD\_LIBRARY\_PATH\) [\#234](https://github.com/voxpupuli/puppet-python/issues/234)

**Merged pull requests:**

- Set gunicorn package name on RedHat family [\#316](https://github.com/voxpupuli/puppet-python/pull/316) ([kronos-pbrideau](https://github.com/kronos-pbrideau))
- Tweaks to get travis ci tests working again [\#315](https://github.com/voxpupuli/puppet-python/pull/315) ([mbmilligan](https://github.com/mbmilligan))
-  fix pip failing in virtualenv under SCL [\#314](https://github.com/voxpupuli/puppet-python/pull/314) ([mbmilligan](https://github.com/mbmilligan))
- Ubuntu 16.04 has a + in python -V output at the end of version. [\#313](https://github.com/voxpupuli/puppet-python/pull/313) ([KlavsKlavsen](https://github.com/KlavsKlavsen))
- use 'version' name specified directly [\#312](https://github.com/voxpupuli/puppet-python/pull/312) ([epleterte](https://github.com/epleterte))
- Lowercase package name for centos-release-scl [\#304](https://github.com/voxpupuli/puppet-python/pull/304) ([prozach](https://github.com/prozach))
- Fixed missing comma in \#301 [\#302](https://github.com/voxpupuli/puppet-python/pull/302) ([steverecio](https://github.com/steverecio))
- Configure workers [\#301](https://github.com/voxpupuli/puppet-python/pull/301) ([steverecio](https://github.com/steverecio))
- Fix support for Ruby 1.8.7 [\#298](https://github.com/voxpupuli/puppet-python/pull/298) ([ghoneycutt](https://github.com/ghoneycutt))

## [2.2.0](https://github.com/voxpupuli/puppet-python/tree/2.2.0) (2016-05-31)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.1.0...2.2.0)

## [2.1.0](https://github.com/voxpupuli/puppet-python/tree/2.1.0) (2016-05-29)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.0.2...2.1.0)

## [2.0.2](https://github.com/voxpupuli/puppet-python/tree/2.0.2) (2016-05-22)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.0.1...2.0.2)

## [2.0.1](https://github.com/voxpupuli/puppet-python/tree/2.0.1) (2016-05-19)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/2.0.0...2.0.1)

## [2.0.0](https://github.com/voxpupuli/puppet-python/tree/2.0.0) (2016-05-19)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.12.0...2.0.0)

**Closed issues:**

- Patch Release [\#295](https://github.com/voxpupuli/puppet-python/issues/295)

## [1.12.0](https://github.com/voxpupuli/puppet-python/tree/1.12.0) (2016-03-27)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.11.0...1.12.0)

**Closed issues:**

- Puppet-lint prints warnings  [\#289](https://github.com/voxpupuli/puppet-python/issues/289)
- Release a new version? [\#285](https://github.com/voxpupuli/puppet-python/issues/285)
- pip is installed on every invocation when pip is installed from pip [\#256](https://github.com/voxpupuli/puppet-python/issues/256)

**Merged pull requests:**

- Correct use of version param as it relates to package installation [\#293](https://github.com/voxpupuli/puppet-python/pull/293) ([evidex](https://github.com/evidex))
- Fix linting issues from \#289 [\#292](https://github.com/voxpupuli/puppet-python/pull/292) ([evidex](https://github.com/evidex))
- bugfix: test if virtualenv\_version is defined [\#288](https://github.com/voxpupuli/puppet-python/pull/288) ([vicinus](https://github.com/vicinus))
- Fixes \#256 [\#286](https://github.com/voxpupuli/puppet-python/pull/286) ([joshuaspence](https://github.com/joshuaspence))

## [1.11.0](https://github.com/voxpupuli/puppet-python/tree/1.11.0) (2016-01-31)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.10.0...1.11.0)

**Closed issues:**

- installing virtualenv broken in master [\#271](https://github.com/voxpupuli/puppet-python/issues/271)
- puppet not install the latest version of pip [\#268](https://github.com/voxpupuli/puppet-python/issues/268)
- Call, 'versioncmp' parameter 'a' expects a String value, got Undef [\#262](https://github.com/voxpupuli/puppet-python/issues/262)
- pip install runs every time for packages with underscores in the name [\#258](https://github.com/voxpupuli/puppet-python/issues/258)
- New version release? [\#257](https://github.com/voxpupuli/puppet-python/issues/257)

**Merged pull requests:**

- add SCL specific exec\_prefix [\#283](https://github.com/voxpupuli/puppet-python/pull/283) ([iakovgan](https://github.com/iakovgan))
- python::pip expects \(un\)install-args to be strings [\#282](https://github.com/voxpupuli/puppet-python/pull/282) ([adamcstephens](https://github.com/adamcstephens))
- Made virtualenv compatible with RHSCL/SCL [\#281](https://github.com/voxpupuli/puppet-python/pull/281) ([chrisfu](https://github.com/chrisfu))
- Force virtualenv\_version to be a string. [\#280](https://github.com/voxpupuli/puppet-python/pull/280) ([dansajner](https://github.com/dansajner))
- Update README to reflect actual defaults [\#279](https://github.com/voxpupuli/puppet-python/pull/279) ([ColinHebert](https://github.com/ColinHebert))
- Add parameter path to pip manifest [\#277](https://github.com/voxpupuli/puppet-python/pull/277) ([BasLangenberg](https://github.com/BasLangenberg))
- add configurable log level for gunicorn and unit tests [\#275](https://github.com/voxpupuli/puppet-python/pull/275) ([xaniasd](https://github.com/xaniasd))
- new manage\_requirements argument to address issue 273 [\#274](https://github.com/voxpupuli/puppet-python/pull/274) ([rosenbergj](https://github.com/rosenbergj))
- bugfix install pip on centos6 using scl [\#270](https://github.com/voxpupuli/puppet-python/pull/270) ([netors](https://github.com/netors))
- fixed python dev install when using scl [\#269](https://github.com/voxpupuli/puppet-python/pull/269) ([netors](https://github.com/netors))
- Revert "Update virtualenv\_version.rb" [\#267](https://github.com/voxpupuli/puppet-python/pull/267) ([shivapoudel](https://github.com/shivapoudel))
- Update virtualenv\_version.rb [\#265](https://github.com/voxpupuli/puppet-python/pull/265) ([shivapoudel](https://github.com/shivapoudel))
- Update params.pp [\#263](https://github.com/voxpupuli/puppet-python/pull/263) ([philippeback](https://github.com/philippeback))
- Bug virtualenv instead of virtualenv-$version [\#261](https://github.com/voxpupuli/puppet-python/pull/261) ([Asher256](https://github.com/Asher256))
- Addressing stankevich/puppet-python issue \#258. [\#260](https://github.com/voxpupuli/puppet-python/pull/260) ([rpocase](https://github.com/rpocase))

## [1.10.0](https://github.com/voxpupuli/puppet-python/tree/1.10.0) (2015-10-29)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.9.8...1.10.0)

**Closed issues:**

- known puppet bug on CentOS/RHEL 6/7 [\#225](https://github.com/voxpupuli/puppet-python/issues/225)

**Merged pull requests:**

- RedHat has different virtualenv packages for different pythons [\#255](https://github.com/voxpupuli/puppet-python/pull/255) ([adamcstephens](https://github.com/adamcstephens))
- Create symlink for pip-python with pip provider [\#254](https://github.com/voxpupuli/puppet-python/pull/254) ([skpy](https://github.com/skpy))
- use full path on commands [\#253](https://github.com/voxpupuli/puppet-python/pull/253) ([skpy](https://github.com/skpy))
- Allow setting a custom index for `python::pip` [\#251](https://github.com/voxpupuli/puppet-python/pull/251) ([joshuaspence](https://github.com/joshuaspence))

## [1.9.8](https://github.com/voxpupuli/puppet-python/tree/1.9.8) (2015-09-19)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.9.7...1.9.8)

**Closed issues:**

- Unable to install pip using pip provider [\#243](https://github.com/voxpupuli/puppet-python/issues/243)
- Not possible to install latest version of Python [\#240](https://github.com/voxpupuli/puppet-python/issues/240)

**Merged pull requests:**

- Fix RSpec deprecated messages [\#250](https://github.com/voxpupuli/puppet-python/pull/250) ([tremblaysimon](https://github.com/tremblaysimon))
- Minor improvement for bootstrapped pip installation [\#249](https://github.com/voxpupuli/puppet-python/pull/249) ([joshuaspence](https://github.com/joshuaspence))
- Fix an issue with gunicorn [\#248](https://github.com/voxpupuli/puppet-python/pull/248) ([joshuaspence](https://github.com/joshuaspence))
- Support group parameter for python::pip resource [\#247](https://github.com/voxpupuli/puppet-python/pull/247) ([tremblaysimon](https://github.com/tremblaysimon))
- Various tidying up [\#246](https://github.com/voxpupuli/puppet-python/pull/246) ([joshuaspence](https://github.com/joshuaspence))
- Bootstrap pip installation [\#244](https://github.com/voxpupuli/puppet-python/pull/244) ([joshuaspence](https://github.com/joshuaspence))
- Various tidying up [\#242](https://github.com/voxpupuli/puppet-python/pull/242) ([joshuaspence](https://github.com/joshuaspence))
- Allow custom versions to be installed [\#241](https://github.com/voxpupuli/puppet-python/pull/241) ([joshuaspence](https://github.com/joshuaspence))
- Check that we have results before returning a value [\#238](https://github.com/voxpupuli/puppet-python/pull/238) ([xaque208](https://github.com/xaque208))
- Adjust test code to pass syntax checker [\#237](https://github.com/voxpupuli/puppet-python/pull/237) ([fluential](https://github.com/fluential))

## [1.9.7](https://github.com/voxpupuli/puppet-python/tree/1.9.7) (2015-08-21)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.9.6...1.9.7)

**Closed issues:**

- Exec\<| tag == 'python-virtualenv' |\> changes and breaks the API [\#230](https://github.com/voxpupuli/puppet-python/issues/230)

## [1.9.6](https://github.com/voxpupuli/puppet-python/tree/1.9.6) (2015-08-01)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.9.5...1.9.6)

**Implemented enhancements:**

- Manage compilers? [\#118](https://github.com/voxpupuli/puppet-python/issues/118)

**Fixed bugs:**

- Dupilicate declaration for requirement file [\#112](https://github.com/voxpupuli/puppet-python/issues/112)
- Resource order restrictions? [\#76](https://github.com/voxpupuli/puppet-python/issues/76)

**Closed issues:**

- May attempt to create virtualenvs before package install [\#215](https://github.com/voxpupuli/puppet-python/issues/215)
- virtualenv does not use SCL path from environment [\#212](https://github.com/voxpupuli/puppet-python/issues/212)
- Cut a new release [\#206](https://github.com/voxpupuli/puppet-python/issues/206)
- Doesn't work with python3 [\#204](https://github.com/voxpupuli/puppet-python/issues/204)
- Unable to use virtualenv in Debian Jessie [\#194](https://github.com/voxpupuli/puppet-python/issues/194)
- Support for SCL? [\#189](https://github.com/voxpupuli/puppet-python/issues/189)
- I am trying to install python version 2.7, It doesn't work.  [\#185](https://github.com/voxpupuli/puppet-python/issues/185)
- facts broken on all systems [\#184](https://github.com/voxpupuli/puppet-python/issues/184)
- Documentation conflicts itself on whether or not pip must be explictly specified. [\#160](https://github.com/voxpupuli/puppet-python/issues/160)

## [1.9.5](https://github.com/voxpupuli/puppet-python/tree/1.9.5) (2015-07-05)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.9.4...1.9.5)

**Implemented enhancements:**

- include epel for RedHat [\#115](https://github.com/voxpupuli/puppet-python/issues/115)

**Closed issues:**

- python-pip requires EPEL on Redhat/CentOs 6 and 7 [\#196](https://github.com/voxpupuli/puppet-python/issues/196)
- Is it possible to add a support for ipython? [\#195](https://github.com/voxpupuli/puppet-python/issues/195)
- New Feature: Pip installing specific version/tag out of VCS? [\#149](https://github.com/voxpupuli/puppet-python/issues/149)

## [1.9.4](https://github.com/voxpupuli/puppet-python/tree/1.9.4) (2015-04-17)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.9.3...1.9.4)

## [1.9.3](https://github.com/voxpupuli/puppet-python/tree/1.9.3) (2015-04-17)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.9.2...1.9.3)

**Closed issues:**

- Bump Version [\#190](https://github.com/voxpupuli/puppet-python/issues/190)

## [1.9.2](https://github.com/voxpupuli/puppet-python/tree/1.9.2) (2015-04-17)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.9.1...1.9.2)

## [1.9.1](https://github.com/voxpupuli/puppet-python/tree/1.9.1) (2015-03-27)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.9.0...1.9.1)

**Closed issues:**

- python::pip hangs with ensure "latest" behind a proxy server [\#170](https://github.com/voxpupuli/puppet-python/issues/170)
- Parameter cwd failed on Exec\[pip\_install\_rpyc\]: cwd must be a fully qualified path [\#165](https://github.com/voxpupuli/puppet-python/issues/165)
- 'require puppet' forces puppet to load pre-maturely [\#163](https://github.com/voxpupuli/puppet-python/issues/163)

## [1.9.0](https://github.com/voxpupuli/puppet-python/tree/1.9.0) (2015-03-18)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.8.3...1.9.0)

**Fixed bugs:**

- virtualenv broken for python3 [\#24](https://github.com/voxpupuli/puppet-python/issues/24)

**Closed issues:**

- Missing Gunicorn Parameters [\#167](https://github.com/voxpupuli/puppet-python/issues/167)
- python::pip downgrade to older versions fails [\#150](https://github.com/voxpupuli/puppet-python/issues/150)

## [1.8.3](https://github.com/voxpupuli/puppet-python/tree/1.8.3) (2015-02-04)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.8.2...1.8.3)

**Implemented enhancements:**

- Manage Python related .dotfiles \(for a user\) [\#87](https://github.com/voxpupuli/puppet-python/issues/87)

## [1.8.2](https://github.com/voxpupuli/puppet-python/tree/1.8.2) (2014-12-03)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.8.1...1.8.2)

## [1.8.1](https://github.com/voxpupuli/puppet-python/tree/1.8.1) (2014-12-02)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.8.0...1.8.1)

## [1.8.0](https://github.com/voxpupuli/puppet-python/tree/1.8.0) (2014-11-30)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.16...1.8.0)

**Closed issues:**

- Facts cannot be loaded on the first puppet run due to missing rubygems gem [\#153](https://github.com/voxpupuli/puppet-python/issues/153)
- Please publish a new version in forge [\#152](https://github.com/voxpupuli/puppet-python/issues/152)
- Could not retrieve local facts: uninitialized constant Gem [\#151](https://github.com/voxpupuli/puppet-python/issues/151)

## [1.7.16](https://github.com/voxpupuli/puppet-python/tree/1.7.16) (2014-11-20)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.15...1.7.16)

**Implemented enhancements:**

- Installing pip module via github [\#81](https://github.com/voxpupuli/puppet-python/issues/81)

**Fixed bugs:**

- python::pip Specifying a local path in url fails [\#91](https://github.com/voxpupuli/puppet-python/issues/91)

**Closed issues:**

- puppet-python fails to run on Ubuntu 12.04 [\#145](https://github.com/voxpupuli/puppet-python/issues/145)
- Specify package versions [\#144](https://github.com/voxpupuli/puppet-python/issues/144)
- Compatibility with puppet 2.7? [\#139](https://github.com/voxpupuli/puppet-python/issues/139)

## [1.7.15](https://github.com/voxpupuli/puppet-python/tree/1.7.15) (2014-11-04)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.14...1.7.15)

**Closed issues:**

- Invalid parameter allow\_virtual [\#140](https://github.com/voxpupuli/puppet-python/issues/140)

## [1.7.14](https://github.com/voxpupuli/puppet-python/tree/1.7.14) (2014-10-30)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.13...1.7.14)

**Closed issues:**

- Gunicorn timeout hardcoded in template [\#137](https://github.com/voxpupuli/puppet-python/issues/137)
- Problem with Package defaults warning [\#122](https://github.com/voxpupuli/puppet-python/issues/122)

## [1.7.13](https://github.com/voxpupuli/puppet-python/tree/1.7.13) (2014-10-22)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.12...1.7.13)

**Closed issues:**

- Gunicorn does not allow passing in a list of environment variables [\#132](https://github.com/voxpupuli/puppet-python/issues/132)

## [1.7.12](https://github.com/voxpupuli/puppet-python/tree/1.7.12) (2014-10-18)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.11...1.7.12)

**Closed issues:**

- 'system' or any other version of python doesn't work, doesn't get validated [\#129](https://github.com/voxpupuli/puppet-python/issues/129)
- Could not look up qualified variable '::python::install::valid\_versions' [\#126](https://github.com/voxpupuli/puppet-python/issues/126)

## [1.7.11](https://github.com/voxpupuli/puppet-python/tree/1.7.11) (2014-10-11)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.10...1.7.11)

**Closed issues:**

- Unable to customize `APP_MODULE` variable in gunicorn template [\#127](https://github.com/voxpupuli/puppet-python/issues/127)
- New release on the Puppet forge [\#125](https://github.com/voxpupuli/puppet-python/issues/125)

## [1.7.10](https://github.com/voxpupuli/puppet-python/tree/1.7.10) (2014-09-25)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.9...1.7.10)

**Implemented enhancements:**

- Add support to python-pyenv [\#113](https://github.com/voxpupuli/puppet-python/issues/113)
- Multiple python versions [\#79](https://github.com/voxpupuli/puppet-python/issues/79)
- use ensure\_packages [\#68](https://github.com/voxpupuli/puppet-python/issues/68)
- Allow extra flags when installing from requirement file [\#66](https://github.com/voxpupuli/puppet-python/issues/66)

**Fixed bugs:**

- There is listing of 2 similar depedency [\#111](https://github.com/voxpupuli/puppet-python/issues/111)

**Closed issues:**

- pip =\> true, but no python-pip installed on CentOS 6.5 [\#124](https://github.com/voxpupuli/puppet-python/issues/124)
- Could not match $\(ensure at pip.pp:104 [\#123](https://github.com/voxpupuli/puppet-python/issues/123)
- Add the forge module link in github project [\#110](https://github.com/voxpupuli/puppet-python/issues/110)
- Add support to travis-ci build status [\#106](https://github.com/voxpupuli/puppet-python/issues/106)
- Could not start Service\[gunicorn\] [\#83](https://github.com/voxpupuli/puppet-python/issues/83)
- python::pip - empty pkgname is silently ignored [\#67](https://github.com/voxpupuli/puppet-python/issues/67)
- python::requirements interferes with managing requirements.txt if not explicitly in a file resource [\#64](https://github.com/voxpupuli/puppet-python/issues/64)
- Manifests using the module aren't testable in windows [\#27](https://github.com/voxpupuli/puppet-python/issues/27)
- Can not install the same packages in different virtualenvs [\#18](https://github.com/voxpupuli/puppet-python/issues/18)

## [1.7.9](https://github.com/voxpupuli/puppet-python/tree/1.7.9) (2014-08-10)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.8...1.7.9)

## [1.7.8](https://github.com/voxpupuli/puppet-python/tree/1.7.8) (2014-07-31)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.7...1.7.8)

**Closed issues:**

- Need sudo to install pip [\#96](https://github.com/voxpupuli/puppet-python/issues/96)
- virtualenv / systempkgs and fact precedence [\#94](https://github.com/voxpupuli/puppet-python/issues/94)

## [1.7.7](https://github.com/voxpupuli/puppet-python/tree/1.7.7) (2014-07-17)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.6...1.7.7)

**Closed issues:**

- Need a better way to deal with wheels when using pip [\#53](https://github.com/voxpupuli/puppet-python/issues/53)
- Wheel support? [\#10](https://github.com/voxpupuli/puppet-python/issues/10)

## [1.7.6](https://github.com/voxpupuli/puppet-python/tree/1.7.6) (2014-07-07)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.5...1.7.6)

## [1.7.5](https://github.com/voxpupuli/puppet-python/tree/1.7.5) (2014-05-07)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.4...1.7.5)

## [1.7.4](https://github.com/voxpupuli/puppet-python/tree/1.7.4) (2014-04-24)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.3...1.7.4)

## [1.7.3](https://github.com/voxpupuli/puppet-python/tree/1.7.3) (2014-04-24)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.2...1.7.3)

## [1.7.2](https://github.com/voxpupuli/puppet-python/tree/1.7.2) (2014-04-08)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.1...1.7.2)

**Closed issues:**

- Remove redundant pkgname [\#74](https://github.com/voxpupuli/puppet-python/issues/74)
- Facter scripts raise warnings [\#69](https://github.com/voxpupuli/puppet-python/issues/69)

## [1.7.1](https://github.com/voxpupuli/puppet-python/tree/1.7.1) (2014-03-25)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.7.0...1.7.1)

## [1.7.0](https://github.com/voxpupuli/puppet-python/tree/1.7.0) (2014-03-18)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.6.6...1.7.0)

**Closed issues:**

- pip wheel error [\#70](https://github.com/voxpupuli/puppet-python/issues/70)
- Don't try to reinstall pip packages on every Puppet run [\#59](https://github.com/voxpupuli/puppet-python/issues/59)

## [1.6.6](https://github.com/voxpupuli/puppet-python/tree/1.6.6) (2014-03-06)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.6.5...1.6.6)

## [1.6.5](https://github.com/voxpupuli/puppet-python/tree/1.6.5) (2014-03-06)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/1.6.4...1.6.5)

**Closed issues:**

- Versions are not tagged in github as in puppet forge [\#63](https://github.com/voxpupuli/puppet-python/issues/63)

## [1.6.4](https://github.com/voxpupuli/puppet-python/tree/1.6.4) (2014-03-06)

[Full Changelog](https://github.com/voxpupuli/puppet-python/compare/ed137893babebabdfdb5adf44d1a52272093ce8b...1.6.4)

**Closed issues:**

- Could not retrieve pip\_version: undefined method [\#61](https://github.com/voxpupuli/puppet-python/issues/61)
- New release on the forge? [\#58](https://github.com/voxpupuli/puppet-python/issues/58)
- If virtualenv isn't installed, it isn't properly detected or installed. [\#50](https://github.com/voxpupuli/puppet-python/issues/50)
- IOError: \[Errno 26\] Text file busy [\#46](https://github.com/voxpupuli/puppet-python/issues/46)
- Add support for Scientific Linux [\#39](https://github.com/voxpupuli/puppet-python/issues/39)
- python::pip doesn't find pip command [\#31](https://github.com/voxpupuli/puppet-python/issues/31)
- Incorrect log file name option in pip command [\#28](https://github.com/voxpupuli/puppet-python/issues/28)
- Resource failed with ArgumentError [\#26](https://github.com/voxpupuli/puppet-python/issues/26)
- Upload to the forge [\#25](https://github.com/voxpupuli/puppet-python/issues/25)



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
