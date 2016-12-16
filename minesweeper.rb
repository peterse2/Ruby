#
#  Minesweeper game
#
#  Author(s): Caitlin Crowe and Emily Petersen
#

#
# module that defines global constants
#
module Constants
  WON = 0
  LOST = 1
  INPROGRESS = 2
  BOARD_SIZE_MIN = 5
  BOARD_SIZE_MAX = 15
  PCT_MINES_MIN = 10
  PCT_MINES_MAX = 70
end

#
# Cell class represents a cell on the minesweeper board
#
class Cell

  attr_accessor :is_mine, :nbr_mines, :visible

  def initialize(nbr_mines,is_mine,visible)
    self.nbr_mines=(nbr_mines)
    self.is_mine=(is_mine)
    self.visible=(visible)
  end

  def to_s
    "#@is_mine #@nbr_mines #@visible"
  end
end

#
# Minesweeper class represents the game board and contains game logic
#
class Minesweeper

  # initializes a Minesweeper object
  def initialize(board_size,percent_mines)
    @board_size = board_size
    @nbr_mines = (board_size * board_size * (percent_mines/100.0)).to_i

    # setup a 2-dimensional array of Cell objects
    @board = Array.new(board_size)
    @board.fill { |i| Array.new(board_size) }
    for i in 0...board_size
      for j in 0...board_size
        @board[i][j] = Cell.new(0,false,false)
      end
    end

    place_mines_on_board()
    fill_in_minecount_for_non_mine_cells()
  end

  # places mines randomly on the board
  def place_mines_on_board
    i = 0
    while i < @nbr_mines
      r = rand(100) % @board_size
      c = rand(100) % @board_size

      if @board[r][c].is_mine == false
        @board[r][c].is_mine = true
        i = i +1
      elsif @board[r][c].is_mine == true
        #do nothing
      end
    end
  end

  # for each non-mine cell on the board, set @nbr_mines of each Cell on the board
  # to the number of mines in the immediate neighborhood.
  def fill_in_minecount_for_non_mine_cells
    for r in 0...@board_size
      for c in 0...@board_size
        count = 0
        count = get_nbr_neighbor_mines(r,c)
        @board[r][c].nbr_mines = count
      end
    end

  end

  # processes cell selection by user during the game
  # returns Constants::WON, Constants::LOST, or Constants::INPROGRESS
  def select_cell(row,col)
    i = (@board_size * @board_size) - @nbr_mines

    if @board[row][col].is_mine == true
      @board[row][col].nbr_mines = 100
      @board[row][col].visible = true
      return Constants::LOST
    elsif @board[row][col].is_mine == false
      if nbr_visible_cells == i
        @board[row][col].visible = true
        return Constants::WON
      else
        set_all_neighbor_cells_visible(row, col)
        return Constants::INPROGRESS
      end
    end
  end

  # returns the number of mines in the immediate neighborhood of a cell
  # at location (row,col) on the board.
  def get_nbr_neighbor_mines(row,col)
    count = 0
    r = row
    c = col

    if @board[r][c].is_mine == false #if there is no mine in the current cell
      if (r==0) && (c==0) #top left corner
        #check bottom, right, and bottom-right corner cell
        if @board[1][0].is_mine == true #bottom
          count = count + 1
        end
        if @board[0][1].is_mine == true #right
          count = count + 1
        end
        if @board[1][1].is_mine == true #bottom-right corner
          count = count + 1
        end
      elsif (r==0) && (c ==(@board_size-1)) #top right corner
        #check bottom, left, bottom-left corner cell
        if @board[1][(@board_size-1)].is_mine == true #bottom
          count = count + 1
        end
        if @board[0][(@board_size-2)].is_mine == true #left
          count = count + 1
        end
        if @board[1][(@board_size-2)].is_mine == true #bottom-left corner
          count = count + 1
        end
      elsif (r==(@board_size-1)) && (c==0) #bottom left corner
        #check above, right, top-right corner
        if @board[(@board_size-2)][0].is_mine == true #above
          count = count + 1
        end
        if @board[(@board_size-1)][1].is_mine == true #right
          count = count + 1
        end
        if @board[(@board_size-2)][1].is_mine == true #above-right corner
          count = count + 1
        end
      elsif(r==(@board_size-1)) && (c==(@board_size-1)) #bottom right corner
        #check above, left, top-left corner
        if @board[(@board_size-2)][(@board_size-1)].is_mine == true #above
          count = count + 1
        end
        if @board[(@board_size-1)][(@board_size-2)].is_mine == true #right
          count = count + 1
        end
        if @board[(@board_size-2)][(@board_size-2)].is_mine == true #above-right corner
          count = count + 1
        end
      elsif (r>0) && (r<(@board_size-1)) && (c==0) #left wall
        #check above, right, below, top-right, bottom-right
        if @board[r-1][0].is_mine == true #above
          count = count + 1
        end
        if @board[r][1].is_mine == true #right
          count = count + 1
        end
        if @board[r+1][0].is_mine == true #below
          count = count + 1
        end
        if @board[r-1][1].is_mine == true #top-right
          count = count + 1
        end
        if @board[r+1][1].is_mine == true #bottom-right
          count = count + 1
        end
      elsif(r>0) && r<(@board_size-1) && c==(@board_size-1) #right wall
        #check above, left, below, top-left, bottom-left
        if @board[r-1][(@board_size-1)].is_mine == true #above
          count = count + 1
        end
        if @board[r][(@board_size-2)].is_mine == true #left
          count = count + 1
        end
        if @board[r+1][(@board_size-1)].is_mine == true #below
          count = count + 1
        end
        if @board[r-1][(@board_size-2)].is_mine == true #top-left
          count = count + 1
        end
        if @board[r+1][(@board_size-2)].is_mine == true #bottom-left
          count = count + 1
        end
      elsif(r==0) && (c>0) && c<(@board_size-1) #top wall
        #check left, right, below, bottom-left, bottom-right
        if @board[0][c-1].is_mine == true #left
          count = count + 1
        end
        if @board[0][c+1].is_mine == true #right
          count = count + 1
        end
        if @board[1][c].is_mine == true #below
          count = count + 1
        end
        if @board[1][c-1].is_mine == true #bottom-left
          count = count + 1
        end
        if @board[1][c+1].is_mine == true #bottom-right
          count = count + 1
        end
      elsif r==(@board_size-1) && (c>0) && c<(@board_size-1) #bottom wall
        #check above, left, right, top-left, top-right
        if @board[(@board_size-2)][c].is_mine == true #above
          count = count + 1
        end
        if @board[(@board_size-1)][c-1].is_mine == true #left
          count = count + 1
        end
        if @board[(@board_size-1)][c+1].is_mine == true #right
          count = count + 1
        end
        if @board[(@board_size-2)][c-1].is_mine == true #top-left
          count = count + 1
        end
        if @board[(@board_size-2)][c+1].is_mine == true #top-right
          count = count + 1
        end
      else #in the middle
        #check all around: above, left, right, bottom, top-left, top-right, bottom-left, bottom-right
        if @board[r-1][c].is_mine == true #above
          count = count + 1
        end
        if @board[r][c-1].is_mine == true #left
          count = count + 1
        end
        if @board[r][c+1].is_mine == true #right
          count = count + 1
        end
        if @board[r+1][c].is_mine == true #below
          count = count + 1
        end
        if @board[r-1][c-1].is_mine == true #top-left
          count = count + 1
        end
        if @board[r-1][c+1].is_mine == true #top-right
          count = count + 1
        end
        if @board[r+1][c-1].is_mine == true #bottom-left
          count = count + 1
        end
        if @board[r+1][c+1].is_mine == true #bottom-right
          count = count + 1
        end
      end
    end
    return count
  end

  # returns the number of cells that are currently visible on the board
  def nbr_visible_cells
    count = 1
    for r in 0...@board_size
      for c in 0...@board_size
        if @board[r][c].visible == true
          count = count + 1
        end
      end
    end
    return count
  end

  # if the mine count of a cell at location (row,col) is zero, then make
  # the cells ONLY in the immediate neighborhood visible.
  def set_immediate_neighbor_cells_visible(row,col)
    #Not doing this one
  end

  # if the mine count of a cell at location (row,col) is zero, then make
  # the cells in the immediate neighborhood visible and repeat this
  # process for each of the cells in this set of cells that have a mine
  # count of zero, and so on.
  def set_all_neighbor_cells_visible(row,col)
    #dont want to check cells that dont exist
    if (row<0) || (row>=@board_size)
      return
    end
    if (col<0) || (col>=@board_size)
      return
    end

    #if the cell is already visible, don't do anything to it
    if @board[row][col].visible == true
      return
    end

    @board[row][col].visible = true
    if @board[row][col].nbr_mines == 0
      set_all_neighbor_cells_visible((row-1), col) #check above
      set_all_neighbor_cells_visible(row, (col+1)) #check right
      set_all_neighbor_cells_visible(row, (col-1)) #check left
      set_all_neighbor_cells_visible((row+1), col) #check below
    end

  end

  # returns a string representation of the board
  def to_s(display_mines=false)
    str = ""
    for i in 0...@board_size
      str << (i == 0 ? sprintf("%6d",i+1) : sprintf("%3d",i+1))
    end
    str << "\n"

    for i in 0...@board_size
      str << sprintf("%3d",i+1)
      for j in 0...@board_size
        if @board[i][j].visible
          str << (@board[i][j].is_mine ? sprintf("  *") : sprintf("%3d", @board[i][j].nbr_mines))
        else
          str << (display_mines && @board[i][j].is_mine ? sprintf("  *") : sprintf("  ?"))
        end
      end
      str << "\n"
    end

    str
  end


  # make these methods private
  private :place_mines_on_board, :fill_in_minecount_for_non_mine_cells,
          :get_nbr_neighbor_mines, :nbr_visible_cells,
          :set_immediate_neighbor_cells_visible, :set_all_neighbor_cells_visible

