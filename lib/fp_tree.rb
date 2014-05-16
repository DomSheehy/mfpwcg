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
    add_transaction(transaction, added_child)
  end

end
