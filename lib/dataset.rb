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
    @item_list = {}
  end

  def add_and_support
    self.raw_transactions.each do |transaction|
      transaction.each do |item|
        if self.item_list[item.strip.downcase]
          self.item_list[item.strip.downcase] += 1
        else
          self.item_list[item.strip.downcase] = 1
        end
      end
    end
  end

  def trim
    self.item_list.delete_if{|item, support| support < self.support}
  end
  #returns an array of hashes, each has is the item and support
  def ordered_item_list(candidate_items = nil)
    ordered_array = []
    self.item_list.each do |item, val|
      if ordered_array[val]
        ordered_array[val] << item
      else
        ordered_array[val] = [item]
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
