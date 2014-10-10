#This class will represent a dataset, something that keeps track of
# frequent items and their supports.
# This class will start with a raw transaction list
# This class will then count the frequency an item appears in each transaction of the transaction list
# This class will maintain an ordered list of frequent items
# This class will trim items that do not meet the support
# This class will create a balanced transaction list.
#   - for each transaction
#     - order transaction items based on frequency
class DataSet
  attr_accessor :raw_transactions, :item_list, :support

  #Assume that raw_transactions is an array of arrays of strings, support is a fixnum(int)
  def initialize(raw_transactions, support = 0)
    if(raw_transactions.class != Array || support.class != Fixnum)
      raise TypeError
    end
    @raw_transactions = raw_transactions
    @support = support
    @item_list = []
  end

  def add_and_support
    current_prefix = []
    self.raw_transactions.each do |transaction|
      transaction.each do |item|
        if found_index = search_item_list(item)
          current_prefix << item
          self.item_list[found_index].increase_support
        else
          new_item = ItemNode.new(item.strip.downcase, 1)
          if current_prefix.empty?
            self.item_list << new_item
          else
            previous_item = current_prefix.last
            insert_index = search_item_list(previous_item)
            self.item_list.insert(insert_index + 1, new_item)
          end
        end
      end
      current_prefix = []
    end
  end
  def search_item_list(candidate_item)
    self.item_list.find_index{|item_node| item_node.item == candidate_item}
  end
  def trim
    self.item_list.delete_if{|item_node| item_node.support < self.support}
  end
  #returns an array of hashes, each has is the item and support
  def ordered_item_list(candidate_items = nil)
    ordered_array = []
    self.item_list.each do |item_node|
      if ordered_array[item_node.support]
        ordered_array[item_node.support] << item_node.item
      else
        ordered_array[item_node.support] = [item_node.item]
      end
    end
    local_ordered_items =  ordered_array.compact.reverse.flatten

    if candidate_items
      ordered_items = []
      candidate_items.each do |c_item|
        if local_ordered_items.include?(c_item)
          ordered_items << c_item
        end
      end
    end

    ordered_items || local_ordered_items
  end

  def order_transaction_items(candidate_items = nil)
    reduced_transaction_list = []
    frequent_items = self.ordered_item_list(candidate_items)
    #puts "#{frequent_items}"
    self.raw_transactions.each do |transaction|
      reduced_transaction = []
      frequent_items.each do |item|
        reduced_transaction << item if transaction.include?(item)
      end
      reduced_transaction_list << reduced_transaction unless reduced_transaction.empty?
    end
    reduced_transaction_list
  end

end
