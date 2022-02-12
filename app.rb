require 'gosu'


class ShowMode < Gosu::Font

  def initialize(window)
		super(15)
		@window = window
	end

	def draw
		if @window.warp_mode == true
			super("Warp Mode: "+"ON",20,2,5,1,1,Gosu::Color::WHITE)
		else
			super("Warp Mode: "+"OFF",20,2,5,1,1,Gosu::Color::WHITE)
		end

    if @window.invicibility == true
      super("No Die Mode: "+"ON",150,2,5,1,1,Gosu::Color::WHITE)
    else
			super("No Die Mode: "+"OFF",150,2,5,1,1,Gosu::Color::WHITE)
		end
	end

end

class HighScore < Gosu::Font

  attr_accessor :highscores
  def initialize()
    super(50)
    @highscores = [0]
  end

  def get_highscore
    @highscores.sort[-1]
  end

  def draw(hs)
    super("HighScore: #{hs}",340,410,5,1,1,Gosu::Color::BLACK)
  end

end

class PausedText < Gosu::Font
  def initialize
    super(50)
  end

  def draw
    super("PAUSED",400,320,5,1,1,Gosu::Color::RED)
  end
end

class Background < Gosu::Image

  def initialize
    super("./grid.png")
    @x = -1.5
    @y = -1.5
  end

  def draw
    super(@x,@y,-1)
  end

end
class BorderTile

  attr_accessor :x,:y,:width,:height, :color
  def initialize(x,y)
    self.x = x
    self.y = y
    self.width = 20
    self.height = 20
    self.color = Gosu::Color::BLACK
  end

  def draw
    Gosu.draw_rect(self.x,self.y,self.width,self.height,self.color)
  end

end



class LosingText < Gosu::Font
  def initialize
    super(150)
  end

  def draw
    super("Game Over", 140,198,-1,1,1,Gosu::Color::BLACK)
  end

end

class Final_Score < Gosu::Font
  def initialize()
    super(50)
  end

  def draw(points)
    super("FinalScore:" +" "+points.to_s, 340,360,-1,1,1,Gosu::Color::BLACK)
  end
end

class Instructions < Gosu::Font
  def initialize()
    super(25)
  end

  def draw
    super("Press 'ESC' to quit,'R' to play again, or 'S' to play reverse mode", 170,497,-1,1,1,Gosu::Color::BLACK)
  end
end

class Score < Gosu::Font
  attr_accessor :color
  def initialize
    super(15)
    @color = Gosu::Color::WHITE
  end

  def draw(text)
    super("Length: "+text.to_s,900,610,3,1,1,self.color)
    super("Press 'W' to Toggle Warp Mode and 'SPACE' to Pause",20,610,3,1,1,self.color)
  end
end


class Square

  SIZE = 20

  attr_accessor :x, :y, :height, :width, :color
  def initialize(x,y)
    self.x = x
    self.y = y
    self.width = SIZE
    self.height = SIZE
    self.color = Gosu::Color::BLACK
  end

  def draw
    Gosu.draw_rect(self.x,self.y,self.width-2,self.height-2,self.color,z=2)
  end
end



class Border
  attr_accessor :border
  def initialize
    @border = [BorderTile.new(0,0)]
    self.create_border
  end

  def create_border
    x = 0
    while x <= 980
      @border << BorderTile.new(x,0)
      @border << BorderTile.new(x,620)
      x += 20
    end
    x1 = 0
    while x1 <= 980
      @border << BorderTile.new(x1,600)
      x1 += 20
    end
    y = 0
    while y <= 620
      @border << BorderTile.new(0,y)
      @border << BorderTile.new(980,y)
      y += 20
    end

  end



  def draw_border
    @border.each{|tile| tile.draw}
  end
end

