require 'yaml'
require 'gosu'
load 'Board.rb'
load 'Pieces.rb'
load 'Player.rb'
load 'ChessGame.rb'

class Menu
  def initialize (window)
    @window = window
    @items = Array.new
  end

  def add_item (image, x, y, z, callback, hover_image = nil)
    item = MenuItem.new(@window, image, x, y, z, callback, hover_image)
    @items << item
    self
  end

  def draw
    @items.each do |i|
        i.draw
    end
  end

  def update
    @items.each do |i|
        i.update
    end
  end

  def clicked
    @items.each do |i|
        i.clicked
    end
  end
end

class MenuItem
  HOVER_OFFSET = 3
  def initialize (window, image, x, y, z, callback, hover_image = nil)
    @window = window
    @main_image = image
    @hover_image = hover_image
    @original_x = @x = x
    @original_y = @y = y
    @z = z
    @callback = callback
    @active_image = @main_image
  end

  def draw
    @active_image.draw(@x, @y, @z)
  end

  def update
    if is_mouse_hovering then
        if !@hover_image.nil? then
            @active_image = @hover_image
        end

        @x = @original_x + HOVER_OFFSET
        @y = @original_y + HOVER_OFFSET
    else
        @active_image = @main_image
        @x = @original_x
        @y = @original_y
    end
  end

  def is_mouse_hovering
    mx = @window.mouse_x
    my = @window.mouse_y

    (mx >= @x and my >= @y) and (mx <= @x + @active_image.width) and (my <= @y + @active_image.height)
  end

  def clicked
    if is_mouse_hovering then
        @callback.call
    end
  end
end

class Game < Gosu::Window

  attr_reader :board, :pieces , :test_players
  attr_accessor :background_image

  def initialize
    super 720, 720
    $window = self
    @board = Board.new
    self.caption = 'Ruby Chess'
    @cursor = Gosu::Image.new(self, "images/Cursor_64px.png")
    @background_image = Gosu::Image.new("images/board0.png")
    @menu = Menu.new(self)

    @menu.add_item(Gosu::Image.new(self, "images/item.png", true), 100, 200, 1, lambda { self.close }, Gosu::Image.new(self, "images/item.png", false))

    @menu.add_item(Gosu::Image.new(self, "images/exit.png", true), 100, 300, 1, lambda { self.close }, Gosu::Image.new(self, "images/exit.png", false))
  end

  def update
    @menu.update
  end

  def button_down (id)
    if id == Gosu::MsLeft then
        @menu.clicked
    end
  end

  def draw
    @menu.draw
    @cursor.draw(self.mouse_x, self.mouse_y, 1)
    @background_image.draw(0,0,0)
  end

  def menu

  end

end

game = Game.new.show
