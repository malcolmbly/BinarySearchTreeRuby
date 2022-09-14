class BST
  class Node
    include Comparable
    attr_accessor :left, :right
    attr_reader :data

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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
  
end

tree = BST.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
tree.pretty_print