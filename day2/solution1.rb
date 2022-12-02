inputfile = "input.txt"

def shape_vals(letter)
  case letter
  when 'A', 'X'
    1
  when 'B', 'Y'
    2
  when 'C', 'Z'
    3
  end
end

def outcome_vals(outcome)
  case outcome
  when 0
    3
  when 1
    6
  when 2
    0
  end
end

def score_for_round(line)
  opp = line[0]
  you = line[2]
  shape_vals(you) + outcome_vals((shape_vals(you) - shape_vals(opp)) % 3)
end

scores = File.foreach(inputfile).each_with_object([]) do |line, list|
  list.push(score_for_round(line))
end

puts scores.sum
