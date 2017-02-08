load 'Piece.rb'

class Queen < Piece
  attr_reader :loc

  def initialize(board, color, loc = nil)
    super(board, color, loc)
    @name = 'Queen'
    @loc = loc
    if color == :black
      @sym = :q
      @loc = [3, 7] if @loc.nil?
    elsif color == :white
      @sym = :Q
      @loc = [3, 0] if @loc.nil?
    end
    board.add_piece(self)
    update_move_set
  end

  def update_move_set
    @move_set = []
    directions = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [1, -1], [-1, 1]]
    directions.each do |dir|
      distance = 1
      loop do
        place = [@loc[0] + distance * dir[0], @loc[1] + distance * dir[1]]
        if Board.on_board?(place)
          if !@board.has_piece?(place)
            @move_set << place
          elsif @board.place_occupied_by_color?(place, @opposing_color)
            @move_set << place
            break
          else
            break
          end
        else
          break
        end
        distance += 1
      end
    end
  end
end
