sql =
  exec: (statement) ->
    createDatabaseRegex = /^create database (\b.*\b)/i
    if statement.match createDatabaseRegex
      {
        name: statement.match(createDatabaseRegex)[1]
        exec: (statement) ->
          sql.dbExec(@, statement)
        tables: {}
      }
  dbExec: (db, statement) ->
    createTableRegex = ///
      ^create\stable               # match CREATE TABLE
      \s(\b[a-zA-A_]*\b)           # match table name
      \s(\(.*\))                  # match table definition
      ///i
    if match = statement.match createTableRegex
      [fullMatch, tableName, tableDefinition] = match
      db.tables[tableName] = {}

module.exports = sql
