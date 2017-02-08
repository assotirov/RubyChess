class Board

  attr_reader :board_grid
  attr_accessor :move_num

  def initialize
    @board_grid = []
    8.times { @board_grid << [nil, nil, nil, nil, nil, nil, nil, nil] }
    @pieces = []
    @move_num = 0
  end

  def draw
    print "\n"
    puts '    a b c d e f g h'
    print "    _ _ _ _ _ _ _ _\n"
    8.downto(1) do |y|
      print "#{y}  |"
      8.times do |x|
        if @board_grid[x][y - 1].nil?
          print '_'
        else
          print get_piece([x, y - 1]).to_s
        end
        print '|'
      end
      print "  #{y}"
      print "\n"
    end
    print "\n"
    puts '    a b c d e f g h'
    print "\n"
  end

  def clear_square(loc)
    @board_grid[loc[0]][loc[1]] = nil
  end

  def clear_board
    8.times do |col|
      8.times do |row|
        clear_square([col, row])
      end
    end
    @pieces = []
  end

  def remove_piece(loc)
    @pieces.delete(get_piece(loc))
    clear_square(loc)
  end

  def set_square(loc, piece)
    @board_grid[loc[0]][loc[1]] = piece
  end

  def add_piece(piece)
    @board_grid[piece.x][piece.y] = piece
    @pieces << piece
    update_move_sets
  end

  def move_piece(loc_initial, loc_final)
    piece = get_piece(loc_initial)
    remove_piece(loc_initial)
    piece.set_loc(loc_final)
    add_piece(piece)
    update_move_sets
  end

  def update_move_sets
    @pieces.each do |piece|
      piece.update_move_set
    end
  end

  def get_piece(loc)
    if loc[0].between?(0, 7) && loc[1].between?(0, 7)
      @board_grid[loc[0]][loc[1]]
    else
      nil
    end
  end

  def has_piece?(loc)
    if @board_grid[loc[0]][loc[1]]
      true
    else
      false
    end
  end

  def move_possible?(move, color)
    if get_piece(move[0])
      if get_piece(move[0]).color == color
        get_piece(move[0]).valid_move?(move[1])
      else
        false
      end
    else
      false
    end
  end
  
  def self.on_board?(loc)
    if loc[0].between?(0, 7) && loc[1].between?(0, 7)
      true
    end
  end

  def place_occupied_by_color?(place, color)
    if get_piece(place).nil?
      false
    elsif get_piece(place).color == color
      true
    else
      false
    end
  end

  def place_under_attack_by_color?(place, color)
    @pieces.each do |piece|
      if (piece.get_move_set.include?(place) && piece.color == color)
        return true
      end
    end
    false
  end
end
