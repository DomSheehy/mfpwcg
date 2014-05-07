require 'spec_helper'
require 'data_tools'

describe DataTools do
  describe 'token file' do
    it "should parse a simple text file into array of strings" do
      data = DataTools::token_file(File.dirname(__FILE__)+'/../data/parse_test.txt', ',')
      expect(data).to eq([["a","b"], ["c", "d"], ["e", "f"]])
    end
  end  
  
end