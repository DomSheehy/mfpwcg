#This class will represent a dataset, something that keeps track of
# frequent items and their supports. 
class DataSet
  attr_accessor :raw_transactions, :item_nodes, :balanced_transactions, :support 

  def initialize(raw_transactions, support = 0)
    if(raw_transactions.class != Array || support.class != Fixnum)
      raise TypeError
    end
    @raw_transactions = raw_transactions
    @support = support
    item_nodes = {}
  end

  def scan_and_raise_support

  end


end