# @summary All valid forget parameter
#
#
type Restic::Forget = Hash[
  Enum['keep-last','keep-hourly','keep-daily','keep-weekly','keep-monthly','keep-yearly','keep-within','keep-tag'],
  Integer[1],
]
