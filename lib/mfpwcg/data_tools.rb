
# this module should use tools for data parsing uses
module DataTools
  def self.token_file(file_path, delimiter)
    dataset = []
    IO.foreach(file_path) do |line|
      dataset << line.strip.split(delimiter)
    end
    dataset
  end
end
