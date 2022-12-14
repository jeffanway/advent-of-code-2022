inputfile = "input.txt"

class Point
  attr_accessor :x, :y
  def initialize(x, y)
    @x = x
    @y = y
  end

  def points_between(other_point)
    if x == other_point.x
      start_y = y <= other_point.y ? y : other_point.y
      end_y = y <= other_point.y ? other_point.y : y
      (start_y..end_y).map { |y_coord| Point.new(x, y_coord) }
    elsif y == other_point.y
      start_x = x <= other_point.x ? x : other_point.x
      end_x = x <= other_point.x ? other_point.x : x
      (start_x..end_x).map { |x_coord| Point.new(x_coord, y) }
    end
  end

  def to_s
    "(#{x},#{y})"
  end
end

paths = File.foreach(inputfile).each_with_object([]) do |line, paths|
  paths.push line.strip.split(" -> ").map { |pt_str| Point.new(pt_str.split(',')[0].to_i, pt_str.split(',')[1].to_i) }
end

right = paths.flatten.map(&:x).max
bottom = paths.flatten.map(&:y).max

def make_grid(paths, right, bottom)
  grid = Array.new(right+2) { Array.new(bottom+2, '.') }
  paths.each_with_object(grid) do |path, grid|
    (0...path.size-1).each do |idx|
      path[idx].points_between(path[idx+1]).each { |pt| grid[pt.x][pt.y] = '#'}
    end
  end
end

def add_sand!(x, y, grid, right, bottom)
  return false if grid[x][y] != '.'
  while x.between?(0, right) && y.between?(0, bottom)
    if grid[x][y+1] == '.'
      y += 1
    elsif grid[x-1][y+1] == '.'
      y += 1
      x -= 1
    elsif grid[x+1][y+1] == '.'
      y += 1
      x += 1
    else
      grid[x][y] = 'o'
      return true
    end
  end
  false
end

# Part 1
grid = make_grid(paths, right+2, bottom+2)
resting_count = 0
while add_sand!(500, 0, grid, right, bottom)
  resting_count += 1
end

puts resting_count

# Part 2
grid = make_grid(paths + [[Point.new(0, bottom+2), Point.new(1000, bottom+2)]], 1000, bottom+2)
resting_count = 0
while add_sand!(500, 0, grid, 1000, bottom+2)
  resting_count += 1
end

puts resting_count