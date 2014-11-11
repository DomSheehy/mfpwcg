# This class represents a leaf in the fp tree. A node!
## Item node is the item and support of this leaf
## The parent link and children are other nodes making up the tree
class SubTreeNode
  attr_accessor :item_node, :parent, :link, :children

  def initialize(item_node, parent = nil, link = nil, children = nil)
    if (item_node && item_node.class != ItemNode) ||
       (parent && parent.class != SubTreeNode) || (link && link.class != SubTreeNode) ||
       (children && children.class != Array)
      fail TypeError
    end
    @item_node = item_node
    @parent = parent
    @link = link
    @children = children
  end

  def support
    item_node.support
  end

  def item
    item_node.item
  end

  def increase_support
    item_node.increase_support
  end

  def decrease_support(decrease_by = 1)
    item_node.decrease_support(decrease_by)
  end

  def support=(support)
    item_node.support = support
  end

  def link_depth(depth = 0)
    return depth if link.nil?
    link.link_depth(depth + 1)
  end

  def item_support(total_support = 0)
    return support + total_support if link.nil?
    link.item_support(support + total_support)
  end

  def add_child(item)
    if children.nil?
      self.children = []
      new_child = SubTreeNode.new(ItemNode.new(item, 1), self)
      children << new_child
      return new_child
    end
    children.each do |child|
      if child.item == item
        child.increase_support
        return child
      end
    end
    child = SubTreeNode.new(ItemNode.new(item, 1), self)
    children << child
    child
  end

  def add_link(new_link)
    if link.nil?
      self.link = new_link
      return
    else
      link.add_link(new_link)
    end
  end

  def conditional_pattern(trim, decrease_num, current_pattern = [])
    return current_pattern.reverse if parent.nil? && item.nil?
    decrease_support(decrease_num) if trim
    parent.conditional_pattern(trim, decrease_num, current_pattern << ItemNode.new(item, decrease_num))
  end

  def prune
    parent.remove_child(self)
  end

  def remove_child(node)
    children.each do |child|
      self.child = nil if child.item == node.item
    end
    children.compact!
  end

  def print_node(depth = 1)
    print "\t- #{item_node.item} : #{item_node.support} -"
    if children
      i = 0
      children.each do |child|
        child.print_node(depth + 1)
        i += 1
        if i < children.length
          print "\n #{depth}"
          0..depth.times { print "\t\t\t\t" }
          print '|'
        else
          puts ''
        end
      end
    end
  end
end
