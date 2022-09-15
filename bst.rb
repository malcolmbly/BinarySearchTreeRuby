class BST
  class Node
    include Comparable
    attr_accessor :left, :right, :data

    def initialize(left, right, data)
      @left = left
      @right = right
      @data = data
    end

    def <=>(other)
      @data <=> other.data
    end
  end

  attr_reader :root

  def initialize(arr)
    arr = arr.sort.uniq
    @root = build_tree(arr)
  end

  def build_tree(arr)
    # builds tree recursively by getting middle point,
    # then setting the left to build from the left half, and the right from the right half
    # returns root node of tree at end
    return nil if arr.length.zero?
    return Node.new(nil, nil, arr[0]) if arr.length == 1

    middle_index = arr.length / 2
    root_node = Node.new(nil, nil, arr[middle_index])
    root_node.left = build_tree(arr.slice(0, middle_index))
    root_node.right = build_tree(arr.slice(middle_index + 1, arr.length))
    root_node
  end

  def insert(value, start_node = @root)
    node_value = start_node.data
    return if node_value == value

    if start_node.right.nil? && value > node_value
      start_node.right = Node.new(nil, nil, value)
    elsif start_node.left.nil? && value < node_value
      start_node.left = Node.new(nil, nil, value)
    else
      value > node_value ? insert(value, start_node.right) : insert(value, start_node.left)
    end
  end

  def delete(value)
    parent_node = nil
    current_node = @root
    node_to_delete = Node.new(nil, nil, value)
    until current_node.nil?
      if current_node == node_to_delete
        if current_node.left.nil? && current_node.right.nil?
          # node has no children
          current_node > parent_node ? parent_node.right = nil : parent_node.left = nil
        elsif current_node.left.nil? || current_node.right.nil?
          # node has one child
          current_node.left.nil? ? current_node = current_node.right : current_node = current_node.left
          current_node > parent_node ? parent_node.right = current_node : parent_node.left = current_node
        else
          # node has two children
          value < @root.data ? current_node = Node.new(current_node.left, nil, current_node.right.data) : current_node = Node.new(nil, current_node.right, current_node.left.data)
          current_node > @root ? parent_node.right = current_node : parent_node.left = current_node
        end
        break
      end
      parent_node = current_node
      node_to_delete > current_node ? current_node = current_node.right : current_node = current_node.left
    end
  end

  def find(value)
    current_node = @root
    until current_node.nil?
      return current_node if current_node.data == value
      current_node = value > current_node.data ? current_node.right : current_node.left
    end
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def level_order(&block_argument)
    arr = []
    queue = [@root]
    until queue.empty?
      node = queue.shift
      arr.append(node.data)
      queue.append(node.left) unless node.left.nil?
      queue.append(node.right) unless node.right.nil?
    end

    if block_argument
      arr.each { |n| block_argument.call(n) }
    else
      arr
    end
  end
end

tree = BST.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324, 300, 450, 225, 221, 17, 18, 15])
# tree.pretty_print
# tree.insert(100)
# tree.insert(7)
# tree.insert(2)
# tree.pretty_print
# tree.delete(17)
tree.pretty_print

# p tree.find(451)
p tree.level_order
# test = tree.level_order { |e| e * 2 }
