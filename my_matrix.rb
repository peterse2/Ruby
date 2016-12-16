#!/usr/bin/env ruby
#
#  Class that represents a Matrix and implements operations on matrices.
#
#  Author(s): Emily Petersen and Caitlin Crowe

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
      if !(rows.instance_of? Fixnum) || !(columns.instance_of? Fixnum)
        raise ArgumentError.new("Value of row or columns is not a Fixnum.")
      end
      if (rows <= 0) || (columns <= 0)
        raise ArgumentError.new("Value of row or column is <= 0.")
      end

      self.rows = rows
      self.columns = columns
      @rows = rows
      @columns = columns
      @data = Array.new(rows) {Array.new(columns,val)}
    end

    # method that returns matrix element at location (i,j)
    # NOTE: row and column values are zero-index based
    # raise ArgumentError exception if any of the following is true:
    #     parameters i or j is not of type Fixnum
    #     value of i or j is outside the bounds of Matrix
    def get(i, j)
      unless (i.instance_of? Fixnum) || (j.instance_of? Fixnum)
        raise ArgumentError.new("Value of row or columns is not a Fixnum.")
      end

      if (i >= @rows) || (i < 0)
        raise ArgumentError.new("Value of row is out of bounds.")
      end
      if (j >= @columns) || (j < 0)
        raise ArgumentError.new("Value of column is out of bounds.")
      end

      @data[i][j]
    end

    # method to set the value of matrix element at location (i,j) to value of parameter val
    # NOTE: row and column values are zero-index based
    # raise ArgumentError exception if any of the following is true:
    #     parameters i or j or val is not of type Fixnum
    #     the value of i or j is outside the bounds of Matrix
    def set(i, j, val)
      unless (i.instance_of? Fixnum) || (j.instance_of? Fixnum)
        raise ArgumentError.new("Value of row or columns is not a Fixnum.")
      end
      unless val.instance_of? Fixnum
        raise ArgumentError.new("Value of val is not a Fixnum.")
      end
      if (i >= @rows) || (i < 0)
        raise ArgumentError.new("Value of row is out of bounds.")
      end
      if (j >= @columns) || (j < 0)
        raise ArgumentError.new("Value of column is out of bounds.")
      end

      @data[i][j] = val
    end

    # method that returns a new matrix object that is the sum of this and parameter matrices.
    # raise ArgumentError exception if the parameter m is not of type Matrix
    # raise IncompatibleMatricesError exception if the matrices are not compatible for addition operation
    def add(m)
      unless m.instance_of? MyMatrix
        raise ArgumentError.new("Param is not an instance of MyMatrix.")
      end
      unless @rows == m.rows
        raise IncompatibleMatricesError.new("The matrices are not compatible.")
      end
      unless @columns == m.columns
        raise IncompatibleMatricesError.new("The matrices are not compatible.")
      end

      tempdata = MyMatrix.new(@rows,@columns,0)

      for r in 0...@rows
        for c in 0...@columns
          i = get(r,c) + m.get(r,c)
          tempdata.set(r,c,i)
        end
      end
      tempdata
    end

    # method that returns a new matrix object that is the difference of this and parameter matrices
    # raise ArgumentError exception if the parameter m is not of type Matrix
    # raise IncompatibleMatricesError exception if the matrices are not compatible for subtraction operation
    def subtract(m)
      unless m.instance_of? MyMatrix
        raise ArgumentError.new("Param is not an instance of MyMatrix.")
      end
      unless @rows == m.rows
        raise IncompatibleMatricesError.new("The matrices are not compatible.")
      end
      unless @columns == m.columns
        raise IncompatibleMatricesError.new("The matrices are not compatible.")
      end

      tempdata = MyMatrix.new(@rows,@columns,0)

      for r in 0...@rows
        for c in 0...@columns
          i = get(r,c) - m.get(r,c)
          tempdata.set(r,c,i)
        end
      end
      tempdata
    end

    # method that returns a new matrix object that is a scalar multiple of source matrix object
    # raise ArgumentError exception if the parameter k is not of type Fixnum
    def scalarmult(k)
      unless k.instance_of? Fixnum
        raise ArgumentError.new("The scalar is not an instance of Fixnum.")
      end

      tempdata = MyMatrix.new(@rows,@columns,0)

      for r in 0...@rows
        for c in 0...@columns
          i = get(r,c) * k
          tempdata.set(r,c,i)
        end
      end
      tempdata
    end

    # method that returns a new matrix object that is the product of this and parameter matrices
    # raise ArgumentError exception if the parameter m is not of type Matrix
    # raise IncompatibleMatricesError exception if the matrices are not compatible for multiplication operation
    def multiply(m)
      unless m.instance_of? MyMatrix
        raise ArgumentError.new("Param is not an instance of MyMatrix.")
      end
      unless @columns == m.rows
        raise IncompatibleMatricesError.new("The matrices are not compatible.")
      end

      tempdata = MyMatrix.new(@rows,m.columns,0)

      for r in 0...@rows
        for c in 0...m.columns
          value = 0
          for i in 0...@columns
            value = value + (get(r,i) * m.get(i,c))
          end
          tempdata.set(r,c,value)
        end
      end
      tempdata
    end

    # method that returns a new matrix object that is the transpose of the source matrix
    def transpose
      tempdata = MyMatrix.new(@columns,@rows,0)
      for r in 0...@columns
        for c in 0...@rows
          tempdata.set(r,c,get(c,r))
        end
      end
      tempdata
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
      unless size.instance_of? (Fixnum)
        raise ArgumentError.new("Param is not an instance of Fixnum.")
      end
      unless size > 0
        raise ArgumentError.new("Param is not a valid value.")
      end
      tempdata = MyMatrix.new(size,size,0)
      for i in 0...size
        tempdata.set(i, i, 1)
      end
      tempdata
    end

    # method that sets every element in the matrix to value of parameter val
    # raise ArgumentError exception if val is not of type Fixnum
    # hint: use fill() method of Array to fill the matrix
    def fill(val)
      unless val.instance_of? Fixnum
        raise ArgumentError.new("Param is not an instance of Fixnum.")
      end
      for r in 0...@rows
        @data[r].fill(val)
      end
    end

    # method that return a deep copy/clone of this matrix object
    def clone
      tempdata = MyMatrix.new(@rows,@columns,0)

      for r in 0...@rows
        for c in 0...@columns
          tempdata.set(r,c, get(r,c))
        end
      end
      #tempdata = Marshal.load(Marshal.dump(@data))

      tempdata
    end

    # method that returns true if this matrix object and the parameter matrix object are equal
    # (i.e., have the same number of rows, columns, and corresponding values in the two
    # matrices are equal). Otherwise, it returns false.
    # returns false if the parameter m is not of type Matrix
    def == (m)
      unless m.instance_of? MyMatrix
        return false
      end
      if (@rows == m.rows) && (@columns == m.columns)
        for r in 0...@rows
          for c in 0...@columns
            unless get(r,c) == m.get(r,c)
              return false
            end
          end
        end
        return true
      end
      false
    end

    # method that returns a string representation of matrix data in table (row x col) format
    def to_s
      str = ""
      for r in 0...@rows
        for c in 0...@columns
          if c == (@columns-1)
            #c = c + 1
            str << sprintf("%d\n", get(r,c))
          else
            str << sprintf("%d ", get(r,c))
          end
        end
      end

      str
    end

  # method that for each element in the matrix yields with information
  # on row, column, and data value at location (i,j)
  def each
    for r in 0...@rows
      for c in 0...@columns
        yield(r, c, get(r,c))
      end
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

  puts(MyMatrix.identity(5))

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




