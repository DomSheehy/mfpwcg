require 'spec_helper'

describe DataTools do
  describe 'token file' do
    it "should parse a simple text file into array of strings" do
      data = DataTools::token_file(File.dirname(__FILE__)+'/../data/parse_test.txt', ',')
      expect(data).to eq([["a","b"], ["c", "d"], ["e", "f"], ["a","b","c"], ["a","f"], ["a","b"]])
    end
  end  
  
end
