=begin
    [C]             [L]         [T]
    [V] [R] [M]     [T]         [B]
    [F] [G] [H] [Q] [Q]         [H]
    [W] [L] [P] [V] [M] [V]     [F]
    [P] [C] [W] [S] [Z] [B] [S] [P]
[G] [R] [M] [B] [F] [J] [S] [Z] [D]
[J] [L] [P] [F] [C] [H] [F] [J] [C]
[Z] [Q] [F] [L] [G] [W] [H] [F] [M]
 1   2   3   4   5   6   7   8   9  
=end

inputfile = "input_modified.txt"

move_format = /move (\d+) from (\d+) to (\d+)\n/

# dummy at index 0 to avoid ugly -1s on src and dest
stacks = [[],
  "ZJG".split(''),
  "QLRPWFVC".split(''),
  "FPMCLGR".split(''),
  "LFBWPHM".split(''),
  "GCFSVQ".split(''),
  "WHJZMQTL".split(''),
  "HFSBV".split(''),
  "FJZS".split(''),
  "MCDPFHBT".split(''),
]

File.foreach(inputfile).each do |line|
  count, src, dest = line.match(move_format).captures
  tmp = []
  count.to_i.times { tmp.push stacks[src.to_i].pop }
  count.to_i.times { stacks[dest.to_i].push tmp.pop }
end

puts stacks.map { |stack| stack.size > 0 ? stack[-1] : '' }.join('')
