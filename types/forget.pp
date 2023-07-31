# @summary All valid forget parameter
#
#
type Restic::Forget = Hash[
  Enum['keep-last','keep-hourly','keep-daily','keep-weekly','keep-monthly','keep-yearly','keep-within','keep-within-hourly','keep-within-daily','keep-within-weekly','keep-within-monthly','keep-within-yearly','keep-tag'],
  Variant[Integer[1],String[1]],
]
