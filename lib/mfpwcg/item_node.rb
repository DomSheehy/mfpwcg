class ItemNode
  attr_accessor :item, :support

  def initialize(item, support)
    if (item && item.class != String) || (support && support.class != Fixnum)
      raise TypeError
    end
    @item = item
    @support = support

  end

  def increase_support
    @support += 1
  end

  def decrease_support(decrease_by = 1)
    @support -= decrease_by
  end

  def ==(other_node)
    other_node.class == self.class &&
    other_node.support == self.support &&
    other_node.item == self.item

  end

end
