# @summary A version type to ensure a specific Pip version in a virtual env.
#
type Python::Venv::PipVersion = Pattern[
  /^(<|>|<=|>=|==) [0-9]*(\.[0-9]+)*$/,
  /\Alatest\Z/
]
