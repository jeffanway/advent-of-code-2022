inputfile = "input.txt"

regexp = /(\d+)-(\d+),(\d+)-(\d+)\n/

info = File.foreach(inputfile).each_with_object({cover_count: 0, overlap_count: 0}) do |line, map|
  points = line.match(regexp).captures
  range1 = points[0].to_i .. points[1].to_i
  range2 = points[2].to_i .. points[3].to_i

  # check complete overlap
  larger = range1.size >= range2.size ? range1 : range2
  smaller = larger == range1 ? range2 : range1

  if ((larger.include? smaller.first) && (larger.include? smaller.last))
    map[:cover_count] += 1
  end

  # check partial overlap
  if ((range1.to_a & range2.to_a).size > 0)
    map[:overlap_count] += 1
  end
end

puts info[:cover_count]
puts info[:overlap_count]
