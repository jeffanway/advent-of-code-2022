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

def outcome_to_delta(outcome)
  case outcome
  when 'X'
    2
  when 'Y'
    0
  when 'Z'
    1
  end
end

def outcome_vals(delta)
  case delta
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
  outcome = line[2]
  delta = outcome_to_delta(outcome)
  # delta = (shape_vals(you) - shape_vals(opp)) % 3
  # shape_vals(you) = delta + shape_vals(opp) % 3
  your_play_val = ((delta + shape_vals(opp)) % 3)
  outcome_vals(delta) + (your_play_val == 0 ? 3 : your_play_val )
end

scores = File.foreach(inputfile).each_with_object([]) do |line, list|
  list.push(score_for_round(line))
end

puts scores.sum
