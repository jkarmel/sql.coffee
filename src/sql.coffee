_str = require 'underscore.string'

CREATE_TABLE_REGEX = ///
  ^create\stable               # match CREATE TABLE
  \s(\b[a-zA-A_]*\b)           # match table name
  \s\((.*)\)                  # match table definition
///i

INSERT_INTO_REGEX = ///
  ^insert\sinto
  \s(\b[a-zA-A_]*\b)           # match table name
  \s\((.*)\)                   # match table definition
  \svalues
  \s\((.*)\)                   # match table definition
///i

SELECT_REGEX = ///
  ^select\s\*\sfrom
  \s(\b[a-zA-A_]*\b)           # match table name
///i


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
    if statement.match CREATE_TABLE_REGEX
      sql.createTable db, statement
    if statement.match INSERT_INTO_REGEX
      sql.insertInto db, statement
    if statement.match SELECT_REGEX
      sql.select db, statement

  createTable: (db, statement) ->
    match = statement.match CREATE_TABLE_REGEX
    [fullMatch, tableName, tableDefinition] = match
    definition = for columnDefinition in tableDefinition.split ','
      [columnName, columnTypeDefinition] = _str.trim(columnDefinition).split ' '
      columnType = switch
        when columnTypeDefinition.match /varchar/
          name: columnName
          type: 'character varying'
          params:
            maxLength: parseInt columnTypeDefinition.match(/\(([0-9]*)\)/)[1]
        when columnTypeDefinition.match /int/
          name: columnName
          type: 'int'


    db.tables[tableName] = {
      definition
      data: []
    }

  insertInto: (db, statement) ->
    parseVals = (string) ->
      trimed = _str.trim string
      if parseInt(trimed).toString() is trimed
        parseInt trimed
      else
        trimed.match(/\'(.*)\'/)[1]
    [
      fullMatch
      tableName
      columnsString
      valuesString
    ] = statement.match INSERT_INTO_REGEX
    valuesString
    columns = columnsString.split ' '
    values = valuesString.split(',').map(parseVals)
    db.tables[tableName].data.push values

  select: (db, statement) ->
    tableName = statement.match(SELECT_REGEX)[1]
    db.tables[tableName].data


module.exports = sql
