assert = require 'assert'
sql = require '../src/sql'

describe 'sql', ->
  describe 'CREATE DATABASE', ->
    it 'should take a database name and return a database object', ->
      dbName = "FirstDB"
      db = sql.exec "CREATE DATABASE FirstDB"
      assert.equal db.name, dbName

