inputfile = "input.txt"

# number_monkey_regex = /(?<name>\D\D\D\D): (?<num>\d+)/
# math_monkey_regex = /(?<name>\D\D\D\D): (?<lh_monkey>\D\D\D\D) (?<op>[-+*/]) (?<rh_monkey>\D\D\D\D)/

nums = {}
maths = []

File.foreach(inputfile) do |line|
  if /(?<name>\D\D\D\D): (?<num>\d+)/ =~ line
    nums[name] = num.to_i
  elsif /(?<name>\D\D\D\D): (?<lh_monkey>\D\D\D\D) (?<op>[-+*\/]) (?<rh_monkey>\D\D\D\D)/ =~ line
    maths << [name, op, lh_monkey, rh_monkey]
  end
end

while !nums.has_key?("root")
  maths.each do |op_deets|
    next unless (!nums.has_key?(op_deets[0]) && nums.has_key?(op_deets[2]) && nums.has_key?(op_deets[3]))
    lhs = nums[op_deets[2]]
    rhs = nums[op_deets[3]]
    result = case op_deets[1]
    when '+'
      lhs + rhs
    when '-'
      lhs - rhs
    when '*'
      lhs * rhs
    when '/'
      lhs / rhs
    end
    nums[op_deets[0]] = result
  end
end

puts nums["root"]