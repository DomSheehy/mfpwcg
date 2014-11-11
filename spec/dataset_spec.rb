require 'spec_helper'

describe DataSet do
  describe '#create' do
    it 'should create a new dataset' do
      raw_parsed_data = DataTools.token_file(File.dirname(__FILE__) + '/../data/parse_test.txt', ',')
      ds_support = 2
      dataset = DataSet.new(raw_parsed_data, 2)
      expect(dataset.raw_transactions).to eq(raw_parsed_data)
      expect(dataset.support).to eq(ds_support)
    end

    it 'should throw an error if support isnt a number or transactions arent in an array' do
      raw_parsed_data = 'cats'
      ds_support = 'dogs'
      begin
        dataset = DataSet.new(raw_parsed_data, ds_support)
      rescue => e
        expect(e.class).to eq(TypeError)
      end
    end
  end

  describe '#add_and_support' do
    it 'should add raw data to the data set\'s item nodes' do
      dataset = setup_dataset
      dataset.add_and_support
      item_index = dataset.search_item_list('a')
      expect(dataset.item_list[item_index].support).to eq(3)
    end
  end

  describe '#trim' do
    it 'should trim items without the minimum support' do
      dataset = setup_dataset
      dataset.add_and_support
      item_index = dataset.search_item_list('a')
      expect(dataset.item_list[item_index].support).to eq(3)
      item_index = dataset.search_item_list('e')
      expect(dataset.item_list[item_index].support).to eq(1)
      dataset.trim
      item_index = dataset.search_item_list('a')
      expect(dataset.item_list[item_index].support).to eq(3)
      item_index = dataset.search_item_list('e')
      expect(item_index).to be(nil)
    end
  end

  describe '#ordered_item_list' do
    it 'should return an ordered item list' do
      dataset = setup_dataset
      dataset.add_and_support
      dataset.trim
      list = dataset.ordered_item_list
      i = 0
      test_list = %w(f c a b m p)
      list.each do |node|
        (node).should eq(test_list[i])
        i += 1
      end
    end
  end

  describe '#order_transactions' do
    it 'should return transactions with items ordered by their frequency' do
      dataset = setup_dataset
      dataset.add_and_support
      dataset.trim
      expect(dataset.order_transaction_items).to eq(
        [%w(f c a m p),
         %w(f c a b m),
         %w(f b),
         %w(c b p),
         %w(f c a m p)])
    end
  end
  describe '#transactions_from_pattern_base' do
    before do
      first_pattern = [ItemNode.new('f', 2), ItemNode.new('c', 2), ItemNode.new('a', 2), ItemNode.new('m', 2)]
      second_pattern = [ItemNode.new('c', 1), ItemNode.new('b', 1)]
      @conditional_pattern = [first_pattern, second_pattern]
      first_pattern_result = [%w(f c a m), %w(f c a m)]
      second_pattern_result = %w(c b)
      @expected_result = first_pattern_result << second_pattern_result
    end
    it 'will return a set of transactions based on the conditional pattern base' do
      expect(DataSet.transactions_from_pattern_base(@conditional_pattern)).to eq(@expected_result)
    end
  end
end