end

#
# main method that provides the user interface to the game
#
def main
  print "!!!!!WELCOME TO THE MINESWEEPER GAME!!!!!\n\n"
  display_mines = false
  game_state = Constants::INPROGRESS

  board_size = get_board_size()
  percent_mines = get_percent_mines()
  board = Minesweeper.new(board_size,percent_mines)
  puts board.to_s(display_mines)

  while true do
    print "Enter command (m/M for menu): "
    command = STDIN.gets.strip
    case command
      when 'm' || 'M'
        display_menu()

      when 'c' || 'C'
        row = 0
        col = 0
        while row < 1 || row > board_size || col < 1 || col > board_size do
          print "Enter row and column of cell: "
          tokens = STDIN.gets.strip.split(' ')
          row = tokens[0].to_i
          col = tokens[1].to_i
          if row < 1 || row > board_size || col < 1 || col > board_size
            puts "Invalid row or column values. Try again."
          end
        end
        game_state = board.select_cell(row-1,col-1)
        puts board.to_s(display_mines)

      when 's' || 'S'
        display_mines = true
        puts board.to_s(display_mines)

      when 'h' || 'H'
        display_mines = false
        puts board.to_s(display_mines)

      when 'b' || 'B'
        puts board.to_s(display_mines)

      when 'q' || 'Q'
        puts "Bye."
        return

      else
        puts "Invalid command. Try again."
    end # end case

    if game_state == Constants::WON
      puts "You found all the mines. Congratulations. Bye."
      return
    elsif game_state == Constants::LOST
      puts "Oops. Sorry, you landed on a mine. Bye"
      return
    end
  end   # end while

