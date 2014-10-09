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
end
