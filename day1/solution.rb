inputfile = "input.txt"

sums = File.foreach(inputfile).each_with_object([]) do |line, list|
  if (list.empty? || line.strip.empty?)
    list.push(0)
  end
  list[-1] += line.strip.empty? ? 0 : line.to_i
end

puts sums.max

puts sums.max(3).sum