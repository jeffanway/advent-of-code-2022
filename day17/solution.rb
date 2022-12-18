inputfile = "input.txt"

LINES_BETWEEN_TOP_AND_SPAWN = 3
COLUMNS_BETWEEN_LEFT_AND_SPAWN = 2
TALLEST_ROCK_HEIGHT = 4
CAVERN_WIDTH = 7
ROCK_TYPE_COUNT = 5

class Rock
  @@patterns = [
    [[0,0], [1,0], [2,0], [3,0]],
    [[1,0], [0,1], [1,1], [2,1], [1,2]],
    [[0,0], [1,0], [2,0], [2,1], [2,2]],
    [[0,0], [0,1], [0,2], [0,3]],
    [[0,0], [1,0], [0,1], [1,1]]
  ]

  def initialize(type, x, y)
    @type = type
    @x = x
    @y = y
  end

  def try_move(dx, dy, cavern)
    new_x = @x + dx
    new_y = @y + dy
    if points(new_x, new_y).all? { |pt| pt[0].between?(0, cavern[0].size-1) && pt[1] >= 0 && cavern[pt[1]][pt[0]] != '#' }
      @x = new_x
      @y = new_y
      true
    else
      false
    end
  end

  def settle(cavern)
    points.each { |pt| cavern[pt[1]][pt[0]] = '#' }
  end

  def points(x = @x, y = @y)
    @@patterns[@type].map { |pt| [x + pt[0], y + pt[1]] }
  end
end

class Simulation
  
  def initialize(air_pattern)
    @air_pattern = air_pattern
    @cavern = []
    @settled_rock_count = 0
    @air_step = 0
  end

  def part1
    while @settled_rock_count < 2022
      another_rock
    end
    @cavern.size
  end

  def part2
    cavern_window_height = 1000
    truncated_cavern_rows = 0
    previous_cavern_states = {}
    state = []

    loop do
      another_rock

      to_truncate = @cavern.size - cavern_window_height
      if to_truncate > 0
        @cavern.shift(to_truncate)
        truncated_cavern_rows += to_truncate
      end

      state = [@cavern, @settled_rock_count % ROCK_TYPE_COUNT, @air_step % @air_pattern.size]
      break if previous_cavern_states.has_key?(state)
      previous_cavern_states[state] = [@cavern.size + truncated_cavern_rows, @settled_rock_count]
    end

    cycle_start_height, cycle_start_rocks = previous_cavern_states[state]
    cycle_end_height, cycle_end_rocks = [@cavern.size + truncated_cavern_rows, @settled_rock_count]
    cycle_height = cycle_end_height - cycle_start_height
    cycle_rocks = cycle_end_rocks - cycle_start_rocks
    cycles, to_go = (1000000000000 - cycle_end_rocks).divmod(cycle_rocks)
    # [pre-cycle][first cycle](we are here)[...many cycles...][to_go rocks]
    to_go.times { another_rock }
    # [pre-cycle][first cycle][to_go rocks](we are here)[...many cycles...]
    @cavern.size + truncated_cavern_rows + cycles*cycle_height
  end

  def another_rock
    rock_spawn_height = @cavern.size + LINES_BETWEEN_TOP_AND_SPAWN
    # add space at the top for a rock to spawn and move
    (LINES_BETWEEN_TOP_AND_SPAWN + TALLEST_ROCK_HEIGHT).times { @cavern.push " " * CAVERN_WIDTH}
    rock = Rock.new(@settled_rock_count % ROCK_TYPE_COUNT, 2, rock_spawn_height)

    loop do 
      @air_pattern[@air_step % @air_pattern.size] == '<' ? rock.try_move(-1, 0, @cavern) : rock.try_move(1, 0, @cavern)
      @air_step += 1
      unless rock.try_move(0, -1, @cavern)
        rock.settle(@cavern)
        @settled_rock_count += 1
        break
      end
    end

    # trim empty rows off the top so the size of cavern is the height of the highest rock
    while @cavern[-1].strip.empty?
      @cavern.pop
    end
  end
end

air_pattern = File.readlines(inputfile)[0].strip

puts Simulation.new(air_pattern).part1
puts Simulation.new(air_pattern).part2
