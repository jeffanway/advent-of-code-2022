inputfile = "input.txt"

char_to_height = ('a'..'z').zip(1..26).to_h.merge({'S' => 1, 'E' => 26})

s = nil
e = nil

grid = File.foreach(inputfile).each_with_object([]).with_index do |(line, grid), index|
  if line.strip.size == 0
    break
  end
  grid.push line.strip.chars.map { |char| char_to_height[char] }
  if s == nil && scol = line.index('S')
    s = [scol, index]
  end
  if e == nil && ecol = line.index('E')
    e = [ecol, index]
  end 
end

height = grid.size
width = grid[0].size
area = height*width

def neighbors(node, grid, width, height)
  possible_neighbors = [[-1, 0], [1, 0], [0, -1], [0, 1]].map { |delta| [node[0] + delta[0], node[1] + delta[1]] }
  in_bounds = possible_neighbors.filter do |neighbor| 
    (0 <= neighbor[0]) && (neighbor[0] < width) && (0 <= neighbor[1]) && (neighbor[1] < height)
  end
  in_height = in_bounds.filter do |ib|
    (grid[ib[1]][ib[0]] <= grid[node[1]][node[0]] + 1)
  end
  in_height
end

# Dijkstra's Algorithm, go!
dists = Hash.new(area)
dists[s] = 0

to_visit = (0...width).map { |x| (0...height).map { |y| [x, y]} }.reduce(:+)

cur_node = s
while cur_node != e
  neighbors(cur_node, grid, width, height).each do |neighbor|
    if to_visit.include? neighbor
      if dists[cur_node] + 1 < dists[neighbor]
        dists[neighbor] = dists[cur_node] + 1 # 1 is the edge length
      end
    end
  end
  to_visit.delete cur_node
  cur_node = to_visit.min { |a,b| dists[a] <=> dists[b] }
end

puts dists[e]
