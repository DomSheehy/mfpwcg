class ItemNode
  attr_accessor :item, :support

  def initialize(item, support)
    if (item && item.class != String) || (support && support.class != Fixnum)
      fail TypeError
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

  def ==(other)
    other.class == self.class &&
      other.support == support &&
      other.item == item
  end
end
