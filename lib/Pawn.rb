load 'Piece.rb'

class Pawn < Piece
  attr_reader :loc

  def initialize(board, color, loc = nil)
    super(board, color, loc)
    @name = 'Pawn'
    @loc = loc
    if color == :black
      @sym = :p
    elsif color == :white
      @sym = :P
    end
    board.add_piece(self)
    update_move_set
  end

  def en_passant_moves
    moves = []
    if color == :black
      if @loc[1] == 3
        left = @board.get_piece([@loc[0] - 1, @loc[1]])
        right = @board.get_piece([@loc[0] + 1, @loc[1]])
        if left.is_a?(Pawn)
          unless @board.has_piece?([@loc[0] - 1, @loc[1] - 1])
            moves << [@loc[0] - 1, @loc[1] - 1]
          end
        end
        if right.is_a?(Pawn)
          unless @board.has_piece?([@loc[0] + 1, @loc[1] - 1])
            moves << [@loc[0] + 1, @loc[1] - 1]
          end
        end
      else
        nil
      end
    elsif color == :white
      if @loc[1] == 4
        left = @board.get_piece([@loc[0] - 1, @loc[1]])
        right = @board.get_piece([@loc[0] + 1, @loc[1]])
        if left.is_a?(Pawn)
          unless @board.has_piece?([@loc[0] - 1, @loc[1] + 1])
            moves << [@loc[0] - 1, @loc[1] + 1]
          end
        end
        if right.is_a?(Pawn)
          unless @board.has_piece?([@loc[0] + 1, @loc[1] + 1])
            moves << [@loc[0] + 1, @loc[1] + 1]
          end
        end
      else
        nil
      end
    end
    moves
  end

  def update_move_set
    moves = [[@loc[0] + 1, @loc[1] + 1], [@loc[0] - 1, @loc[1] + 1], [@loc[0], @loc[1] + 1], [@loc[0], @loc[1] + 2]] if @color == :white
    moves = [[@loc[0] + 1, @loc[1] - 1], [@loc[0] - 1, @loc[1] - 1], [@loc[0], @loc[1] - 1], [@loc[0], @loc[1] - 2]] if @color == :black
    @move_set = []
    @move_set += en_passant_moves if en_passant_moves
    unless @board.has_piece?(moves[2])
      @move_set << moves[2]
      unless @has_moved || @board.has_piece?(moves[3])
        @move_set << moves[3]
      end
    end

    2.times do |n|
      if @board.place_occupied_by_color?(moves[n], @opposing_color)
        @move_set << moves[n]
      end
    end

  end
end
