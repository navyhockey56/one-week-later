module Graphs
  require 'gruff'

  # @param [Hash] data - category => [{x=>val, y=>val},...] 
  def self.scatter_plot(data:{}, size:800, title:'John Doe')

    g = Gruff::Scatter.new(size) 
    g.title = title if title
    data.each do |key, value| 
      x,y = [],[]
      value.each do |val| 
        x << val[:x] 
        y << val[:y]
      end
      g.data(key, x, y)
    end

    file_name = "/Users/willdengler/jibe/stock_stuff/images/scatter_#{Time.now.to_i}.png"
    g.write(file_name)

    `open #{file_name}`
    return file_name
  end

  def self.line(data:{}, size:800, title:'John Doe')
    g = Gruff::Line.new(size)
    g.title = title if title
    data.each do |key,value|
      g.data(key, value)
    end
    file_name = "/Users/willdengler/jibe/stock_stuff/images/line_#{Time.now.to_i}.png"
    g.write(file_name)

    `open #{file_name}`
    return file_name
  end

end