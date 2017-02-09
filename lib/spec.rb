load 'spec_helper.rb'

describe "Board: " do

  it "kings and queens are in place with default location" do
  board = Board.new()
  pieces = [King.new(board, :white),
           King.new(board, :black),
           Queen.new(board, :white),
           Queen.new(board, :black)]

    expect(board.get_piece([4, 0]).is_a?(King)).to be true
    expect(board.get_piece([4, 7]).is_a?(King)).to be true
    expect(board.get_piece([3, 0]).is_a?(Queen)).to be true
    expect(board.get_piece([3, 7]).is_a?(Queen)).to be true
  end

  it "initializes a board with no pieces" do
    nil_board = Board.new
    expect(nil_board.get_piece([0, 0]).is_a?(NilClass)).to be true
    expect(nil_board.get_piece([0, 5]).is_a?(NilClass)).to be true
    expect(nil_board.get_piece([2, 0]).is_a?(NilClass)).to be true
    expect(nil_board.get_piece([3, 3]).is_a?(NilClass)).to be true
    expect(nil_board.get_piece([7, 2]).is_a?(NilClass)).to be true
  end

  it "can add pieces to the board" do
    board = Board.new
    expect(board.get_piece([0, 0]).is_a?(NilClass)).to be true
    pawn = Pawn.new(board , :white , [0, 0])
    expect(board.get_piece([0, 0]).is_a?(Pawn)).to be true
  end

  it "can moves the pieces on the board correctly" do
    board = Board.new
    expect(board.get_piece([0, 0]).is_a?(NilClass)).to be true
    expect(board.get_piece([2, 0]).is_a?(NilClass)).to be true

    pawn = Pawn.new(board, :white , [0, 0])
    knight = Knight.new(board, :black, [2, 0])
    board.move_piece([0, 0], [1, 0])
    board.move_piece([2, 0], [3, 2])
    expect(board.get_piece([1, 0]).is_a?(Pawn)).to be true
    expect(board.get_piece([3, 2]).is_a?(Knight)).to be true
  end

  it "can detect a square under attack by opposite color" do
    board = Board.new
    bishop = Bishop.new(board, :white, [0, 0])
    rook = Rook.new(board, :black, [1, 0])

    expect(board.place_under_attack_by_color?([7, 7], :white)).to be true
    expect(board.place_under_attack_by_color?([7, 6], :white)).to be false
    expect(board.place_under_attack_by_color?([1, 5], :black)).to be true
    expect(board.place_under_attack_by_color?([7, 0], :black)).to be true
    expect(board.place_under_attack_by_color?([7, 1], :black)).to be false
  end

  it "can remove piece from the board" do
    board = Board.new
    pawn = Pawn.new(board, :white, [0,0])
    expect(board.get_piece([0, 0]).is_a?(Pawn)).to be true
    board.remove_piece([0, 0])
    expect(board.get_piece([0, 0]).is_a?(NilClass)).to be true
  end
end


