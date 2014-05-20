class FPTree

  attr_accessor :header_table, :root, :dataset

  def initialize(dataset)
    if dataset && dataset.class != DataSet
      raise TypeError
    end
    @dataset = dataset
    @root = SubTreeNode.new(nil,0)
    @header_table = create_header_table(dataset.order_item_list)
  end

  def create_header_table(frequent_items)
    headers = []
    frequent_items.each do | item_node |      
      headers << SubTreeNode.new(item_node.item, 0 )
    end
    self.header_table = headers
  end

  def grow_tree
    self.dataset.order_transaction_items.each do |transaction|
      add_transaction(transaction, self.root)      
    end
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
          header.increase_support
          return header.add_link(child)        
        end
      end
    end
  end

  def conditional_pattern_base(current_link, current_pattern_base = [])    
    if current_link.nil?
      return current_pattern_base
    end
    current_pattern_base << [current_link.support, current_link.conditional_pattern]
    conditional_pattern_base(current_link.link, current_pattern_base)
  end

  def has_single_path?
    self.header_table.each do |header|
      if header.support > 1
        return false
      end
    end    
    true
  end

end
