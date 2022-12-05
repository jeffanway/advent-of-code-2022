inputfile = "input.txt"

type_to_priority = ('a'..'z').zip(1..26).to_h.merge(('A'..'Z').zip(27..52).to_h)

def misplaced_type_in_sack(sack)
  comp1 = sack[0 .. sack.size/2 - 1]
  comp2 = sack[sack.size/2 .. sack.size-1]
  comp1.each_char do |c|
    return c if comp2.include? c
  end
end

priorities = File.foreach(inputfile).each_with_object([]) do |line, list|
  list.push(type_to_priority[misplaced_type_in_sack(line.strip)])
end

puts priorities.sum
