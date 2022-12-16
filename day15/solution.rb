inputfile = "input.txt"

class Point
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x.to_i
    @y = y.to_i
  end

  def ==(other)
    x == other.x && y == other.y
  end

  def manhattan_distance_from(other_point)
    (x - other_point.x).abs + (y - other_point.y).abs
  end

  def to_s
    "(#{x},#{y})"
  end
end

class Sensor
  attr_accessor :loc, :beacon, :range

  def initialize(loc, beacon)
    @loc = loc
    @beacon = beacon
    @range = loc.manhattan_distance_from(beacon)
  end

  def row_segment_sensed(row)
    center = loc.x
    radius = range - (loc.y - row).abs
    radius < 0 ? nil : (center-radius..center+radius)
  end

  def to_s
    "Location: #{loc.to_s}, Beacon: #{beacon.to_s}, Range: #{range}"
  end
end

def ranges_overlap?(a, b)
  a.include?(b.begin) || b.include?(a.begin)
end

def merge_ranges(a, b)
  [a.begin, b.begin].min..[a.end, b.end].max
end

def merge_overlapping_ranges(overlapping_ranges)
  overlapping_ranges.sort_by(&:begin).inject([]) do |ranges, range|
    if !ranges.empty? && ranges_overlap?(ranges.last, range)
      ranges[0...-1] + [merge_ranges(ranges.last, range)]
    else
      ranges + [range]
    end
  end
end

def sensed_row_segments(row, sensors)
  segments = sensors.map { |sensor| sensor.row_segment_sensed(row) }.compact
  merge_overlapping_ranges(segments)
end

regex = /Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)/

info = File.foreach(inputfile).each_with_object({sensors: [], beacons: []}) do |line, info|
  if match = line.match(regex)
    sensorx, sensory, beaconx, beacony = match.captures
    beacon = Point.new(beaconx, beacony)
    sensor = Sensor.new(Point.new(sensorx, sensory), beacon)
    info[:sensors].push sensor
    info[:beacons].push beacon unless info[:beacons].include? beacon
  end
end

# Check that you've parsed correctly! Spent 4 hours to eventually find 2 beacons have negative coords and my regex didn't match '-'
puts info[:sensors].size # 33

# Part 1
row = 2000000
sensed = sensed_row_segments(row, info[:sensors])

puts sensed.map(&:size).sum - info[:beacons].filter { |beacon| beacon.y == row && sensed.any? { |segment| segment.include? beacon.x } }.size

# Part 2
search_range = (0..4000000)
search_range.each do |row|
  sensed = sensed_row_segments(row, info[:sensors])
  # If the row is not fully covered by sensors
  if !(sensed.any? { |segment| segment.include?(search_range.begin) && segment.include?(search_range.end) })
    sensed.each_slice(2) do |pair|
      # Find the pair of coverage segments separated by exactly 2. The one in the gap is the answer.
      if pair.size == 2 && (pair[0].end+2 == pair[1].begin) && search_range.include?(pair[0].end+1)
        puts "Distress beacon is at (#{pair[0].end+1}, #{row}). Tuning frequency: #{(pair[0].end+1)*4000000 + row}"
        break
      end
    end
    break
  end
end

=begin
Just want to note there are faster ways to do part 2. Mine takes like 10-15 seconds to run.
(on Reddit) I found a solution involving all pairs of sensors and the intersections of the lines of their diamonds.
And a recursive one similar to binary search. Divide the search area into quadrants, and the quadrants into quadrants, etc.
  Stop pursuing quadrants once they are fully covered by any single sensor. You have the answer when you get a 1x1 quadrant.
=end
