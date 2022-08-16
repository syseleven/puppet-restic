# @summary Valid path parameter
#
#
type Restic::Secure = Variant[
  String,
  Sensitive[String],
]
