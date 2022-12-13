inputfile = "input.txt"

instructions = File.foreach(inputfile).each_with_object([]) do |line, instructions|
  line = line.strip
  if line == "noop"
    instructions.push({ duration: 1, amount: 0 })
  else
    amount = line.split(' ')[1].to_i
    instructions.push({ duration: 2, amount: amount })
  end
end

state = { x: 1, cycle: 1, signal_strengths: [0], pixels: [] }

instructions.each do |instruction|
  instruction[:duration].times do
    state[:signal_strengths].push state[:x] * state[:cycle]
    if (state[:x] - 1 <= ((state[:cycle]-1) % 40) && ((state[:cycle]-1) % 40) <= state[:x] + 1)
      state[:pixels].push '#'
    else
      state[:pixels].push '.'
    end 
    state[:cycle] += 1
  end
  state[:x] += instruction[:amount]
end

strs = state[:signal_strengths]
puts strs[20] + strs[60] + strs[100] + strs[140] + strs[180] + strs[220]
(0...6).each { |row| puts state[:pixels][(row*40...row*40+40)].join('') }