class Snake

  attr_accessor :snake, :direction
  SIZE = 20
  def initialize
    @snake = [Square.new(500,320), Square.new(500,342)]
    @direction = "u"
  end

  def draw_snake
    @snake.each{|snake| snake.draw}
  end

  def extend_snake
    if self.snake[-1].x == self.snake[-2].x && self.snake[-1].y > self.snake[-2].y
      added_square = Square.new(self.snake[-1].x, self.snake[-1].y+SIZE)
    elsif self.snake[-1].x == self.snake[-2].x && self.snake[-1].y < self.snake[-2].y
      added_square = Square.new(self.snake[-1].x, self.snake[-1].y-SIZE)
    elsif self.snake[-1].x > self.snake[-2].x && self.snake[-1].y == self.snake[-2].y
      added_square = Square.new(self.snake[-1].x+SIZE, self.snake[-1].y)
    elsif self.snake[-1].x < self.snake[-2].x && self.snake[-1].y == self.snake[-2].y
      added_square = Square.new(self.snake[-1].x-SIZE, self.snake[-1].y)
    end
    @snake << (added_square)
  end

  def move_snake

    last_square = @snake.pop
    if self.direction == "u"
      last_square.y = self.snake[0].y - SIZE
      last_square.x = self.snake[0].x
      @snake.unshift(last_square)
    elsif self.direction == "l"
      last_square.x = self.snake[0].x - SIZE
      last_square.y = self.snake[0].y
      @snake.unshift(last_square)
    elsif self.direction == "r"
      last_square.x = self.snake[0].x + SIZE
      last_square.y = self.snake[0].y
      @snake.unshift(last_square)
    elsif self.direction == "d"
      last_square.x = self.snake[0].x
      last_square.y = self.snake[0].y + SIZE
      @snake.unshift(last_square)
    end
  end

  def change_direction
    if Gosu.button_down?(Gosu::KB_RIGHT)
      if self.direction != "l"
        self.direction = "r"
      end
    elsif Gosu.button_down?(Gosu::KB_LEFT)
      if self.direction != "r"
        self.direction = "l"
      end
    elsif Gosu.button_down?(Gosu::KB_DOWN)
      if self.direction != "u"
        self.direction = "d"
      end
    elsif Gosu.button_down?(Gosu::KB_UP)
      if self.direction != "d"
        self.direction = "u"
      end
    end
  end


  def warp
    if self.snake[0].x >= 980
      self.snake[0].x = SIZE
      self.direction == "r"
    elsif self.snake[0].x <= 20
      self.snake[0].x = 980
      self.direction == "l"
    elsif self.snake[0].y <= 0
      self.snake[0].y = 640-SIZE
      self.direction == "u"
    elsif self.snake[0].y >= 620
      self.snake[0].y = SIZE
      self.direction == "d"
    end
  end

  def shorten
    self.snake.pop
  end

end







class Food < Square
  attr_accessor :x, :y, :color
  def initialize(snake)
    @snake = snake
    snake_xs = @snake.snake.map{|snake| snake.x+2}
    snake_ys = @snake.snake.map{|snake| snake.y+2}
    @x = (10..960).to_a.keep_if {|x| x%SIZE == 0 && !snake_xs.include?(x-2)}.sample
    @y = (10..580).to_a.keep_if {|y| y%SIZE == 0 && !snake_ys.include?(y-2)}.sample
    @color = Gosu::Color::RED
  end

  def draw
    Gosu.draw_rect(self.x,self.y,SIZE-2,SIZE-2,@color)
  end

  def relocate
    @x = (10..960).to_a.keep_if {|x| x%SIZE == 0}.sample
    @y = (10..580).to_a.keep_if {|y| y%SIZE == 0}.sample
  end
end


class PowerUp < Gosu::Image
  attr_accessor :x, :y, :color
  def initialize(snake)

    super("./bomb.png")
    @snake = snake
    snake_xs = @snake.snake.map{|snake| snake.x+2}
    snake_ys = @snake.snake.map{|snake| snake.y+2}
    @x = (10..960).to_a.keep_if {|x| x%20 == 0 && !snake_xs.include?(x-2)}.sample
    @y = (10..580).to_a.keep_if {|y| y%20 == 0 && !snake_ys.include?(y-2)}.sample
    @color = Gosu::Color::BLUE
  end

  def draw
    super(@x,@y,-1)
  end

  def relocate
    @x = (10..960).to_a.keep_if {|x| x%SIZE == 0}.sample
    @y = (10..580).to_a.keep_if {|y| y%SIZE == 0}.sample
  end
end



