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
    expect(tree.header_table.size).to be(tree.dataset.order_item_list.size)
    (tree.header_table.first.item == 'a').should be(true)
   end  
  end
  describe '#grow_tree' do
    before do
      dataset = prepare_dataset
      @tree = FPTree.new(dataset)    
    end
    it "should add transactions from the dataset to the tree" do
      frequent_heads = ['a', 'c','f']
      @tree.grow_tree      
      @tree.root.children.size.should be(frequent_heads.size)
      @tree.root.children.each{|child| (frequent_heads.include?(child.item)).should be(true)}
      
    end
    it "should set each children's parent" do      
      @tree.grow_tree      
      @tree.root.children.each do |child|
        expect(child.parent).to eq(@tree.root)
      end

    end

    it "should add links to the header table" do
      @tree.grow_tree
      link_depths = {'a' => 1, 'b' => 1, 'c' => 2, 'f' => 2}      
      @tree.header_table.each do |header|
        expect(header.support).to be(link_depths[header.item])
      end 
    end
  end 

  describe "#conditional_pattern_base" do
    before do
      dataset = prepare_dataset
      @tree = FPTree.new(dataset)    
      @tree.grow_tree
    end
    it "should return count and patterns of each link" do
      collect_item = @tree.header_table.reverse.first      
      item_base = @tree.conditional_pattern_base(collect_item.link)
      first_pattern = [1,'f']
      second_pattern = [1, 'a,f']
      expect(item_base.size).to be(2)
      (first_pattern == item_base[0]).should be(true)
      (second_pattern == item_base[1]).should be(true)
    end
  end 
    
end
