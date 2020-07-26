require 'sqlite3'
DB = {:conn => SQLite3::Database.new("db/students.db")}
require_relative '../lib/student'
