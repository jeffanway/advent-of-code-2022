inputfile = "input.txt"

parts = [[3, 20], [1, 10000]]

parts.each do |worry_divisor, rounds|
  monkeys = File.foreach(inputfile).each_slice(7).each_with_object([]) do |lines, monkeys|
    items = lines[1].split(' ')[2..-1].map(&:to_i)
    op_split = lines[2].split(' ')
    op = op_split[-2]
    op_arg = op_split[-1]
    test_mod = lines[3].split(' ')[-1].to_i
    true_target = lines[4].split(' ')[-1].to_i
    false_target = lines[5].split(' ')[-1].to_i
    monkeys.push << { items: items, op: op, op_arg: op_arg, test_mod: test_mod, true_target: true_target, false_target: false_target, inspections: 0 }
  end

  # Worry levels are equivalent for the purposes of the monkeys' tests if we take them modulo the GCD of the monkey's test modulos
  gcd = monkeys.map { |monkey| monkey[:test_mod] }.reduce(:*)

  (1..rounds).each do |round|
    monkeys.each do |monkey|
      while item = monkey[:items].shift
        monkey[:inspections] += 1
        worry = monkey[:op] == '+' ? item + monkey[:op_arg].to_i : item * (monkey[:op_arg] == "old" ? item : monkey[:op_arg].to_i)
        worry = worry / worry_divisor
        worry = worry % gcd
        if (worry % monkey[:test_mod] == 0)
          monkeys[monkey[:true_target]][:items] << worry
        else
          monkeys[monkey[:false_target]][:items] << worry
        end
      end
    end
  end

  puts monkeys.map { |monkey| monkey[:inspections] }.max(2).reduce(:*)
end