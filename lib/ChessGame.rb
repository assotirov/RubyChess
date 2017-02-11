require 'yaml'
load 'Board.rb'
load 'Pieces.rb'
load 'Player.rb'

class ChessGame

  attr_reader :board, :pieces , :test_players

  def initialize
    @test_players = [HumanPlayer.new(:white, self),
                         HumanPlayer.new(:black, self)]
    @board = Board.new
    establish_players
    @current_player = @players[0]
    @next_player = @players[1]
    initialize_piece_set_for_new_game
  end

  def establish_players
    @players = []
    1.upto(2) do |n|
      type = choose_player_type(n)
      if n == 1
        color = :white
      elsif n == 2
        color = :black
      end
      @players[n-1] = HumanPlayer.new(color, self) if type == :h
      @players[n-1] = ComputerPlayer.new(color, self) if type == :c
    end
  end

  def choose_player_type(player_num)
    puts "Should player #{player_num} be [h]uman or [c]omputer?"
    print ">> "
    choice = gets.chomp.downcase
    until "ch".include? choice
      puts "Your choices are [H]uman or [C]omputer"
      print ">> "
      choice = gets.chomp.downcase
    end
    choice.to_sym
  end

  def initialize_piece_set_for_new_game
    @pieces = [  King.new(@board, :white),
           King.new(@board, :black),
           Queen.new(@board, :white),
           Queen.new(@board, :black),
           Pawn.new(@board, :black, [0, 6]),
           Pawn.new(@board, :black, [1, 6]),
           Pawn.new(@board, :black, [2, 6]),
           Pawn.new(@board, :black, [3, 6]),
           Pawn.new(@board, :black, [4, 6]),
           Pawn.new(@board, :black, [5, 6]),
           Pawn.new(@board, :black, [6, 6]),
           Pawn.new(@board, :black, [7, 6]),
           Pawn.new(@board, :white, [0, 1]),
           Pawn.new(@board, :white, [1, 1]),
           Pawn.new(@board, :white, [2, 1]),
           Pawn.new(@board, :white, [3, 1]),
           Pawn.new(@board, :white, [4, 1]),
           Pawn.new(@board, :white, [5, 1]),
           Pawn.new(@board, :white, [6, 1]),
           Pawn.new(@board, :white, [7, 1]),
           Rook.new(@board, :black, [0, 7]),
           Rook.new(@board, :black, [7, 7]),
           Rook.new(@board, :white, [0, 0]),
           Rook.new(@board, :white, [7, 0]),
           Bishop.new(@board, :black, [2, 7]),
           Bishop.new(@board, :black, [5, 7]),
           Bishop.new(@board, :white, [2, 0]),
           Bishop.new(@board, :white, [5, 0]),
           Knight.new(@board, :black, [1, 7]),
           Knight.new(@board, :black, [6, 7]),
           Knight.new(@board, :white, [1, 0]),
           Knight.new(@board, :white, [6, 0])
        ]
  end


  def game_loop
    loop do
      if kings_only?
        @end_message = "The only pieces remaining are the kings.This is a tie!"
        break
      end
      update_player_move_sets
      @board.draw
      puts "It's #{@current_player.color}'s turn."
      move = move_loop
      if check_mate?(move, @next_player)
        @end_message = "That's checkmate! #{@current_player.color.to_s.capitalize} wins!"
        execute_move(move)
        break
      end
      if check?(move, @next_player)
        puts "#{@next_player.color.to_s.capitalize} is in check!"
        put_player_in_check(@next_player)
      else
        take_player_out_of_check(@next_player)
      end
      execute_move(move)
      @current_player, @next_player = @next_player, @current_player
    end
    @board.draw
    puts @end_message
  end

  def move_loop
    move = nil
    loop do
      move = @current_player.get_move
      if check?(move, @current_player)
        puts "That would put you in check!"
      else
        if promotion_possible?(move)
          promote(move[0], @current_player.color)
        end

        if @board.get_piece(move[0]).is_a? King
          case move
          when [[4, 0], [6, 0]]
            execute_move([[7, 0], [5, 0]])
          when [[4, 0], [2, 0]]
            execute_move([[0, 0], [3, 0]])
          when [[4, 7], [6, 7]]
            execute_move([[7, 7], [5, 7]])
          when [[4, 7], [2, 7]]
            execute_move([[0, 7], [3, 7]])
          end
        end

        if enpassant_move?(move)
          kill_coords = [move[1][0], move[0][1]]
          puts "The #{@board.get_piece(kill_coords).color} pawn is killed via en passant"
          kill_piece(kill_coords)
        end
        break
      end
    end
    move
  end

  def save_menu
    input = " "
    loop do
      puts "Welcome to the save menu. Would you like to [S]ave, [L]oad, or [D]elete a game? [B] to go back..."
      print ">> "
      input = gets.chomp.downcase
      break if "sldb".include? input
    end
    if input == "s"
      puts "Enter a name for this saved game"
      print ">> "
      name = gets.chomp.downcase
      save_game(name)
    elsif input == "l"
      manipulate_game(:load)
    elsif input == "d"
      manipulate_game(:delete)
    end
  end

  def save_game(file_name)
    puts "*" * 80
    Dir.mkdir("saved_games") unless Dir.exists?("saved_games")
    game_yaml = YAML::dump(self)
    file_name = "saved_games/" + file_name + ".yaml"
    File.open(file_name, "w") { |f| f.puts game_yaml }
    puts "Your game has been saved in: #{file_name}"
    puts "*" * 80
  end

  def manipulate_game(action)
    choices = Dir.glob("saved_games/*.yaml")
    if choices.size == 0
      puts "There are no games to #{action.to_s}"
      return
    else
      puts "*" * 80
      puts "Type the name of the file without 'saved_games/' and '.yaml'."
      puts "For instance: to #{action.to_s} saved_games/mygame.yaml type 'mygame'"
      choices.each do |file|
        puts file
      end
      print ">> "
      choice = "saved_games/" + gets.chomp.downcase + ".yaml"
      until choices.include?(choice)
        puts "That's not a valid filename. Try again"
        choice = "saved_games/" + gets.chomp.downcase + ".yaml"
      end
      if action == :load
        load_game(choice)
      elsif action == :delete
        delete_game(choice)
      end
    end
  end

  def load_game(file_name)
    contents = File.read(file_name)
    game = YAML::load(contents)
    puts "\n\nloading.....\n\n"
    game.game_loop
  end

  def delete_game(file_name)
    File.delete(file_name)
    puts "The game #{file_name} has been deleted!"
    puts "*" * 80
  end

  def kings_only?
    @pieces.each do |piece|
      if piece.status == :alive && !piece.is_a?(King)
        return false
      end
    end
    return true
  end

  def put_player_in_check(player)
    @pieces.each do |piece|
      if piece.is_a?(King) && piece.color == player.color
        piece.in_check = true
      end
    end
  end

  def take_player_out_of_check(player)
    @pieces.each do |piece|
      if piece.is_a?(King) && piece.color == player.color
        piece.in_check = false
      end
    end
  end

  def execute_move(move)
    @board.get_piece(move[0]).has_moved = true
    if @board.has_piece?(move[1])
      kill_piece(move[1])
    end
    @board.move_piece(move[0], move[1])
  end

  def kill_piece(loc)
    piece = @board.get_piece(loc)
    puts "The #{piece.color.to_s} #{piece.name} dies"
    piece.status = :dead
    @board.remove_piece(loc)
  end

  def enpassant_move?(move)
    piece = @board.get_piece(move[0])
    if piece.is_a? Pawn
      delta_x = (move[1][0]-piece.x).abs
      delta_y = (move[1][1]-piece.y).abs
      if (delta_x + delta_y == 2) && (delta_y == delta_x)
        unless @board.has_piece?(move[1])
          return true
        end
      end
    end
  end

  def promotion_possible?(move)
    piece = @board.get_piece(move[0])
    if piece.is_a?(Pawn)
      if piece.color == :white && move[1][1] == 7
        return true
      elsif piece.color == :black && move[1][1] == 0
        return true
      end
    end
    return false
  end

  def promote(piece_loc, color)
    choice = @current_player.get_promote_choice
    @pieces.delete(@board.get_piece(piece_loc))
    @board.remove_piece(piece_loc)
    case choice
    when "q"
      new_piece = Queen.new(@board, color, piece_loc)
    when "r"
      new_piece = Rook.new(@board, color, piece_loc)
    when "n"
      new_piece = Knight.new(@board, color, piece_loc)
    when "b"
      new_piece = Bishop.new(@board, color, piece_loc)
    end
    @pieces << new_piece
  end

  def update_player_move_sets
    @black_move_set = []
    @white_move_set = []
    @pieces.each do |piece|
      if piece.color == :black && piece.status == :alive
        @black_move_set += piece.get_move_set
      elsif piece.color == :white && piece.status == :alive
        @white_move_set += piece.get_move_set
      end
    end
  end

  def get_player_move_set(color)
    if color == :white
      return @white_move_set
    elsif color == :black
      return @black_move_set
    else
      return []
    end
  end

  def get_king_position(color)
    @pieces.each do |piece|
      if piece.kind_of?(King) && piece.color == color
        return piece.loc
      end
    end
  end

  def get_player_pieces(player)
    players_pieces = []
    @pieces.each do |piece|
      players_pieces << piece if piece.color == player.color
    end
    players_pieces
  end

  def check?(move, player)
    if @board.has_piece?(move[1])
      @board.get_piece(move[1]).status = :dead
      target_location_contents = @board.get_piece(move[1])
      @board.remove_piece(move[1])
    end
    @board.move_piece(move[0], move[1])
    opponent = player.color == :black ? :white : :black
    @board.update_move_sets
    update_player_move_sets
    if get_player_move_set(opponent).include? get_king_position(player.color)
      target_location_contents.status = :alive if target_location_contents
      @board.move_piece(move[1], move[0])
      @board.add_piece(target_location_contents) if target_location_contents
      true
    else
      target_location_contents.status = :alive if target_location_contents
      @board.move_piece(move[1], move[0])
      @board.add_piece(target_location_contents) if target_location_contents
      false
    end
  end

  def check_mate?(move, player)
    target_location_contents = @board.get_piece(move[1]) if @board.has_piece?(move[1])
    target_location_contents.status = :dead if target_location_contents
    @board.remove_piece(move[1])
    @board.move_piece(move[0], move[1])
    opponent = player.color == :black ? :white : :black
    @board.update_move_sets
    update_player_move_sets
    moves_to_check = []
    # get all the pieces beloning to that player
    get_player_pieces(player).each do |piece|
      if piece.status == :alive
        piece.get_move_set.each do |checkmove|
          checkmove = [piece.loc, checkmove]
          unless check?(checkmove, player)
            target_location_contents.status = :alive if target_location_contents
            @board.move_piece(move[1], move[0])
            @board.add_piece(target_location_contents) if target_location_contents
            return false
          end
        end
      end
    end
    moves_to_check.each
    target_location_contents.status = :alive if target_location_contents
    @board.move_piece(move[1], move[0])
    @board.add_piece(target_location_contents) if target_location_contents
    return true
  end
end
