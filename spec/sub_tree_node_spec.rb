require 'spec_helper'

describe SubTreeNode do
  describe "#create" do
    it 'should create a new node' do
      node = SubTreeNode.new('cats', 0)      
      expect(node.item).to eq("cats")
      node = SubTreeNode.new('cats', 0, SubTreeNode.new('cats',0,nil,nil),SubTreeNode.new('dogs',0,nil,nil))
      expect(node.parent.item).to eq("cats")
      expect(node.link.item).to eq("dogs")
    end
    it 'should raise an error if the data types are wrong' do
      begin
        node = SubTreeNode.new(0, 'cats')
      rescue => e
        expect(e.class).to eq(TypeError)
      end
    end
    it 'should raise an error if the the node isnt a node' do
      begin
        node = SubTreeNode.new('cats', 0, 'dog', SubTreeNode.new('cats',0,nil,nil))
      rescue => e
        expect(e.class).to eq(TypeError)
      end
    end
    it 'should raise an error if the the link isnt a link' do
      begin
        node = SubTreeNode.new('cats', 0, SubTreeNode.new('cats',0,nil,nil), 'doge' )
      rescue => e
        expect(e.class).to eq(TypeError)
      end
    end     
  end  
  describe "#increase_support" do
    it 'should increase the support by one' do
      node = SubTreeNode.new('cats', 0)
      expect(node.support).to be(0)
      node.increase_support
      expect(node.support).to be(1)
    end
  end

  describe "#add_child" do
    before do
      @node = SubTreeNode.new('cats', 0)
    end
    it 'should add a child to the node' do      
      @node.add_child('a')
      (@node.children.first.item == 'a').should be(true)
      (@node.children.first.support == 1).should be(true)
    end
    it 'should detect a child and raise the support' do
      2.times do 
        @node.add_child('a')
      end
      (@node.children.first.support == 2).should be(true)
    end    
    it 'should add a second child' do
      children = ['a', 'b']
      children.each do |item|
        @node.add_child(item)
      end
      @node.children.each do | child|
        (children.include?(child.item)).should be(true)
      end 
    end
  end
  describe "#conditional_pattern" do
    before do
      @root = SubTreeNode.new(nil, 0)
      @node = SubTreeNode.new('a', 1)
      @child1 = SubTreeNode.new('b', 1)
      @child2 = SubTreeNode.new('c', 1)
      @root.children = [@node]
      @node.children = [@child1]
      @node.parent = @root
      @child1.parent = @node
      @child2.parent = @child1
      @child1.children = [@child2]
    end
    it 'should give parents up to root' do
      pattern = @child2.conditional_pattern
      expect(pattern).to eq('a,b,c')
    end
  end

end
