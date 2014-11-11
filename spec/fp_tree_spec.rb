require 'spec_helper'

describe FPTree do
  describe '#create' do
    it 'should initialize the header table' do
      dataset = setup_dataset
      tree = FPTree.new(dataset)
      tree.header_table.should_not be_nil
    end
  end
  describe '#create_header_table' do
   it 'should take a frequent list and init the table' do
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
    it 'should add transactions from the dataset to the tree' do
      frequent_heads = ['f','c', 'a', 'b','m','p']
      @tree.grow_tree
      @tree.root.children.size.should be(2)
      @tree.root.children.each{|child| (frequent_heads.include?(child.item)).should be(true)}

    end
    it 'should set each children\'s parent' do
      @tree.grow_tree
      @tree.root.children.each do |child|
        expect(child.parent).to eq(@tree.root)
      end

    end

    it 'should add links to the header table' do
      @tree.grow_tree
      link_support = {'f' => 4, 'c' => 4, 'a' => 3, 'b' => 3, 'm' => 3, 'p' => 3}
      @tree.header_table.each do |header|
        expect(header.support).to be(link_support[header.item])
      end
    end
  end

  describe '#conditional_pattern_base' do
    before do
      dataset = setup_dataset
      @tree = FPTree.new(dataset)
      @tree.grow_tree
      collect_item = @tree.header_table.reverse.first
      @item_base = @tree.conditional_pattern_base(true,collect_item.link)
      @first_pattern = [ItemNode.new('f', 2),ItemNode.new('c', 2),ItemNode.new('a', 2),ItemNode.new('m', 2)]
      @second_pattern = [ItemNode.new('c', 1),ItemNode.new('b', 1)]
      @new_conditional = ItemNode.new('c', 3)
    end
    it 'should return count and patterns of each link' do

      expect(@item_base.size).to be(2)
      (@first_pattern).should eq(@item_base[0])
      (@second_pattern).should eq(@item_base[1])
    end
  end

  describe '#fp_growth' do
    before do
      dataset = setup_dataset
      @tree = FPTree.new(dataset)
      @tree.grow_tree
      @collect_item = @tree.header_table.reverse.first #should be 'p' the last item
      @item_base = @tree.conditional_pattern_base(false,@collect_item.link)

    end
    it 'should return some frequent patterns' do
      new_data = DataSet.new(DataSet.transactions_from_pattern_base(@item_base), @tree.dataset.support)
      conditional_tree = FPTree.new(new_data)
      conditional_tree.grow_tree
      apatterns = FPTree.fp_growth(conditional_tree, @collect_item.item) #should just be 'c'
      (apatterns).should eq(['cp'])

    end
    it 'Should return all the patterns' do
      puts "#{FPTree.fp_growth(@tree)}"
    end
    it 'should draw the tree' do
      @tree.print_tree
    end
  end

end
