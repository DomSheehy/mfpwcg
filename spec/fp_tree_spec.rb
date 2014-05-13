require 'spec_helper'

describe FPTree do 
  describe '#create' do
    it "should initialize the header table" do
      dataset = setup_dataset    
      tree = FPTree.new(dataset)
      tree.header_table.should_not be_nil
    end    
  end
  describe '#create_header_table' do
   it "should take a frequent list and init the table" do
    dataset = prepare_dataset
    tree = FPTree.new(dataset)    
    (tree.header_table.first.item == 'a').should be(true)
   end  
  end
  describe '#grow_tree' do
    before do
      dataset = prepare_dataset
      @tree = FPTree.new(dataset)    
    end
    it "should add transactions from the dataset to the tree" do
      @tree.grow_tree
      @tree.root.children.size.should be(['a', 'c', 'f'].size)
      (@tree.root.children.first == 'a').should be(true)
    end
  end
    
end
