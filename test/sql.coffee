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

    describe 'table definition', ->
      it 'should record the definition of the table', ->
        db = {tables: []}
        sql.dbExec db, "CREATE TABLE users (name varchar(100))"
        assert.deepEqual db.tables.users.definition, [
          {name: 'name', type: 'character varying', params: {maxLength: 100}}
        ]

      it 'should record multiple column definitions', ->
        db = {tables: []}
        sql.dbExec db, """
          CREATE TABLE users
          (name varchar(100), nickname varchar(50))
        """
        assert.deepEqual db.tables.users.definition, [
          {name: 'name', type: 'character varying', params: {maxLength: 100}}
          {name: 'nickname', type: 'character varying', params: {maxLength: 50}}
        ]

      it 'can record int type columns', ->
        db = {tables: []}
        sql.dbExec db, """
          CREATE TABLE users
          (age int)
        """
        assert.deepEqual db.tables.users.definition, [
          {name: 'age', type: 'int'}
        ]

