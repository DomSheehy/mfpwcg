class SubTreeNode
  attr_accessor :item, :support, :parent, :link, :children 

  def initialize(item, support = 0, parent = nil, link = nil, children = nil)
    if (item && item.class != String) || (support && support.class != Fixnum) ||
        (parent && parent.class != SubTreeNode) || (link && link.class != SubTreeNode) ||
        (children && children.class != SubTreeNode)
      raise TypeError
    end    
    @item = item        
    @support = support
    @parent = parent
    @link = link
    @children = children
  end

  def increase_support
    self.support += 1
  end

  def add_child(item)    
    if self.children.nil?
      self.children = []
      self.children << SubTreeNode.new(item, 1)
      return
    else
      self.children.each do |child| 
        if child.item == item
          child.increase_support
        else

        end
      end
    end

  end
end
