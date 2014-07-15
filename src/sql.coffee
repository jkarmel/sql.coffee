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
      \s\((.*)\)                  # match table definition
      ///i
    if match = statement.match createTableRegex
      [fullMatch, tableName, tableDefinition] = match
      definition = for columnDefinition in tableDefinition.split ','
        [columnName, columnTypeDefinition] = columnDefinition.split ' '
        columnType = switch
          when columnTypeDefinition.match 'varchar'
            {
              name: columnName
              type: 'character varying'
              params:
                maxLength: parseInt columnTypeDefinition.match(/\(([0-9]*)\)/)[1]
            }

      db.tables[tableName] = {
        definition
      }

module.exports = sql
