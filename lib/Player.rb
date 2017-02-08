class Player
  attr_reader :color

  def initialize(color, game)
    @color = color
    @piece_set = []
    @game = game
    set_opposing_color
  end

  def set_opposing_color
    @opposing_color = :white if @color == :black
    @opposing_color = :black if @color == :white
  end
end

class HumanPlayer < Player
  def get_move
    move_string = get_move_string
    loop do
      if valid_move?(move_string)
        parse_move(move_string)
      elsif move_string.downcase == 'save'
        @game.save_menu
        move_string = get_move_string
      else
        puts 'INVALID MOVE'
        move_string = get_move_string
      end
    end
  end

  def get_promote_choice
    until 'brnq'.include? choice.downcase do
      puts "You can promote your pawn! Choose:\nK[n]ight\n[Q]ueen\n[B]ishop\n[R]ook\n"
      print '>>'
      choice = gets.chomp.downcase
    end
  end

  def get_move_string
    puts 'Enter your move:'
    print '>> '
    gets.chomp
  end

  def valid_move?(move_string)
    move = validate_move_structure(move_string)
    if move
      move = to_move_array(move)
      return @game.board.move_possible?(move, color)
    end
    false
  end

  def validate_move_structure(move_string)
    begin
       clean_move_string(move_string).match(/^[a-h][1-8][a-h][1-8]$/)[0]
    rescue NoMethodError
       false
    end
  end

  def clean_move_string(move_string)
    move_string.downcase!
    move_string.strip!
    move_string.gsub!(/\s+/, '')
    move_string
  end

  def parse_move(move_string)
    to_move_array(validate_move_structure(move_string))
  end

  def to_move_array(move_string)
    start_x = move_string[0].ord - 97
    start_y = move_string[1].to_i - 1
    end_x = move_string[2].ord - 97
    end_y = move_string[3].to_i - 1
    [[start_x,start_y], [end_x,end_y]]
  end

end

class ComputerPlayer < Player

  def get_move
    piece_set = []
    @game.pieces.each do |piece|
      if piece.status == :alive && piece.color == @color
        piece_set << piece
      end
    end

    move_set = []

    piece_set.each do |piece|
      piece.get_move_set.each do |move_end|
        move_set << [piece.loc, move_end]
        if @game.board.place_occupied_by_color?(move_end, @opposing_color)
          4.times {
            move_set << [piece.loc, move_end]
          }
        end
      end
    end

    move_set[rand(move_set.size)]

  end

  def get_promote_choice
    'bnrqqqqq'[rand(8)]
  end

end
