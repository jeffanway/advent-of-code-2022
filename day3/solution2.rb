inputfile = "input.txt"

type_to_priority = ('a'..'z').zip(1..26).to_h.merge(('A'..'Z').zip(27..52).to_h)

info = File.foreach(inputfile).each_with_object({sacks_in_progress: [], badges: []}) do |line, map|
  map[:sacks_in_progress].push(line.strip)
  if map[:sacks_in_progress].size == 3
    map[:badges].push (map[:sacks_in_progress][0].split('') & map[:sacks_in_progress][1].split('') & map[:sacks_in_progress][2].split(''))[0]
    map[:sacks_in_progress].clear
  end
end

priorities = info[:badges].map { |badge| type_to_priority[badge] }

puts priorities.sum
