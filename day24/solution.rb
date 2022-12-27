class Vortex
  attr_accessor :x, :y

  def initialize(x, y, direction)
    @x = x
    @y = y
    @direction = direction
  end

  def step(valley)
    case @direction
    when '^'
      @y = valley.miny + ((@y - 1) % (valley.maxy - valley.miny + 1))
    when 'v'
      @y = valley.miny + ((@y + 1) % (valley.maxy - valley.miny + 1))
    when '<'
      @x = valley.minx + ((@x - 1) % (valley.maxx - valley.minx + 1))
    when '>'
      @x = valley.minx + ((@x + 1) % (valley.maxx - valley.minx + 1))
    end
  end
end

class Valley
  attr_accessor :minx, :miny, :maxx, :maxy
  def initialize(minx, miny, maxx, maxy)
    @minx = minx
    @miny = miny
    @maxx = maxx
    @maxy = maxy
  end
end

def neighbors(p)
  n = [[-1,0], [1,0], [0,-1], [0,1]].map { |d| [p[0] + d[0], p[1] + d[1]] }
  n.push(p)
  n
end

def dijkstra(start_loc, nodes, target)
  dists = Hash.new ([[], Float::INFINITY])
  dists[start_loc] = [[], 0]
  to_visit = [start_loc]
  visited = {}
  while curr = to_visit.min { |a,b| dists[a][1] <=> dists[b][1] }
    break if curr[0][0] == target[0] && curr[0][1] == target[1]
    break if dists[curr][1] == Float::INFINITY # no more reachable nodes to visit
    nodes[curr].each do |neighbor|
      if dists[curr][1] + 1 < dists[neighbor][1]
        dists[neighbor] = [dists[curr][0] + [curr], dists[curr][1] + 1]
      end
      to_visit.push(neighbor) unless visited.has_key?(neighbor) || to_visit.include?(neighbor)
    end
    to_visit -= [curr]
    visited[curr] = true
  end
  dists
end

vortices = []

File.foreach("input.txt").each_with_index do |line, y|
  next if line.strip.empty?
  next if line.strip[1..-2].include? '#'
  line.strip[1..-2].chars.each_with_index do |c, x|
    vortices << Vortex.new(x, y-1, c) unless c == '.'
  end
end

xs = vortices.map { |v| v.x }
ys = vortices.map { |v| v.y }
valley = Valley.new(xs.min, ys.min, xs.max, ys.max)
cycle_length = (xs.max - xs.min + 1).lcm(ys.max - ys.min + 1)

safe_squares_at_time = []

cycle_length.times do
  safe_squares = { [valley.minx, valley.miny-1] => true, [valley.maxx, valley.maxy+1] => true }
  (valley.minx..valley.maxx).each do |x|
    (valley.miny..valley.maxy).each do |y|
      safe_squares[[x,y]] = true if vortices.none? { |v| v.x == x && v.y == y }
    end
  end
  safe_squares_at_time.push(safe_squares)
  vortices.each { |v| v.step(valley) }
end

nodes = {}
safe_squares_at_time.each_with_index do |squares, time|
  squares.keys.each do |sq|
    edges = neighbors(sq).filter do |n| 
      safe_squares_at_time[(time+1) % safe_squares_at_time.size].has_key?(n)
    end.map do |n|
      [n, (time+1) % safe_squares_at_time.size]
    end
    nodes[[sq, time]] = edges
  end
end

start_square = [valley.minx, valley.miny-1]
end_square = [valley.maxx, valley.maxy+1]
dists = dijkstra([start_square, 0], nodes, end_square)
end_nodes = dists.keys.filter { |sq, t| (sq[0] == valley.maxx) && (sq[1] == (valley.maxy+1)) }
trip1_length = end_nodes.map { |k| dists[k][0].size }.min
puts trip1_length
dists = dijkstra([end_square, trip1_length], nodes, start_square)
end_nodes = dists.keys.filter { |sq, t| (sq[0] == start_square[0]) && (sq[1] == start_square[1]) }
trip2_length = end_nodes.map { |k| dists[k][0].size }.min
dists = dijkstra([start_square, trip1_length + trip2_length], nodes, end_square)
end_nodes = dists.keys.filter { |sq, t| (sq[0] == end_square[0]) && (sq[1] == end_square[1]) }
trip3_length = end_nodes.map { |k| dists[k][0].size }.min
puts trip1_length + trip2_length + trip3_length
