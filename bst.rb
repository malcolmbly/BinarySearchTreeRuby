class BST  
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

  def find(value, start_node = @root)
    current_node = start_node
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

  def level_order_traversal(&block_argument)
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

  def inorder_traversal(traversal_arr = [], current_node = @root, &block_argument)
    return if current_node.nil?

    inorder_traversal(traversal_arr, current_node.left, &block_argument)
    elem = block_argument ? block_argument.call(current_node.data) : current_node.data
    traversal_arr.append(elem)
    inorder_traversal(traversal_arr, current_node.right, &block_argument)
    traversal_arr
  end

  def preorder_traversal(traversal_arr = [], current_node = @root, &block_argument)
    return if current_node.nil?

    elem = block_argument ? block_argument.call(current_node.data) : current_node.data
    traversal_arr.append(elem)
    preorder_traversal(traversal_arr, current_node.left, &block_argument)
    preorder_traversal(traversal_arr, current_node.right, &block_argument)

    traversal_arr
  end

  def postorder_traversal(traversal_arr = [], current_node = @root, &block_argument)
    return if current_node.nil?

    postorder_traversal(traversal_arr, current_node.left, &block_argument)
    postorder_traversal(traversal_arr, current_node.right, &block_argument)
    elem = block_argument ? block_argument.call(current_node.data) : current_node.data
    traversal_arr.append(elem)
    traversal_arr
  end

  def height(node)
    found_node = find(node.data)
    if found_node.nil?
      nil
    else
      subheight(found_node)
    end
  end

  def subheight(node)
    return 0 if node.left.nil? && node.right.nil?

    if node.right.nil? || node.left.nil?
      node.right.nil? ? subheight(node.left) + 1 : subheight(node.right) + 1
    else
      [subheight(node.left), subheight(node.right)].max + 1
    end
  end

  def depth(target_node)
    current_node = @root
    depth = 0
    until current_node.nil?
      return depth if current_node == target_node

      depth += 1
      current_node = target_node > current_node ? current_node.right : current_node.left
    end
  end

  def balanced?(node = @root)
    if node.left.nil? && node.right.nil?
      true
    elsif !node.left.nil? && !node.right.nil?
      (height(node.left) - height(node.right)).abs <= 1
    else
      node.left.nil? ? height(node.right) < 1 : height(node.left) < 1
    end
  end

  def rebalance
    initialize(level_order)
  end
end

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

tree = BST.new((Array.new(15) { rand(1..100) }))
puts 'Tree initialized:'
tree.pretty_print
puts 'Checking the tree is balanced:'
puts tree.balanced?
puts "Level Order Traversal: #{tree.level_order_traversal}"
puts "Pre Order Traversal: #{tree.preorder_traversal}"
puts "Post Order Traversal: #{tree.postorder_traversal}"
puts "In Order Traversal: #{tree.inorder_traversal}"
tree.insert(110)
tree.insert(112)
tree.insert(114)
tree.pretty_print
puts 'Checking that tree is now unbalanced after adding numbers:'
puts tree.balanced?
puts "Level Order Traversal: #{tree.level_order_traversal}"
puts "Pre Order Traversal: #{tree.preorder_traversal}"
puts "Post Order Traversal: #{tree.postorder_traversal}"
puts "In Order Traversal: #{tree.inorder_traversal}"