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
    dataset = setup_dataset
    tree = FPTree.new(dataset)
    expect(tree.header_table.size).to be(tree.dataset.ordered_item_list.size)
    (tree.header_table.first.item == 'f').should be(true)
   end
  end
  describe '#grow_tree' do
    before do
      dataset = setup_dataset
      @tree = FPTree.new(dataset)
    end
    it "should add transactions from the dataset to the tree" do
      frequent_heads = ['f','c', 'a', 'b','m','p']
      @tree.grow_tree
      @tree.root.children.size.should be(2)
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
      link_support = {'f' => 4, 'c' => 4, 'a' => 3, 'b' => 3, 'm' => 3, 'p' => 3}
      @tree.header_table.each do |header|
        expect(header.support).to be(link_support[header.item])
      end
    end
  end

  describe "#conditional_pattern_base" do
    before do
      dataset = setup_dataset
      @tree = FPTree.new(dataset)
      @tree.grow_tree
    end
    it "should return count and patterns of each link" do
      collect_item = @tree.header_table.reverse.first
      item_base = @tree.conditional_pattern_base(true,collect_item.link)
      first_pattern = 'b'
      second_pattern = 'af'
      expect(item_base.size).to be(2)
      (first_pattern == item_base[0]).should be(true)
      (second_pattern == item_base[1]).should be(true)
    end
  end

  describe "#fp_growth" do
    before do
      dataset = setup_dataset
      dataset.support = 2
      @tree = FPTree.new(dataset)
      @tree.grow_tree
    end
    it "should return some frequent patterns" do
      apatterns = FPTree.fp_growth(@tree)

    end
  end

end
