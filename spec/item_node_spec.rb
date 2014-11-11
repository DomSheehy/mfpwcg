require 'spec_helper'

describe ItemNode do
  describe '#create' do
    it 'should create a new node' do
      node = ItemNode.new('cats', 0)
      expect(node.item).to eq('cats')
    end
    it 'should raise an error if the data types are wrong' do
      begin
        ItemNode.new(0, 'cats')
      rescue => e
        expect(e.class).to eq(TypeError)
      end
    end
  end
  describe '#increase_support' do
    it 'should increase the support by one' do
      node = ItemNode.new('cats', 0)
      expect(node.support).to be(0)
      node.increase_support
      expect(node.support).to be(1)
    end
  end

end
