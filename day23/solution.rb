grid = Hash.new('.')

File.foreach("input.txt").each_with_index do |line, y|
  next if line.strip.empty?
  line.strip.chars.each_with_index do |c, x|
    grid[[x, y]] = c if c == '#'
  end
end

moves = [
  { checks: [[-1, -1], [0, -1], [1, -1]], move: [0, -1] },
  { checks: [[-1, 1], [0, 1], [1, 1]], move: [0, 1] },
  { checks: [[-1, -1], [-1, 0], [-1, 1]], move: [-1, 0] },
  { checks: [[1, -1], [1, 0], [1, 1]], move: [1, 0] }
]

def add_to_pos(pos, delta)
  [pos[0] + delta[0], pos[1] + delta[1]]
end

def do_rounds(n, grid, moves)
  number_of_moves = 0
  n.times do
    proposals = Hash.new { |h,k| h[k] = [] }
    grid.keys.each do |pos|
      possible_moves = moves.filter do |m|
        m[:checks].none? { |c| grid.has_key?(add_to_pos(pos, c)) }
      end
      if possible_moves.size.between?(1,3) # can move (>0), and need to (<4)
        new_pos = add_to_pos(pos, possible_moves.first[:move])
        proposals[new_pos].push(pos)
      end
    end

    proposals.each do |k,v|
      next if v.size != 1
      old_pos = v[0]
      grid.delete old_pos
      grid[k] = '#'
      number_of_moves += 1
    end

    moves << moves.shift
  end
  number_of_moves
end

do_rounds(10, grid, moves)

xs = grid.keys.map { |p| p[0] }
ys = grid.keys.map { |p| p[1] }
puts (xs.max - xs.min + 1) * (ys.max - ys.min + 1) - grid.keys.size

rounds = 10
while (number_of_moves = do_rounds(1, grid, moves)) != 0
  rounds += 1
end

puts rounds + 1
