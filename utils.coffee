###
converts Date to a string in format YYYY-MM-DD HH:MM:SS (2014-12-31 23:59:59)
###
exports.formatDate = (date) ->
  return date.toISOString().replace(/T/, ' ').replace(/\..+/, '')
