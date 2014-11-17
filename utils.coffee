###
converts Date to a string in format YYYY-MM-DD HH:MM:SS (2014-12-31 23:59:59)
###
exports.formatDate = (date) ->
  return date.toISOString().replace(/T/, ' ').replace(/\..+/, '')

###
returns start of interval as a number of milliseconds since 1 January 1970 00:00:00 UTC
###
exports.intervalStart = (intervalLength, date) ->
  date = new Date() unless date?
  timestamp = date.getTime()
  return timestamp - (timestamp % intervalLength)
