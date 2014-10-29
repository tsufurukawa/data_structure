# Searching Binary Trees (Odin Project)

# Binary search trees -- where you take a group of data items and turn them into a tree full of nodes where each left node
# is "lower" than each right node. The tree starts with the "root node" and any node with no children is called a "leaf node".

# This is my implementation of a Binary Search Tree that uses "Breadth-First-Search" and "Depth-First-Search" for finding elements within the tree

class Node
  attr_accessor :value, :left_child, :right_child, :parent

  def initialize(args={})
    @value = args[:value]
    @left_child = args[:left_child] || nil
    @right_child = args[:right_child] || nil
    @parent = args[:parent] || nil
  end

  def to_s
    "This node has a value of #{value} with parent value of #{parent.nil? ? "nil" : parent.value}"
  end
end

class BinarySearchTree
  attr_reader :root_node

  def initialize(data)
    @root_node = nil
    build_tree(data)
  end

  def build_tree(data)
    data.each { |entry| add_node(entry, root_node)}
  end

  # traverse down the tree and add node as a leaf
  def add_node(data, current_node=root_node)
    if current_node.nil?
      @root_node = Node.new(value: data)
    else
      if data <= current_node.value
        if current_node.left_child.nil?
          current_node.left_child = Node.new(value: data, parent: current_node)
        else
          add_node(data, current_node.left_child)
        end
      else
        if current_node.right_child.nil?
          current_node.right_child = Node.new(value: data, parent: current_node)
        else
          add_node(data, current_node.right_child)
        end
      end
    end
  end

  # print out all node and their respective children and parent
  def display_tree(current_node=root_node)
    return nil if current_node.nil?
    left_child = current_node.left_child.nil? ? "none" : current_node.left_child.value
    right_child = current_node.right_child.nil? ? "none" : current_node.right_child.value
    parent = current_node.parent.nil? ? "none" : current_node.parent.value

    puts "Node value: #{current_node.value}, left child: #{left_child}, right child: #{right_child}, parent: #{parent}"

    display_tree(current_node.left_child)
    display_tree(current_node.right_child)
  end

  # "Breadth First Search" implemented using a queue
  def breadth_first_search(target, current_node=root_node)
    return current_node if current_node.value == target
    queue = []

    until current_node.nil?
      left_node = current_node.left_child
      right_node = current_node.right_child

      (left_node.value == target ? (return left_node) : queue << left_node) unless left_node.nil?
      (right_node.value == target ? (return right_node) : queue << right_node) unless right_node.nil?

      current_node = queue.shift
    end
  end

  # "Depth First Search" implemented using a stack
  def depth_first_search(target, current_node=root_node)
    stack = Array.new
    stack << current_node
    visited_nodes = Array.new
    visited_nodes << current_node

    until stack.empty?
      current_node = stack.last
      return current_node if current_node.value == target

      left_node = current_node.left_child
      right_node = current_node.right_child

      if !left_node.nil? && !visited_nodes.include?(left_node)
        stack << left_node
        visited_nodes << left_node
      elsif !right_node.nil? && !visited_nodes.include?(right_node)
        stack << right_node
        visited_nodes << right_node
      else
        # both left and right nodes are nil, or both nodes have already been visited
        stack.pop
      end
    end    
  end

  # "Depth First Search" implemented using recursion
  def depth_first_search_recursive(target, current_node=root_node)
    return current_node if current_node.value == target

    left_node = current_node.left_child
    depth_first_search_recursive(target, left_node) if !left_node.nil?

    right_node = current_node.right_child
    depth_first_search_recursive(target, right_node) if !right_node.nil?
  end
end

tree = BinarySearchTree.new([4, 12, 3, 10, 9, 8, 11, 10, 5, 1, 2])
tree.display_tree
puts "---------------------------"
puts "Breadth First Search:"
puts tree.breadth_first_search(11) #=> "This node has a value of 11 with parent value of 10"
puts tree.breadth_first_search(4) #=> "This node has a value of 4 with parent value of nil"
puts tree.breadth_first_search(20) #=> nil
puts "---------------------------"
puts "Depth First Search:"
puts tree.depth_first_search(9) #=> "This node has a value of 9 with parent value of 10"
puts tree.depth_first_search(5) #=> "This node has a value of 5 with parent value of 8"
puts tree.depth_first_search(20) #=> nil
puts "Depth First Search (Recursion Solution):"
puts tree.breadth_first_search(5) #=> "This node has a value of 5 with parent value of 8"
puts tree.breadth_first_search(11) #=> "This node has a value of 11 with parent value of 10"
puts tree.breadth_first_search(30) #=> nil

# The tree is shown here graphically
=begin
                4
          3          12
       1          10 
          2     9    11
              8  10  
            5
=end
