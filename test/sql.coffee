assert = require 'assert'
sql = require '../src/sql'

describe 'sql', ->
  db = null
  beforeEach ->
    db = {tables: {}}
  describe 'CREATE DATABASE', ->
    it 'should take a database name and return a database object', ->
      dbName = "FirstDB"
      db = sql.exec "CREATE DATABASE FirstDB"
      assert.equal db.name, dbName
      assert.deepEqual db.tables, {}
  describe 'CREATE TABLE', ->
    it 'create a table with that name', ->
      sql.dbExec db, "CREATE TABLE users (name varchar(100))"
      assert db.tables.users

    describe 'table definition', ->
      it 'should record the definition of the table', ->
        sql.dbExec db, "CREATE TABLE users (name varchar(100))"
        assert.deepEqual db.tables.users.definition, [
          {name: 'name', type: 'character varying', params: {maxLength: 100}}
        ]

      it 'should record multiple column definitions', ->
        sql.dbExec db, """
          CREATE TABLE users
          (name varchar(100), nickname varchar(50))
        """
        assert.deepEqual db.tables.users.definition, [
          {name: 'name', type: 'character varying', params: {maxLength: 100}}
          {name: 'nickname', type: 'character varying', params: {maxLength: 50}}
        ]

      it 'can record int type columns', ->
        sql.dbExec db, """
          CREATE TABLE users
          (age int)
        """
        assert.deepEqual db.tables.users.definition, [
          {name: 'age', type: 'int'}
        ]

  describe 'INSERT INTO', ->
    beforeEach ->
      sql.dbExec db, """
        CREATE TABLE users
        (name varchar(100), age int)
      """
    it 'should insert values into the table based on the column names', ->
      sql.dbExec db, """
        INSERT INTO users
        (name, age)
        values
        ('Baby', 1)
      """
      assert.deepEqual db.tables.users.data[0], ["Baby", 1]
