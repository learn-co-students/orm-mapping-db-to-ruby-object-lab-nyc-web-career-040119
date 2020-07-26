require 'pry'

class Student

  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
      SELECT * FROM students
      SQL
    # same as find_by_name. Mapping all of the students in the database to get them back as an array so you can pass that array into the new_from_db method
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    # I like the '?' thingy - add the argument variable after the sql variable to replace the ? with it. Cool stuffs
    sql = "SELECT * FROM students WHERE name = ? LIMIT 1"
    # map returns it as an array so you can pass through new_from_db since row is excepting an array
    # .first is used so you can get the id,name,grade from the object
    DB[:conn].execute(sql, name).map { |row| self.new_from_db(row) }.first
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_9
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql,9)
  end

  def self.students_below_12th_grade
    sql = "SELECT * FROM students WHERE grade < ?"
    DB[:conn].execute(sql,12).map { |row| self.new_from_db(row) }
  end

  def self.first_X_students_in_grade_10(num)
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT ?"
    DB[:conn].execute(sql,num)
  end

  def self.first_student_in_grade_10
    sql = "SELECT * FROM students WHERE grade = 10 LIMIT 1"
    DB[:conn].execute(sql).map { |row| self.new_from_db(row) }.first
  end

  def self.all_students_in_grade_X(grade)
    sql = "SELECT * FROM students WHERE grade = ?"
    DB[:conn].execute(sql,grade)
  end
  
end
