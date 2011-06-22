
yaml_path = ARGV[0]
file_path = ARGV[1]

def find_node(lines, indent_size, node_line, node_level, node_path)
  node_name = node_path[0]
  lines.each_with_index do |line, i|
    line_no = i+1
    next if line_no < node_line
    match = line.match(Regexp.union(/^(\s*)(\w+):/, /^(\s*)"(\w+)":/))
    next unless match
    name = match[2] || match[4]
    line_level = (match[1] || match[3]).length / indent_size
    if line_level < node_level
      return nil
    elsif line_level == node_level
      if name == node_name
        if node_path.length == 1
          return line_no
        else
          return find_node(lines, indent_size, line_no+1, node_level+1, node_path[1..-1])
        end
      end
    end
  end
  return nil
end

lines = IO.readlines(file_path)
line_no = find_node(lines, 2, 1, 0, yaml_path.split('.'))
if line_no
  puts "#{file_path}:#{line_no}: #{lines[line_no-1].chomp}"
else
  puts "#{file_path}: not found."
end
