inputfile = "input.txt"

# The match index this returns will be the start of the marker - 3 characters too few
# /(.)(?!.{0,2}\1)/ breaks down as
# (.) a character
# (? matches under the condition
# ! that it's not followed by
# .{0,2} zero to two other characters
# \1 and then itself
regexp = /(.)(?!.{0,2}\1)(.)(?!.{0,1}\2)(.)(?!\3)(.)/

def regexp_fragment_nth_char_not_followed_by_itself_for_m_characters(n, m)
  "(.)(?!.{0,#{m-1}}\\#{n})"
end

part2_regexp_str = (1..13).map { |n| regexp_fragment_nth_char_not_followed_by_itself_for_m_characters(n, 14-n) }.join('') + "(.)"
part2_regexp = Regexp.new(part2_regexp_str)

info = File.foreach(inputfile).each_with_object({}) do |line, map|
  if line.strip.size > 0
    map[:marker] = line.strip =~ regexp
    map[:marker2] = line.strip =~ part2_regexp
  end
end

puts info[:marker]+4 # +3 for the remaining length of the marker and +1 for zero-indexed
puts info[:marker2]+14 # +13 for the remaining length of the marker and +1 for zero-indexed
