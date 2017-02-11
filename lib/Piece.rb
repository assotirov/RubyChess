class Piece

  attr_reader :color, :name, :loc
  attr_accessor :status, :has_moved

  def initialize(board, color, loc = nil)
    @board = board
    @color = color
    @opposing_color = :black if @color == :white
    @opposing_color = :white if @color == :black
    @has_moved = false
    @sym = nil
    @status = :alive
    @move_set = []
    @loc = nil
  end

  def to_s
    @sym.to_s
  end

  def get_move_set
    @move_set
  end

  def set_loc(loc)
    @loc = loc
  end

  def x
    @loc[0]
  end

  def y
    @loc[1]
  end

  def move(loc)
    @loc = loc
    update_move_set
  end

  def valid_move?(move)
    get_move_set.include?(move)
  end

end
