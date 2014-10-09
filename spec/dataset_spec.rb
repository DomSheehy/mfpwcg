require 'spec_helper'

describe DataSet do
  describe '#create' do
    it 'should create a new dataset' do
      raw_parsed_data = DataTools::token_file(File.dirname(__FILE__)+'/../data/parse_test.txt', ',')
      ds_support = 2
      dataset = DataSet.new(raw_parsed_data, 2)
      expect(dataset.raw_transactions).to eq(raw_parsed_data)
      expect(dataset.support).to eq(ds_support)
    end

    it "should throw an error if support isnt a number or transactions arent in an array" do
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
    it "should add raw data to the data set's item nodes" do
      dataset = setup_dataset
      dataset.add_and_support
      expect(dataset.item_list['a']).to eq(3)
     end
  end

  describe '#trim' do
    it "should trim items without the minimum support" do
      dataset = setup_dataset
      dataset.add_and_support
      expect(dataset.item_list['a']).to eq(3)
      expect(dataset.item_list['e']).to eq(1)
      dataset.trim
      expect(dataset.item_list['a']).to eq(3)
      expect(dataset.item_list['e']).to eq(nil)
     end
  end

  describe '#ordered_item_list' do
    it "should return an ordered item list" do
      dataset = setup_dataset
      dataset.add_and_support
      dataset.trim
      list = dataset.ordered_item_list
      i = 0
      test_list = ["f", "c", "a", "b", "m", "p"]
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
        [["f", "c", "a", "m", "p"],
         ["f", "c", "a", "b", "m"],
         ["f", "b"],
         ["c", "b", "p"],
         ["f", "c", "a", "m", "p"]])
    end
  end
end
