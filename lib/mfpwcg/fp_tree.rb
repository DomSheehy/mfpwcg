class FPTree

  attr_accessor :header_table, :root, :dataset, :candidate_items

  def initialize(dataset, candidate_items=nil)
    if dataset && dataset.class != DataSet
      raise TypeError
    end
    @dataset, @candidate_items = FPTree.prepare_dataset(dataset, candidate_items)
    @root = SubTreeNode.new(ItemNode.new(nil,0))
    @header_table = create_header_table(@dataset.ordered_item_list(@candidate_items))
  end

  def self.prepare_dataset(dataset, candidate_items = nil)
    dataset.add_and_support
    dataset.trim
    if candidate_items.nil?
      candidate_items = dataset.ordered_item_list
    end
    [dataset, candidate_items]
  end

  def create_header_table(frequent_items)
    headers = []
    frequent_items.each do | item_node |
      headers << SubTreeNode.new(ItemNode.new(item_node, 0 ))
    end
    self.header_table = headers
  end

  def grow_tree
    self.dataset.order_transaction_items(self.candidate_items).each do |transaction|
      add_transaction(transaction, self.root)
    end
    self.calculate_header_support
  end

  def add_transaction(transaction, parent)
    if transaction.empty?
      return
    end
    added_child = parent.add_child(transaction.shift)
    add_link(added_child)
    add_transaction(transaction, added_child)
  end

  def add_link(child)
    if child.support == 1 #leaf in a new branch
      self.header_table.each do |header|
        if header.item == child.item
          return header.add_link(child)
        end
      end
    end
  end

  def calculate_header_support
    self.header_table.each do |header|
      header.support = header.link.item_support
    end
  end

  def conditional_pattern_base(trim, current_link, current_pattern_base = [])
    if current_link.nil?
      self.calculate_header_support if trim
      return current_pattern_base
    end
    current_pattern_base << current_link.parent.conditional_pattern(trim, current_link.support)
    self.conditional_pattern_base(trim, current_link.link, current_pattern_base)
  end

  def has_single_path?
    if self.header_table.size > 0
      self.header_table.each do |header|
        if header.link_depth != 1
          return false
        end
      end
      true
    end
  end

  #work on pruning this tree
  def prune_tree
    self.header_table.reverse.each do |header|
      current_link = header.link
      previous_connection = header
      while current_link
        if current_link.support < self.dataset.support
          previous_connection.link = current_link.link
          current_link.prune
          current_link = previous_connection.link
        else
          previous_connection = current_link
          current_link = current_link.link
        end
      end
    end
  end

  def self.fp_growth(tree, pattern = '')
    frequent_patterns = []
    if tree.has_single_path?
      link = tree.header_table.reverse.first.link

      single_pattern = link.parent.conditional_pattern(true, tree.dataset.support, [ItemNode.new(link.item, link.support)])
      puts "first link: #{pattern}"
      frequent_patterns << single_pattern.map{|node| node.item}.join('')+pattern
    else
      tree.header_table.reverse.each do |header|
        puts "processing #{header.item}  #{header.support} #{header.link}"
        frequent_patterns << header.item + pattern
        conditional_patterns = tree.conditional_pattern_base(false, header.link)
        conditional_dataset = DataSet.new(DataSet.transactions_from_pattern_base(conditional_patterns), tree.dataset.support)
        conditional_tree = FPTree.new(conditional_dataset, tree.candidate_items)
        conditional_tree.grow_tree
        puts "condtree:"
        conditional_tree.print_tree
        if conditional_tree.header_table.size > 0
          frequent_patterns << FPTree.fp_growth(conditional_tree, header.item + pattern )
        end
      end
    end
    puts "feqs #{frequent_patterns}"
    frequent_patterns.flatten.uniq
  end

  def get_header_depths_and_supports
    props = {}
    self.header_table.each do | header|
      props.merge!({header.item =>{:depth => header.link_depth, :support => header.support }})
    end
    props
  end
  def find_header_of_item(item)
    self.header_table.each do |header|
      if item == header.item
        return header
      end
    end
  end
  def print_tree
    if root.children
      puts " - root : #{root.children.length} - "
      root.children.each{|child| child.print_node}
      puts ""
    end
  end
end
