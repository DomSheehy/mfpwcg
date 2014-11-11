describe 'Rubocop' do
  it 'should not get worse' do
    rubocop = IO.readlines('rubocop.log')
    puts rubocop.join('')
    rubocop.delete("\n")
    last_line = rubocop.last
    offences = last_line[/^\d+  Total$/].to_i
    expect(offences).to be <= 22
  end
end
