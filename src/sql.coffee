sql =
  exec: (statement) ->
    createDatabaseRegex = /^create database (\b.*\b)/i
    if statement.match createDatabaseRegex
      {
        name: statement.match(createDatabaseRegex)[1]
      }


module.exports = sql
