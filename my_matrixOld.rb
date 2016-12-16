#!/usr/bin/env ruby
#
#  Class that represents a Matrix and implements operations on matrices.
#
#  Author(s): Your Name(s)
#
class MyMatrix
  # create getter methods for instance variables @rows and @columns
    attr_reader  :rows, :columns

    # create setter methods for instance variables @rows and @columns
    attr_writer  :rows, :columns

    # make setter methods for @rows and @columns private
    private :rows=, :columns=

    # method that initializes a newly allocated Matrix object
    # use instance variable named @data (an array) to hold matrix elements
    # raise ArgumentError exception if any of the following is true:
    #     parameters rows or columns or val is not of type Fixnum
    #     value of rows or columns is <= 0
    def initialize(rows=5, columns=5, val=0)
      @data = Array.new(rows) {Array.new(columns,val)}
      unless (rows.instance_of? Fixnum) || (columns.instance_of? Fixnum)
        raise ArgumentError
      end
      unless rows > 0 || columns > 0
        raise ArgumentError
      end
    end

    # method that returns matrix element at location (i,j)
    # NOTE: row and column values are zero-index based
    # raise ArgumentError exception if any of the following is true:
    #     parameters i or j is not of type Fixnum
    #     value of i or j is outside the bounds of Matrix
    def get(i, j)
      unless (rows.instance_of? Fixnum) || (columns.instance_of? Fixnum)
        raise ArgumentError
      end
      if @data.length < i || @data.length[0] < j
        raise ArgumentError
      end

      return data.at(i-1,j-1) #RubyMines says that this is unnecessary, so maybe we can delete it?
    end

    # method to set the value of matrix element at location (i,j) to value of parameter val
    # NOTE: row and column values are zero-index based
    # raise ArgumentError exception if any of the following is true:
    #     parameters i or j or val is not of type Fixnum
    #     the value of i or j is outside the bounds of Matrix
    def set(i, j, val)
      unless (rows.instance_of? Fixnum) || (columns.instance_of? Fixnum)
        raise ArgumentError
      end
      if @data.length < i || @data.length[0] < j
        raise ArgumentError
      end

      @data[i-1,j-1] = val
    end

    # method that returns a new matrix object that is the sum of this and parameter matrices.
    # raise ArgumentError exception if the parameter m is not of type Matrix
    # raise IncompatibleMatricesError exception if the matrices are not compatible for addition operation
    def add(m)
      tempdata = @data.dup #I removed the @ before tempData, since this is just seems to be a local variable
      unless m.instance_of? MyMatrix
        raise ArgumentError
      end
      unless (@data.length == m.length) || (@data[0].length == m[0].length)
        raise IncompatibleMatricesError
      end
      tempdata.each do |r,c|
        tempdata[r][c] = m[r][c] + @data[r][c]
      end
      return tempdata #this return statement is apparently unnecessary too?
    end

    # method that returns a new matrix object that is the difference of this and parameter matrices
    # raise ArgumentError exception if the parameter m is not of type Matrix
    # raise IncompatibleMatricesError exception if the matrices are not compatible for subtraction operation
    def subtract(m)
      tempdata = @data.dup #I removed the @ before tempData, since this is just seems to be a local variable
      unless m.instance_of? MyMatrix
        raise ArgumentError
      end
      unless (@data.length == m.length) || (@data[0].length == m[0].length)
        raise IncompatibleMatricesError
      end
      tempdata.each do |r,c|
        tempdata[r,c] = @data.at(r,c) - m.at(r,c) #which way data-m or m-data?
      end
      return tempdata #this return statement is apparently unnecessary too?
    end

    # method that returns a new matrix object that is a scalar multiple of source matrix object
    # raise ArgumentError exception if the parameter k is not of type Fixnum
    def scalarmult(k)
      tempdata = @data.dup #I removed the @ before tempData, since this is just seems to be a local variable
      unless k.instance_of? Fixnum
        raise ArgumentError
      end
      tempdata.each do |r,c|
        tempdata[r, c] = @data.at(r,c)*k
      end
      return tempdata #this return statement is apparently unnecessary too?
    end

    # method that returns a new matrix object that is the product of this and parameter matrices
    # raise ArgumentError exception if the parameter m is not of type Matrix
    # raise IncompatibleMatricesError exception if the matrices are not compatible for multiplication operation
    def multiply(m)
      @value = 0 #Does this need the @?
      unless m.instance_of? Matrix
        raise ArgumentError
      end
      unless @data.length[0] == m.length
        raise IncompatibleMatricesError
      end
      tempdata = Array.new(data.length) {Array.new(m.length[0])}
      tempdata.each do |r,c|
       @data.each do |i|
          value = @data.get(r,i)*m.get(i,c)
        end
        tempdata.set(r, c, value)
      end
      return tempdata #this return statement is apparently unnecessary too?
    end

    # method that returns a new matrix object that is the transpose of the source matrix
    def transpose
      #source matrix?
      #is there suppose to be a param?
      tempdata = Array.new(data.length[0]) {Array.new(data.length)}
      unless k.instance_of? Fixnum
        raise ArgumentError
      end
      tempdata.each do |r,c|
        tempdata[r, c] = @data.at(c, r)
      end
      return tempdata #this return statement is apparently unnecessary too?
    end

    # overload + for matrix addition
    def +(m)
      add(m)
    end

    # overload - for matrix subtraction
    def -(m)
      subtract(m)
    end

    # overload * for matrix multiplication
    def *(m)
      multiply(m)
    end


    # class method that returns an identity matrix with size number of rows and columns
    # raise ArgumentError exception if any of the following is true:
    #     parameter size is not of type Fixnum
    #     the value of size <= 0
    def MyMatrix.identity(size)
      #@tempData- i dont think this is needed?
      #@i=0 my IDE wanted me to just delete this after removing the @
      unless size.instance_of? (Fixnum) || size > (0)
        raise ArgumentError
      end
      tempdata = Array.new(size) {Array.new(size)}
      tempdata.fill(0)
      while i<size do #I'm not 100% sure about the syntax of a while loop, but I imagine it needs an end as well so i added one
        tempdata.set(i, i, 1)
      end
      return tempdata
    end

    # method that sets every element in the matrix to value of parameter val
    # raise ArgumentError exception if val is not of type Fixnum
    # hint: use fill() method of Array to fill the matrix
    def fill(val)
      unless val.instance_of? Fixnum
        raise ArgumentError
      end
     @data.column.fill()
    end

    # method that return a deep copy/clone of this matrix object
    def clone
      tempdata = Array.new(data.length) {Array.new(data.length[0])}
      tempdata.each do |r,c|
        tempdata.set(r,c,@data.get(r,c))
      end
      return tempdata #this return statement is apparently unnecessary too?
    end

    # method that returns true if this matrix object and the parameter matrix object are equal
    # (i.e., have the same number of rows, columns, and corresponding values in the two
    # matrices are equal). Otherwise, it returns false.
    # returns false if the parameter m is not of type Matrix
    def ==(m)
      unless m.instance_of? Matrix
        return false
      end
      if@data.length == (m.length) &&@data.length[0] == (m.length[0])
       @data.each do |r,c|
          unless@data.get(r,c)== m.get(r,c)
            return false
          end
          return true
        end
        return false #this return statement is apparently unnecessary too?
      end
    end

    # method that returns a string representation of matrix data in table (row x col) format
    def to_s
      puts(@data.to_a.map(&:inspect)) #not sure if this works---- this does not work
      #data.each do |r,c|
      #if (new row)
      #put new line
      #put@data.get(r,c).to_s

    end

  # method that for each element in the matrix yields with information
  # on row, column, and data value at location (i,j)
  def each
    @data.each do |i,j|
      yield@data.get(i,j)
    end
  end
