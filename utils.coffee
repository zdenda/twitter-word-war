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

###
converts a string representing time from Twitter API to Date
###
exports.parseTwitterDate = (string) ->
  #sample: Wed Aug 27 13:08:45 +0000 2008
  return new Date(Date.parse(string.replace(/( \+)/, ' UTC$1')));

###
searches haystack for needle
###
exports.search = (needle, haystack) ->
  re = new RegExp(needle, 'i')
  return haystack.match(re)