end

#
# Displays command menu
#
def display_menu
  puts "List of available commands:"
  puts "   Show Mines: s/S"
  puts "   Hide Mines: h/H"
  puts "   Select Cell: c/C"
  puts "   Display Board: b/B"
  puts "   Display Menu: m/M"
  puts "   Quit: q/Q"
end

#
# Prompts the user for board size, reads and validates the input
# entered, and returns the integer if it is within valid range.
# repeats this in a loop until the user enters a valid value.
#
def get_board_size
  size = 0
  while size < Constants::BOARD_SIZE_MIN || size > Constants::BOARD_SIZE_MAX do
    print "Enter board size (#{Constants::BOARD_SIZE_MIN} .. #{Constants::BOARD_SIZE_MAX}): "
    size = STDIN.gets.strip.to_i
    if (size < Constants::BOARD_SIZE_MIN || size > Constants::BOARD_SIZE_MAX)
      puts "Invalid board size. Try again."
    end
  end
  size
end

#
# Prompts the user for percentage of mines to place on the board,
# reads and validates the input entered, and returns the integer if it
# is within valid range. repeats this in a loop until the user enters
# a valid value for board size.
#
def get_percent_mines
  percent_mines = 0
  while percent_mines < Constants::PCT_MINES_MIN || percent_mines > Constants::PCT_MINES_MAX do
    print "Enter percentage of mines on the board (#{Constants::PCT_MINES_MIN} .. #{Constants::PCT_MINES_MAX}): "
    percent_mines = STDIN.gets.strip.to_i
    if (percent_mines < Constants::PCT_MINES_MIN || percent_mines > Constants::PCT_MINES_MAX)
      puts "Invalid value for percentage. Try again."
    end
  end
  percent_mines
end

#
# invoke main
#
main()
