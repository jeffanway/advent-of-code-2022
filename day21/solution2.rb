inputfile = "input.txt"

# number_monkey_regex = /(?<name>\D\D\D\D): (?<num>\d+)/
# math_monkey_regex = /(?<name>\D\D\D\D): (?<lh_monkey>\D\D\D\D) (?<op>[-+*/]) (?<rh_monkey>\D\D\D\D)/

nums = {}
maths = []

File.foreach(inputfile) do |line|
  if /(?<name>\D\D\D\D): (?<num>\d+)/ =~ line
    nums[name] = num.to_i unless name == "humn"
  elsif /(?<name>\D\D\D\D): (?<lh_monkey>\D\D\D\D) (?<op>[-+*\/]) (?<rh_monkey>\D\D\D\D)/ =~ line
    maths << [name, op, lh_monkey, rh_monkey] 
  end
end

root_math = maths.find { |m| m[0] == "root" }
root_math[1] = '='
changes_made = 1 # lazy do-while
while changes_made != 0
  changes_made = 0
  maths.each do |m|
    next unless (!nums.has_key?(m[0]) && nums.has_key?(m[2]) && nums.has_key?(m[3]))
    changes_made += 1
    lhs = nums[m[2]]
    rhs = nums[m[3]]
    result = case m[1]
    when '+'
      lhs + rhs
    when '-'
      lhs - rhs
    when '*'
      lhs * rhs
    when '/'
      lhs / rhs
    end
    nums[m[0]] = result
  end
end

def write_expression(nums, maths, monkey_name)
  return nums[monkey_name].to_s if nums.has_key?(monkey_name)
  return monkey_name if monkey_name == "humn"
  expr = maths.find { |m| m[0] == monkey_name }
  "(#{write_expression(nums, maths, expr[2])} #{expr[1]} #{write_expression(nums, maths, expr[3])})"
end

# Given monkey_name = val, looks up the expression for monkey_name and moves the known LHS value into the RHS with the opposite operation
# Ultimately doing something like humn+2=4 => humn=2
def reduce_equation(nums, maths, monkey_name, val)
  return val if monkey_name == "humn"
  expr = maths.find { |m| m[0] == monkey_name }
  known_side = nums.has_key?(expr[2]) ? nums[expr[2]] : nums[expr[3]]
  unknown_monkey = nums.has_key?(expr[2]) ? expr[3] : expr[2]
  case expr[1]
  when '='
    reduce_equation(nums, maths, unknown_monkey, known_side)
  when '+'
    reduce_equation(nums, maths, unknown_monkey, val - known_side)
  when '*'
    reduce_equation(nums, maths, unknown_monkey, val / known_side)
  when '-'
    if unknown_monkey == expr[2]
      # monk - known_side = val
      reduce_equation(nums, maths, unknown_monkey, val + known_side)
    else
      # known_side - monk = val
      reduce_equation(nums, maths, unknown_monkey, known_side - val)
    end
  when '/'
    if unknown_monkey == expr[2]
      # monk / known_side = val
      reduce_equation(nums, maths, unknown_monkey, val * known_side)
    else
      # known_side / monk = val
      reduce_equation(nums, maths, unknown_monkey, known_side / val.to_f)
    end
  end
end

puts reduce_equation(nums, maths, "root", "notused")