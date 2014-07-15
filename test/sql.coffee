assert = require 'assert'
sql = require '../src/sql'

describe 'sql', ->
  describe 'CREATE DATABASE', ->
    it 'should take a database name and return a database object', ->
      dbName = "FirstDB"
      db = sql.exec "CREATE DATABASE FirstDB"
      assert.equal db.name, dbName
      assert.deepEqual db.tables, {}
  describe 'CREATE TABLE', ->
    it 'create a table with that name', ->
      db = {tables: []}
      sql.dbExec db, "CREATE TABLE users (name varchar(100))"
      assert db.tables.users

    it 'should record the definition of the table', ->
      db = {tables: []}
      sql.dbExec db, "CREATE TABLE users (name varchar(100))"
      assert.deepEqual db.tables.users.definition, [
        {name: 'name', type: 'character varying', params: {maxLength: 100}}
      ]