class GameWindow < Gosu::Window

  WIDTH = 1000
  HEIGHT = 640

  attr_accessor :food, :points, :game_running, :speed, :paused, :warp_mode, :invicibility
  def initialize()
    super(WIDTH, HEIGHT)
    self.caption = "Snake"
    @snake = Snake.new
    @food = Food.new(@snake)
    @points  = 0
    @game_running = true
    @score = Score.new
    @losing_text = LosingText.new
    @paused = false
    @superspeed = false
    @speed = 0.035
    @final_score = Final_Score.new
    @border = Border.new
    @background = Background.new
    @instructions = Instructions.new
    @paused_text = PausedText.new
    @warp_mode = false
    @invicibility = false
    @highscore = HighScore.new
    @show_mode = ShowMode.new(self)
    @reverse = false
    @power = PowerUp.new(@snake)

  end

  def draw

    @border.draw_border
    @background.draw
    @show_mode.draw
    if @game_running && @paused == false
      @snake.draw_snake
      @food.draw
      @power.draw
      @score.draw(@points)
    elsif @paused == true
      @snake.draw_snake
      @food.draw
      @score.draw(@points)
      @paused_text.draw
    else
      @losing_text.draw
      @final_score.draw(@points)
      @instructions.draw
      @score.draw(@points)
      @highscore.draw(which_score)
    end
  end

  def button_up(id)

    if id == Gosu::KB_SPACE && @game_running && @paused == true
      @paused = false
    elsif id == Gosu::KB_SPACE && @game_running && @paused == false
      @paused = true
    elsif id == Gosu::KB_W && @warp_mode == false
      @warp_mode = true
    elsif id == Gosu::KB_W && @warp_mode == true
      @warp_mode = false
    elsif id == Gosu::KB_I && @invicibility == false
      @invicibility = true
      @warp_mode = true
    elsif id == Gosu::KB_I && @invicibility == true
      @invicibility = false
    elsif id == Gosu::KB_C
      @snake.color = Gosu::Color::BLUE
    end

  end

  def update


    if @paused == false
      @snake.change_direction
      sleep(@speed)
      @snake.move_snake




      if ate_food?

        if @reverse
          if @snake.snake.length > 2
            5.times do
              @snake.shorten
            end
          end

          @points = @snake.snake.length - 2
        else
          5.times do
            @snake.extend_snake
          end
          @points = @snake.snake.length - 2
        end
        @food = Food.new(@snake)

      end

      if ate_powerup?
        a = rand(0..4)
        if a == 1
          @speed = 0.025
          snakeLength = @snake.snake.length - 2
          snakeLength.times do
            @snake.shorten
          end
        elsif a == 2
          @speed = 0.025
          20.times do
            @snake.extend_snake
          end
        else
          @speed = 0
        end

        @power = PowerUp.new(@snake)
        @points = @snake.snake.length - 2
      end



      if @points <= 0 && @reverse
        @game_running = false
        if Gosu.button_down?(Gosu::KB_R)
          self.restart_game
        elsif Gosu.button_down?(Gosu::KB_ESCAPE)
          self.close!
        elsif Gosu.button_down?(Gosu::KB_R)
          self.restart_reverse

        end
      end

      if collison_self?

        if @invicibility == false
          @game_running = false
        end

        if Gosu.button_down?(Gosu::KB_R)
          self.restart_game
        elsif Gosu.button_down?(Gosu::KB_ESCAPE)
          self.close!
        elsif Gosu.button_down?(Gosu::KB_R)
          self.restart_reverse

        end

      elsif collison_wall?
        if @warp_mode
          @snake.warp
        else
          @game_running = false
        end
        if Gosu.button_down?(Gosu::KB_R)
          self.restart_game
        elsif Gosu.button_down?(Gosu::KB_ESCAPE)
          self.close!
        elsif Gosu.button_down?(Gosu::KB_S)
          self.restart_reverse
        end


      end

  end

  end



  def restart_game
    @reverse = false
    @paused = false
    @snake = Snake.new
    @food = Food.new(@snake)
    @points  = 0
    @food = Food.new(@snake)
    @game_running = true
    @score = Score.new
    @losing_text = LosingText.new
    @speed = 0.035
    @final_score = Final_Score.new
    @border = Border.new
    @background = Background.new
    @power = PowerUp.new(@snake)

  end

  def restart_reverse
    @reverse = true
    @paused = false
    @snake = Snake.new
    @food = Food.new(@snake)
    @points.times do
      @snake.extend_snake
    end
    @points  = @snake.snake.length - 2
    @food = Food.new(@snake)
    @game_running = true
    @score = Score.new
    @losing_text = LosingText.new
    @speed = 0.035
    @final_score = Final_Score.new
    @border = Border.new
    @background = Background.new
    @power = PowerUp.new(@snake)

  end



  private

  def collison_self?
    index = 1
    while index < @snake.snake.length
      if @snake.snake[0].x == @snake.snake[index].x && @snake.snake[0].y == @snake.snake[index].y
        return true
        index = @snake.snake.length
      end
      index +=1
    end
      return false
  end

  def collison_wall?
    if @snake.snake[0].x >= 980
      return true
    elsif @snake.snake[0].x <= 10
      return true
    elsif @snake.snake[0].y <= 10
      return true
    elsif @snake.snake[0].y >= 600
      return true
    else
      return false
    end
  end

  def ate_food?
    if @food.x == @snake.snake[0].x && @food.y == @snake.snake[0].y
      return true
    else
      return false
    end
  end

  def ate_powerup?
    if @power.x == @snake.snake[0].x && @power.y == @snake.snake[0].y
      return true
    else
      return false
    end
 end


  def which_score
    if self.points > @highscore.get_highscore.to_i
      @highscore.highscores[-1] = self.points
      return self.points
    else
      return @highscore.get_highscore.to_i
    end
  end

end

GameWindow.new.show
