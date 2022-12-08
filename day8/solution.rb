inputfile = "input.txt"

grid = File.foreach(inputfile).each_with_object([]).with_index do |(line, grid), index|
  grid[index] = line.strip.chars.map(&:to_i)
end

width = grid[0].size
height = grid.size
visibility_grid = Array.new(height) { |row| Array.new(width) { |col| 0 } }

def scan(walking_vertical, looking_forward, width, height, grid, visibility_grid)
  outer_loop_is_rows = walking_vertical
  inner_loop_is_forward = looking_forward
  outer_range = (0 ... (outer_loop_is_rows ? height : width))
  inner_range = (0 ... (outer_loop_is_rows ? width : height))
  inner_range = inner_range.to_a.reverse unless inner_loop_is_forward

  outer_range.each do |i|
    highest_seen = -1
    inner_range.each do |j|
      row = outer_loop_is_rows ? i : j
      col = outer_loop_is_rows ? j : i
      if grid[row][col] > highest_seen
        visibility_grid[row][col] = 1
        highest_seen = grid[row][col]
      end
    end
  end
end

scan(true, true, width, height, grid, visibility_grid)
scan(true, false, width, height, grid, visibility_grid)
scan(false, true, width, height, grid, visibility_grid)
scan(false, false, width, height, grid, visibility_grid)

puts visibility_grid.flatten.sum

# part 2

def scenic_score(row, col, grid, width, height)
  viewing_distances = [[-1, 0], [1, 0], [0, -1], [0, 1]].map do |(dx, dy)|
    dist = 0
    cur_row = row
    cur_col = col
    loop do
      cur_row += dy
      cur_col += dx
      if (0 <= cur_row && cur_row < height) && (0 <= cur_col && cur_col < width)
        dist += 1
      else
        break
      end
      if grid[cur_row][cur_col] >= grid[row][col]
        break
      end
    end
    dist
  end
  viewing_distances.reduce(:*)
end

puts grid.map.with_index { |row, row_index| row.map.with_index { |col, col_index| scenic_score(row_index, col_index, grid, width, height) }.max }.max