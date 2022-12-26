SNAFU_CHAR_VALS = { '0' => 0, '1' => 1, '2' => 2, '-' => -1, '=' => -2 }
SNAFU_VAL_CHARS = { -2 => '=', -1 => '-', 0 => '0', 1 => '1', 2 => '2' }

def snafu_to_decimal(snafu)
  snafu.chars.reverse.map.with_index do |c, place|
    SNAFU_CHAR_VALS[c] * 5**place
  end.sum
end

def decimal_to_snafu(decimal)
  remainder = decimal
  place = Math.log(remainder, 5).floor
  base_five = []
  while place != -1
    digit, remainder = remainder.divmod(5**place)
    place -= 1
    base_five << digit
  end
  
  place = 0
  snafu_vals = base_five.reverse
  while place < snafu_vals.size
    while (snafu_vals[place] >= 3)
      snafu_vals[place] -= 5
      snafu_vals.push(0) if place+1 == snafu_vals.size
      snafu_vals[place+1] += 1
    end
    place += 1
  end
  snafu_vals.reverse.map { |v| SNAFU_VAL_CHARS[v] }.join('')
end

decimals = File.foreach("input.txt").each.map do |line|
  next if line.strip.empty?
  snafu_to_decimal(line.strip)
end

puts decimal_to_snafu(decimals.sum)