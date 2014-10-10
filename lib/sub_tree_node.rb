class SubTreeNode
  attr_accessor :item_node, :parent, :link, :children

  def initialize(item_node, parent = nil, link = nil, children = nil)
    if (item_node && item_node.class != ItemNode) ||
        (parent && parent.class != SubTreeNode) || (link && link.class != SubTreeNode) ||
        (children && children.class != Array)
      raise TypeError
    end
    @item_node = item_node
    @parent = parent
    @link = link
    @children = children
  end

  def support
    self.item_node.support
  end

  def item
    self.item_node.item
  end

  def increase_support
    self.item_node.increase_support
  end

  def decrease_support
    self.item_node.increase_support
  end

  def support=(support)
    self.item_node.support = support
  end

  def link_depth(depth = 0)
    if self.link.nil?
      return depth
    end
    self.link.link_depth(depth + 1)
  end

  def item_support(total_support = 0)
    if self.link.nil?
      return self.support + total_support
    end
    self.link.item_support(self.support + total_support)
  end

  def add_child(item)
    if self.children.nil?
      self.children = []
      new_child = SubTreeNode.new(ItemNode.new(item, 1), self)
      self.children << new_child
      return new_child
    end
    self.children.each do |child|
      if child.item == item
        child.increase_support
        return child
      end
    end
    child = SubTreeNode.new(ItemNode.new(item, 1), self)
    self.children << child
    child
  end

  def add_link(new_link)
    if self.link.nil?
      self.link = new_link
      return
    else
      self.link.add_link(new_link)
    end
  end

  def conditional_pattern(trim, current_pattern = [])
    if self.parent.nil? && self.item.nil?
      return current_pattern.reverse
    end
    self.decrease_support if trim
    self.parent.conditional_pattern(trim, current_pattern << ItemNode.new(self.item, 1))
  end

  def prune
    self.parent.remove_child(self)
  end

  def remove_child(node)
    self.print_children
    self.children.each do |child|
      if child.item == node.item
        child = nil
      end
    end
    self.children.compact!
  end

  def print_children
    puts "["
    self.children.each do |child|
      if child
        puts "#{child.item}:#{child.support}"
      else
        puts "nil"
      end
    end
    puts "]"
  end

end
