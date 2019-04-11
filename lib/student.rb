require 'pry'

class Student
  attr_accessor :id, :name, :grade

  # INSTANCE METHODS
  def save
    sql = <<-SQL
    INSERT INTO students (name, grade)
    VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  # CLASS METHODS
  def self.new_from_db(row)
    student = Student.new
    # row outputs [1, "Pat", 12]
    # setting @id, @name, and @grade
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    #return new Student instance
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    # .map creates a new array
    DB[:conn].execute(sql).map do |row|
      # using .new_from_db creates a new Student instance and assigns the values to the proper place
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.name = ?
      LIMIT 1
    SQL

    # executing the row and passing in the argument before mapping
    DB[:conn].execute(sql,name).map do |row|
      self.new_from_db(row)
    end.first
    # map returns an array and we want to return the first item
  end

  def self.all_students_in_grade_9
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 9
      LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.students_below_12th_grade
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade < 12
      LIMIT 1
    SQL

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_X_students_in_grade_10(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 10
      LIMIT ?
    SQL

    # argument is passed through sql execution
    DB[:conn].execute(sql,x).map do |row|
      self.new_from_db(row)
    end
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = 10
      ORDER BY last_insert_rowid() DESC
      LIMIT 1
    SQL
    # sorting by a descending last_insert_rowid which would return the first row id.

    DB[:conn].execute(sql).map do |row|
      self.new_from_db(row)
    end.first
    # using .first because an array is returned
  end

  def self.all_students_in_grade_X(x)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE students.grade = ?
    SQL

    # argument is passed through sql execution
    DB[:conn].execute(sql,x).map do |row|
      self.new_from_db(row)
    end
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
end
