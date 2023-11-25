# frozen_string_literal: true

# Create the board for the knight to traverse and methods to find nodes
class Board
  attr_reader :nodes

  def initialize
    @nodes = {}
  end

  def add_node(node)
    @nodes[node.value] = node
  end

  def add_edge(node1, node2)
    @nodes[node1].add_edge(@nodes[node2])
    @nodes[node2].add_edge(@nodes[node1])
  end

  # Create the graph from possible moves of Knight
  def create_graph(root)
    knight = Knight.new
    board = Board.new

    x = knight.x
    y = knight.y
    queue = [root]
    dequeue = []

    # Continue the loop if it's in the board
    until queue.empty?

      curr_x = queue[0][0]
      curr_y = queue[0][1]
      dequeue << queue.shift

      root_node = BoardNode.new(dequeue[-1])
      board.add_node(root_node)

      x.zip(y).each do |xx, yy|
        new_move = [(xx + curr_x), (yy + curr_y)]

        # Discard new move if out of the board
        next if new_move.any? { |move| move.negative? || move > 7 }
        next unless dequeue.none?(new_move) && queue.none?(new_move)

        # Add the new move and edge
        new_node = BoardNode.new(new_move)
        board.add_node(new_node)
        board.add_edge(root_node.value, new_node.value)

        # Add the new move to the queue
        queue << new_move
      end
    end
    board
  end

  # Traverse the graph
  def breadth_first(graph, initial, destination)
    start = nil
    graph.nodes.each_value { |el| start = el if el.value == initial }

    queue = [start]
    # Stores the parents of the adjacent nodes
    level_order = { start => start }

    until queue.empty?
      first_q = queue.shift

      first_q.adjacent_nodes.each do |node|
        adj_node = nil
        graph.nodes.each_value { |i| adj_node = i if node.value == i.value }
        level_order[adj_node] = first_q
        queue << adj_node
      end
      return level_order if first_q.value == destination
    end
    level_order
  end

  # Reconstruct the level-order hash
  def reconstruct_path(hash, initial, destination, arr = [])
    return arr << initial if destination == initial

    # Check hash for the destination and backtrack until initial is reached
    hash.each_pair do |k,v|
      reconstruct_path(hash, initial, v.value, arr << k.value) if k.value == destination
    end
    arr
  end

  # Find the shortest path to the square destination
  def knight_moves(initial, destination)
    graph = create_graph(initial)
    parent_path = breadth_first(graph, initial, destination)
    path = reconstruct_path(parent_path, initial, destination).reverse

    puts "Knight initial position: #{initial}, move to #{destination}"
    puts "You made it in #{path.length - 1} moves! Here's your path: "
    path.each { |el| p el }
  end
end

# The cells of the board
class BoardNode
  attr_reader :value, :adjacent_nodes
  
  def initialize(value)
    @value = value
    @adjacent_nodes = []
  end

  def add_edge(adjacent_nodes)
    @adjacent_nodes << adjacent_nodes
  end
end