# @summary A version type to match all valid package ensures for python
#
type Python::Package::Ensure = Enum['absent', 'present', 'latest']
