# @summary Valid path parameter
#
#
type Restic::Path = Variant[
  Stdlib::Absolutepath,
  Array[Stdlib::Absolutepath],
]
