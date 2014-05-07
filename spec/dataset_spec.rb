require 'spec_helper'
require 'dataset'

describe DataSet do 
  describe '#create' do
    it 'should create a new dataset' do
      raw_parsed_data = DataTools::token_file(File.dirname(__FILE__)+'/../data/parse_test.txt', ',')
      dataset = DataSet.new(raw_parsed_data)
      expect(dataset.raw_transactions).to eq(raw_parsed_data)
    end
    it 'should create a new dataset with a support' do
      raw_parsed_data = DataTools::token_file(File.dirname(__FILE__)+'/../data/parse_test.txt', ',')
      ds_support = 2
      dataset = DataSet.new(raw_parsed_data, ds_support)
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
end