describe "Pieces:" do

  describe "Pawn" do

    board = Board.new
    w_pawn = Pawn.new(board, :white, [1, 1])
    b_pawn = Pawn.new(board, :black, [6, 6])

    it "detects valid moves" do
      expect(w_pawn.valid_move?([1, 2])).to be true
      expect(w_pawn.valid_move?([1, 3])).to be true

      expect(b_pawn.valid_move?([6, 5])).to be true
      expect(b_pawn.valid_move?([6, 4])).to be true
    end

    it "can do en-passant move" do
      pawn1 = Pawn.new(board, :black, [2, 3])
      pawn2 = Pawn.new(board, :white, [1, 3])
      expect(pawn1.valid_move?([1, 2])).to be true
    end

  end

  describe "Rook" do
    board = Board.new
    w_rook = Rook.new(board, :white, [1, 1])
    b_rook = Rook.new(board, :black, [6, 6])

    it "detects valid moves" do
      # white rook moves
      expect(w_rook.valid_move?([0, 1])).to be true
      expect(w_rook.valid_move?([1, 3])).to be true
      expect(w_rook.valid_move?([1, 7])).to be true
      expect(w_rook.valid_move?([1, 0])).to be true
      expect(w_rook.valid_move?([5, 1])).to be true
      expect(w_rook.valid_move?([2, 2])).to be false

      # black rook moves
      expect(b_rook.valid_move?([6, 1])).to be true
      expect(b_rook.valid_move?([6, 3])).to be true
      expect(b_rook.valid_move?([1, 6])).to be true
      expect(b_rook.valid_move?([6, 0])).to be true
      expect(b_rook.valid_move?([0, 6])).to be true
      expect(b_rook.valid_move?([5, 5])).to be false
    end
  end

  describe "Knight" do
    board = Board.new
    w_knight = Knight.new(board, :white, [2, 2])
    b_knight = Knight.new(board, :black, [5, 5])


    it "detects valid moves" do
      # white knight moves
      expect(w_knight.valid_move?([0, 1])).to be true
      expect(w_knight.valid_move?([0, 3])).to be true
      expect(w_knight.valid_move?([1, 4])).to be true
      expect(w_knight.valid_move?([3, 4])).to be true
      expect(w_knight.valid_move?([3, 5])).to be false

      # black knight moves
      expect(b_knight.valid_move?([7, 6])).to be true
      expect(b_knight.valid_move?([7, 4])).to be true
      expect(b_knight.valid_move?([4, 7])).to be true
      expect(b_knight.valid_move?([6, 7])).to be true
      expect(b_knight.valid_move?([3, 5])).to be false
    end
  end

  describe "Bishop" do
    board = Board.new
    w_bishop = Bishop.new(board, :white, [1, 1])
    b_bishop = Bishop.new(board, :black, [4, 5])

    it "detects valid moves" do
      # white bishop moves
      expect(w_bishop.valid_move?([3, 3])).to be true
      expect(w_bishop.valid_move?([0, 0])).to be true
      expect(w_bishop.valid_move?([0, 1])).to be false
      expect(w_bishop.valid_move?([2, 0])).to be true

      #black bishop moves
      expect(b_bishop.valid_move?([5, 6])).to be true
      expect(b_bishop.valid_move?([3, 4])).to be true
      expect(b_bishop.valid_move?([4, 1])).to be false
      expect(b_bishop.valid_move?([0, 1])).to be true
    end
  end

  describe "King" do
    board = Board.new
    king = King.new(board, :white)

    it "detects valid moves" do
      expect(king.valid_move?([4,1])).to be true
      expect(king.valid_move?([3,1])).to be true
      expect(king.valid_move?([4,2])).to be false
    end

    it "can do castle on the queen side" do
      rook = Rook.new(board, :white, [0, 0])
      expect(king.valid_move?([2,0])).to be true
    end

    it "can do castle on the king side" do
      rook = Rook.new(board, :white , [7, 0])
      expect(king.valid_move?([6, 0])).to be true
    end
  end

  describe "Queen" do
    board = Board.new

    # white queen with default location
    w_queen = Queen.new(board, :white)
    b_queen = Queen.new(board, :black, [4, 5])

    it "detects valid moves" do
      # white queen moves
      expect(w_queen.valid_move?([3, 3])).to be true
      expect(w_queen.valid_move?([0, 0])).to be true
      expect(w_queen.valid_move?([5, 3])).to be false
      expect(w_queen.valid_move?([5, 2])).to be true

      #black queen moves
      expect(b_queen.valid_move?([5, 6])).to be true
      expect(b_queen.valid_move?([3, 4])).to be true
      expect(b_queen.valid_move?([7, 3])).to be false
      expect(b_queen.valid_move?([0, 1])).to be true
    end
  end

end

describe "Check detection for short game" do

  game = ChessGame.new
  it "can detect it" do

    game.execute_move([[3, 1], [3, 2]])
    game.execute_move([[6, 7], [5, 5]])
    game.execute_move([[4, 0], [3, 1]])
    expect(game.check?([[5, 5], [4, 3]], game.test_players[0])).to be true
  end
end

describe "Check detection for longer games" do

  game = ChessGame.new
  it "can detect it" do

    game.execute_move([[3, 1], [3, 3]])
    game.execute_move([[5, 6], [5, 5]])
    game.execute_move([[4, 1], [4, 2]])
    game.execute_move([[4, 7], [7, 4]])
    game.execute_move([[4, 0], [3, 1]])
    game.execute_move([[7, 4], [1, 4]])
    game.execute_move([[3, 1], [2, 2]])
    expect(game.check?([[1,4], [1, 2]], game.test_players[0])).to be true
  end
end


describe "Check-mate detection when white whins" do

  game = ChessGame.new
  it "can do it propperly" do
    game.execute_move([[4, 1], [4, 2]])
    game.execute_move([[5, 6], [5, 4]])
    game.execute_move([[3, 0], [5, 2]])
    game.execute_move([[6, 7], [5, 5]])
    game.execute_move([[5, 2], [5, 4]])
    game.execute_move([[5, 5], [6, 7]])
    game.execute_move([[5, 0], [2, 3]])
    game.execute_move([[7, 6], [7, 5]])
    expect(game.check_mate?([[5, 4], [5, 6]],game.test_players[1])).to be true
  end
end

describe "Check-mate detection when black wins" do

  game = ChessGame.new
  it "can do it propperly" do
    game.execute_move([[0, 1], [0, 2]])
    game.execute_move([[4, 6], [4, 4]])
    game.execute_move([[4, 1], [4, 3]])
    game.execute_move([[5, 7], [2, 4]])
    game.execute_move([[1, 0], [2, 2]])
    game.execute_move([[3, 7], [5, 5]])
    game.execute_move([[3, 1], [3, 2]])
    expect(game.check_mate?([[5, 5], [5, 1]], game.test_players[0])).to be true
  end
end
