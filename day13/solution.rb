inputfile = "input.txt"

def packet_str_to_array(str)
  stack = []
  result = []
  index = 0
  while index < str.size
    case str[index]
    when '['
      stack.push '['
      index += 1
    when /\d/
      next_index = str.index(/\D/, index+1)
      stack.push str[index..next_index-1].to_i
      index = next_index
    when ','
      index += 1
    when ']'
      tmp = []
      while (element = stack.pop) != '['
        tmp.push element
      end
      stack.push tmp.reverse
      index += 1
    end
  end
  stack[0]
end

def packet_compare(p1, p2)
  if (p1.is_a? Integer) && (p2.is_a? Integer)
    p1 <=> p2
  elsif (p1.is_a? Array) && (p2.is_a? Array)
    (0...p1.size).each do |idx|
      return 1 unless idx < p2.size
      comp = packet_compare(p1[idx], p2[idx])
      return comp unless comp == 0
    end
    return (p1.size == p2.size) ? 0 : -1
  elsif (p1.is_a? Array)
    packet_compare(p1, [p2])
  else
    packet_compare([p1], p2)
  end
end

pairs = File.foreach(inputfile).each_slice(3).each_with_object([]) do |lines, pairs|
  pairs.push([packet_str_to_array(lines[0].strip), packet_str_to_array(lines[1].strip)])
end

puts pairs.map.with_index { |pair, index| packet_compare(pair[0], pair[1]) == -1 ? index+1 : 0 }.sum

packets = pairs.each_with_object([]) do |pair, packets|
  packets.push pair[0]
  packets.push pair[1]
end
packets.push [[2]]
packets.push [[6]]
sorted = packets.sort { |p1, p2| packet_compare(p1, p2) }
puts (sorted.index([[2]])+1) * (sorted.index([[6]])+1)