end

#
# Custom exception class IncompatibleMatricesError
#
class IncompatibleMatricesError < Exception #error here: "Class definition in method body" this appeared after having to change the name to MyMatrix
  def initialize(msg)
    super msg
  end
end

#
#  main test driver
#
def main
  m1 = MyMatrix.new(3,4,10)
  m2 = MyMatrix.new(3,4,20)
  m3 = MyMatrix.new(4,5,30)
  m4 = MyMatrix.new(3,5,40)

  puts(m1)
  puts(m2)
  puts(m3)
  puts(m4)

  puts(m1.add(m2))

  puts(m1.subtract(m2))

  puts(m1.multiply(m3))

  puts(m2.scalarmult(5))

  puts(Matrix.identity(5))

  puts(m1 + m2)

  puts(m2 - m1)

  puts(m1 * m3)

  puts(m1 + m2 - m1)

  puts(m4 + m2 * m3)

  puts(m1.clone())

  puts(m1.transpose())

  puts("Are matrices equal? #{m1 == m2}")

  puts("Are matrices equal? #{m1 == m3}")

  puts("Are matrices equal? #{m1 == m1}")

  m1.each { |i, j, val|
    puts("(#{i},#{j},#{val})")
  }

  begin
    m1.get(4,4)
  rescue ArgumentError => exp
    puts("#{exp.message} - get failed\n")
  end

  begin
    m1.set(4,5,10)
  rescue ArgumentError => exp
    puts("#{exp.message} - set failed\n")
  end

  begin
    m1.add(m3)
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - add failed\n")
  end

  begin
    m2.subtract(m3)
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - subtract failed\n")
  end

  begin
    m1.multiply(m2)
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - multiply failed\n")
  end

  begin
    m1 + m3
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - add failed\n")
  end

  begin
    m2 - m3
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - subtract failed\n")
  end

  begin
    m1 * m2
  rescue IncompatibleMatricesError => exp
    puts("#{exp.message} - multiply failed\n")
  end

end

# uncomment the following line to run the main() method
main()




