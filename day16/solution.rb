inputfile = "input.txt"

class Node
  attr_accessor :label, :flow, :neighbor_labels

  def initialize(label, flow, neighbor_labels)
    @label = label
    @flow = flow
    @neighbor_labels = neighbor_labels
  end

  def to_s
    "Node: #{label}, Flow: #{flow}, Neighbors: #{neighbor_labels.join(", ")}"
  end
end

def dijkstra(start_label, nodes)
  dists = Hash.new(Float::INFINITY)
  dists[start_label] = 0
  to_visit = nodes.each_key.to_a
  while curr = to_visit.min { |a,b| dists[a] <=> dists[b] }
    nodes[curr].neighbor_labels.each do |neighbor|
      if dists[curr] + 1 < dists[neighbor]
        dists[neighbor] = dists[curr] + 1
      end
    end
    to_visit -= [curr]
  end
  dists
end

# Recursively selects each unopened valve as the next target from the current location and finds the maximum possible pressure released having made that choice
# Returns the sum of that optimal future-path value and the value achieved getting to the current location
def max_pressure_releasable_from(curr_pressure, curr_valve, unopened_valves, time_left, distances, valves)
  return [0, []] if unopened_valves.empty?
  future_press, future_path = unopened_valves.map do |next_valve|
    dt = distances[curr_valve][next_valve] + 1
    next_time_left = time_left - dt
    if next_time_left <= 0
      [0, []]
    else
      next_valve_value = next_time_left * valves[next_valve].flow
      press, path = max_pressure_releasable_from(next_valve_value, next_valve, unopened_valves - [next_valve], next_time_left, distances, valves)
      [press, path]
    end
  end.max { |a,b| a[0] <=> b[0] }
  [curr_pressure + future_press, [curr_valve] + future_path] 
end

# Divides the pool of valves among the given number of workers then runs the single-worker algorithm for each and adds them up
# The pool division is done recursively. A number of valves is chosen for the next worker to take, 
#   then for each combination of that size he takes those and the remaining pool is divided amongst one fewer workers
#   until the last worker gets all that's left, if anything
def max_pressure_releasable_by_workers_starting_from(workers, start_valve, unopened_valves, time_left, distances, valves)
  return [[], []] if workers == 0 || unopened_valves.size == 0
  range_this_worker_may_take = workers == 1 ? (unopened_valves.size..unopened_valves.size) : (1..unopened_valves.size/2)
  range_this_worker_may_take.map do |num_taken_by_worker|
    unopened_valves.combination(num_taken_by_worker).map do |valves_taken|
      press, path = max_pressure_releasable_from(0, start_valve, valves_taken, time_left, distances, valves)
      other_presses, other_paths = max_pressure_releasable_by_workers_starting_from(workers-1, start_valve, unopened_valves - valves_taken, time_left, distances, valves)
      [[press] + other_presses, [path] + other_paths]
    end.max { |a,b| a[0].sum <=> b[0].sum }
  end.max { |a,b| a[0].sum <=> b[0].sum }
end

regex = /Valve (?<label>..) has flow rate=(?<flow>\d+); tunnels? leads? to valves? (?<neighbor_labels>(?:\D\D,? ?)+)/

nodes = File.foreach(inputfile).each_with_object({}) do |line, nodes|
  if /Valve (?<label>..) has flow rate=(?<flow>\d+); tunnels? leads? to valves? (?<neighbor_labels>(?:\D\D,? ?)+)/ =~ line
    node = Node.new(label, flow.to_i, neighbor_labels.split(", "))
    nodes[label] = node
  end
end

distances = Hash.new { |hash, key| hash[key] = dijkstra(key, nodes) }
# There are 59 valves but only 15 that work. This is crucial for performance.
working_valves = nodes.each_value.filter { |node| node.flow > 0 }.map(&:label)

# Part 1
puts "Part 1"
pressures, paths = max_pressure_releasable_by_workers_starting_from(1, "AA", working_valves, 30, distances, nodes)
(0...pressures.size).each { |worker| puts "Worker #{worker+1} releases #{pressures[worker]} by opening valves #{paths[worker].join(", ")} in that order."}

# Part 2
puts "Part 2"
pressures, paths = max_pressure_releasable_by_workers_starting_from(2, "AA", working_valves, 26, distances, nodes)
(0...pressures.size).each { |worker| puts "Worker #{worker+1} releases #{pressures[worker]} by opening valves #{paths[worker].join(", ")} in that order."}
puts "Total pressure released: #{pressures.sum}"