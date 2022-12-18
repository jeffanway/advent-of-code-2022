inputfile = "input.txt"

cubes = File.foreach(inputfile).each_with_object({}) do |line, cubes|
  cubes[line.strip.split(',').map(&:to_i)] = true unless line.strip.empty?
end

def adjacents(cube)
  [[-1,0,0],[1,0,0],[0,-1,0],[0,1,0],[0,0,-1],[0,0,1]].map do |(dx,dy,dz)|
    [cube[0] + dx, cube[1] + dy, cube[2] + dz]
  end
end

# Part 1
puts cubes.keys.map { |cube| adjacents(cube).count { |adj| !cubes.has_key?(adj) } }.sum

# Part 2
xs = cubes.keys.map{ |c| c[0] }
ys = cubes.keys.map{ |c| c[1] }
zs = cubes.keys.map{ |c| c[2] }
xrange = (xs.min-1..xs.max+1)
yrange = (ys.min-1..ys.max+1)
zrange = (zs.min-1..zs.max+1)

air_nodes = xrange.each_with_object({}) do |x, air_nodes|
  yrange.each do |y|
    zrange.each do |z|
      loc = [x, y, z]
      next if cubes.has_key?(loc)
      neighbors = adjacents(loc).filter { |adj| xrange.include?(adj[0]) && yrange.include?(adj[1]) && zrange.include?(adj[2]) && !cubes.has_key?(adj) }
      air_nodes[loc] = neighbors || []
    end
  end
end

def dijkstra(start_loc, nodes)
  dists = Hash.new(Float::INFINITY)
  dists[start_loc] = 0
  to_visit = nodes.keys
  while curr = to_visit.min { |a,b| dists[a] <=> dists[b] }
    break if dists[curr] == Float::INFINITY # no more reachable nodes to visit
    nodes[curr].each do |neighbor|
      if dists[curr] + 1 < dists[neighbor]
        dists[neighbor] = dists[curr] + 1
      end
    end
    to_visit -= [curr]
  end
  dists
end

dists = dijkstra([xrange.min, yrange.min, zrange.min], air_nodes)

puts cubes.keys.map { |cube| adjacents(cube).count { |adj| !cubes.has_key?(adj) && dists[adj] != Float::INFINITY } }.sum
