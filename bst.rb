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
    puts arr
    return Node.new(nil, nil, arr[0]) if arr.length == 1

    middle_index = arr.length / 2
    root_node = Node.new(nil, nil, arr[middle_index])
    root_node.left = build_tree(arr.slice(0, middle_index))
    root_node.right = build_tree(arr.slice(middle_index + 1, arr.length))
    root_node
  end
end
