# An FPTree creates a tree structure of ordered frequent item lists.
## The Header Table is an array of links. Each link corresponds to an item in the tree.
### Eeach link will first link the the first occurance of the item in the tree. All of the occurances of that one item
### will be referenced and connected by the Header Table
## The Root is the root of the tree, it is an instanc of a Sub Tree Node
## The Dataset is the primary dataset of transactions
## Candidate Items is a list of frequent items in the Dataset. These are ordered based on frequency
class FPTree
  attr_accessor :header_table, :root, :dataset, :candidate_items

  def initialize(dataset, candidate_items = nil)
    fail TypeError if dataset && dataset.class != DataSet

    @dataset, @candidate_items = FPTree.prepare_dataset(dataset, candidate_items)
    @root = SubTreeNode.new(ItemNode.new(nil, 0))
    @header_table = create_header_table(@dataset.ordered_item_list(@candidate_items))
  end

  # Prepairs a new dataset for tree creation
  def self.prepare_dataset(dataset, candidate_items = nil)
    dataset.add_and_support
    dataset.trim
    candidate_items = dataset.ordered_item_list if candidate_items.nil?
    [dataset, candidate_items]
  end
  # Sets up the table header, most frequent first!
  def create_header_table(frequent_items)
    headers = []
    frequent_items.each do | item_node |
      headers << SubTreeNode.new(ItemNode.new(item_node, 0))
    end
    self.header_table = headers
  end
  # Grows the tree one transaction at a time
  def grow_tree
    dataset.order_transaction_items(candidate_items).each do |transaction|
      add_transaction(transaction, root)
    end
    calculate_header_support
  end
  # Add a transaction to the fp tree (this is done recursively each item is it's predecessor's child)
  def add_transaction(transaction, parent)
    return if transaction.empty?
    added_child = parent.add_child(transaction.shift) # linked both to a parent and a child (root is the top)
    add_link(added_child) # for the header table
    add_transaction(transaction, added_child)
  end

  # Add a link for the header table
  def add_link(child)
    if child.support == 1 # leaf in a new branch
      header_table.each do |header|
        return header.add_link(child) if header.item == child.item
      end
    end
  end

  # How many of this item do i have in the dataset
  def calculate_header_support
    header_table.each do |header|
      header.support = header.link.item_support
    end
  end

  # A conditional pattern is a group of frequent transactions related to the item (current link)
  def conditional_pattern_base(trim, current_link, current_pattern_base = [])
    if current_link.nil?
      calculate_header_support if trim
      return current_pattern_base
    end
    current_pattern_base << current_link.parent.conditional_pattern(trim, current_link.support)
    conditional_pattern_base(trim, current_link.link, current_pattern_base)
  end

  def single_path?
    if header_table.size > 0
      header_table.each do |header|
        return false if header.link_depth != 1
      end
      true
    end
  end

  # The fp growth harvests the tree for frequent patterns. It creates conditional
  # trees based on the items conditional patterns
  def self.fp_growth(tree, pattern = '')
    frequent_patterns = []
    if tree.single_path?
      link = tree.header_table.reverse.first.link # the least frequent item
      single_pattern = link.parent.conditional_pattern(true,
                                                       tree.dataset.support,
                                                       [ItemNode.new(link.item, link.support)])

      frequent_patterns << single_pattern.map(&:item).join('') + pattern
    else
      tree.header_table.reverse.each do |header| # the least frequent item
        frequent_patterns << header.item + pattern
        conditional_patterns = tree.conditional_pattern_base(false, header.link)
        conditional_dataset = DataSet.new(DataSet.transactions_from_pattern_base(conditional_patterns),
                                          tree.dataset.support)

        conditional_tree = FPTree.new(conditional_dataset, tree.candidate_items)
        conditional_tree.grow_tree
        if conditional_tree.header_table.size > 0
          frequent_patterns << FPTree.fp_growth(conditional_tree, header.item + pattern)
        end
      end
    end
    frequent_patterns.flatten.uniq
  end
  # print the tree. (doesn't show the links) Looks like :
  # - root : 2 -
  #   - f : 4 - - c : 3 - - a : 3 - - m : 2 - - p : 2 -

  #  3                        | - b : 1 - - m : 1 - (parent is a)

  #  1        | - b : 1 - (parent is f)
  #   - c : 1 - - b : 1 - - p : 1 -
  def print_tree
    if root.children
      puts " - root : #{root.children.length} - "
      root.children.each(&:print_node)
      puts ''
    end
  end
end
