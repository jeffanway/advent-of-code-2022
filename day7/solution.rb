inputfile = "input.txt"

cd_pattern = /\$ cd (?<dir>.+)\n/
ls_pattern = /\$ ls\n/
dir_pattern = /dir (?<name>.+)\n/
file_pattern = /(?<size>\d+) (?<name>.+)\n/

class Node
  def initialize(name, parent = nil, size = nil)
    @name = name
    @size = size
    @parent = parent
    @files = []
  end

  def is_dir?
    @size.nil?
  end

  def size
    if is_dir?
      if @files.size > 0
        return @files.map { |f| f.size }.sum
      else
        return 0
      end
    else
      return @size
    end
  end

  def add_file(file)
    if find_file_by_name(file.name) == nil
      @files.push(file) 
    end
  end

  def find_file_by_name(name)
    @files.find { |f| f.name == name }
  end

  def parent
    @parent
  end

  def files
    @files
  end

  def name
    @name
  end
end

root = Node.new("/")
curr_node = root

File.foreach(inputfile).each do |line|
  case line
  when cd_pattern
    dir = line.match(cd_pattern)[:dir]
    if dir == '..'
      curr_node = curr_node.parent unless curr_node.parent.nil?
    elsif dir == '/'
      curr_node = root
    else
      curr_node = curr_node.find_file_by_name(dir)
    end
  when dir_pattern
    name = line.match(dir_pattern)[:name]
    curr_node.add_file(Node.new(name, curr_node))
  when file_pattern
    matches = line.match(file_pattern)
    curr_node.add_file(Node.new(matches[:name], curr_node, matches[:size].to_i))
  end
end

to_visit = [root]
directory_sizes = []

while node = to_visit.shift
  if node.is_dir?
    directory_sizes.push node.size
  end
  to_visit.push(*node.files)
end

current_space = 70000000 - root.size
need_to_free = 30000000 - current_space

puts directory_sizes.filter { |s| s <= 100000 }.sum # part 1
puts directory_sizes.filter { |s| s >= need_to_free }.min # part 2
