load "Piece.rb"

class Knight < Piece

  attr_reader :loc

  def initialize(board, color, loc = nil)
    super(board, color, loc)
    @name = "Knight"
    @loc = loc
    if color == :black
      @sym = :n
    elsif color == :white
      @sym = :N
    end
    board.add_piece(self)
    update_move_set
  end

  def update_move_set
    @move_set = []
    moves = [[1, 2], [-1, 2], [-1, -2], [1, -2], [2, 1], [-2, 1], [-2, -1] ,[2, -1]]
    moves.each do |move|
      new_loc = [@loc[0]+move[0],@loc[1]+move[1]]
      if Board.on_board?(new_loc) && !@board.place_occupied_by_color?(new_loc, @color)
        @move_set << new_loc
      end
    end
  end
end
