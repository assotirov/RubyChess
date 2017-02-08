load 'Piece.rb'

class King < Piece

  attr_reader :loc
  attr_accessor :in_check

  def initialize(board, color, loc = nil)
    super(board, color, loc)
    @name = 'King'
    @castled = false
    @loc = loc
    @in_check = false
    if color == :black
      @sym = :k
      @loc = [4, 7] if @loc.nil?
    elsif color == :white
      @sym = :K
      @loc = [4, 0] if @loc.nil?
    end
    board.add_piece(self)
    update_move_set
  end

  def castle_moves
    moves = []
    return moves if @in_check || @has_moved
    moves << castle_kingside if castle_kingside
    moves << castle_queenside if castle_queenside
    moves
  end

  def castle_kingside
    if color == :white
      rook = @board.get_piece([7, 0])
      unless rook.nil?
        unless rook.has_moved
          unless @board.get_piece([5, 0]) || @board.get_piece([6, 0])
            unless @board.place_under_attack_by_color?([5, 0], :black)
              return [6, 0]
            end
          end
        end
      end
    elsif color == :black
      rook = @board.get_piece([7, 7])
      unless rook.nil?
        unless rook.has_moved
          unless @board.get_piece([5, 7]) || @board.get_piece([6, 7])
            unless @board.place_under_attack_by_color?([5, 7], :white)
              return [6, 7]
            end
          end
        end
      end
    end
    nil
  end

  def castle_queenside
    if color == :white
      rook = @board.get_piece([0, 0])
      unless rook.nil?
        unless rook.has_moved
          unless @board.get_piece([2, 0]) || @board.get_piece([3, 0]) || @board.get_piece([1, 0])
            unless @board.place_under_attack_by_color?([3, 0], :black)
              return [2, 0]
            end
          end
        end
      end
    elsif color == :black
      rook = @board.get_piece([0, 7])
      unless rook.nil?
        unless rook.has_moved
          unless @board.get_piece([2, 7]) || @board.get_piece([3, 7]) || @board.get_piece([1, 7])
            unless @board.place_under_attack_by_color?([3, 7], :white)
              return [2, 7]
            end
          end
        end
      end
    end
    nil
  end

  def update_move_set
    @move_set = []
    @move_set += castle_moves
    (-1).upto(1) do |x|
      (-1).upto(1) do |y|
        new_loc = [@loc[0] + x, @loc[1] + y]
        if new_loc == @loc
          next
        elsif Board.on_board?(new_loc)
          unless @board.place_occupied_by_color?(new_loc, @color)
            @move_set << new_loc
          end
        end
      end
    end
  end

end
