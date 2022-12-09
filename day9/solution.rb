inputfile = "input.txt"

def move_toward_point(p1, p2)
  move_toward(p1[0], p1[1], p2[0], p2[1])
end

# Moves the point (x,y) towards the target point (tx, ty) by 1 unit in either axis, if they are not already touching
def move_toward(x, y, tx, ty)
  dx = tx - x
  dy = ty - y
  if (dx.abs() >= 2) || (dy.abs() >= 2)
    dx = dx/dx.abs() unless dx == 0
    dy = dy/dy.abs() unless dy == 0
    [x+dx, y+dy]
  else
    [x, y]
  end
end

def vec_add(p1, p2)
  [p1[0] + p2[0], p1[1] + p2[1]]
end

directions = { 'R' => [1, 0], 'L' => [-1, 0], 'U' => [0, 1], 'D' => [0, -1] }

knot_paths = File.foreach(inputfile).each_with_object(Array.new(10) { [[0, 0]] }) do |line, knot_paths|
  dir, n = line.strip.split(' ')
  n.to_i.times do
    (0...10).each do |knot| 
      if knot == 0
        next_point = vec_add(knot_paths[knot].last, directions[dir])
      else
        next_point = move_toward_point(knot_paths[knot].last, knot_paths[knot-1].last)
      end
      knot_paths[knot].push next_point
    end
  end
end

puts knot_paths[1].uniq.size
puts knot_paths[9].uniq.size