require 'spec_helper'

describe DataTools do
  describe 'token file' do
    it 'should parse a simple text file into array of strings' do
      data = DataTools.token_file(File.dirname(__FILE__) + '/../data/parse_test.txt', ',')
      expect(data).to eq([%w(a b), %w(c d), %w(e f), %w(a b c), %w(a f), %w(a b)])
    end
  end

end
