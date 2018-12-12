module Option

  attr_reader :owner, :stock, :strike_price, :market_value

  def initialize(owner: true, contract_price:, strike_price: nil, stock: nil, market_value: nil)
    @market_value = market_value
    @owner = owner
    @strike_price = strike_price
    @stock = stock
    @contract_price = contract_price
  end

  def value 
    raise "Illegal Access"
  end

  def to_s
    "#{self.class.to_s.gsub('Option::', '')}\n" +
    "Value: #{value}, Strike Price: #{@strike_price}, Stock: {#{@stock}}"
  end

  class Call 
    include Option

    def value 
      if @owner 
        @stock.value > @strike_price ? 
          ((@stock.value - @strike_price - @contract_price) * 100).round(2) : 0
      else
        @strike_price > @stock.value ? 
          @contract_price * 100 : 
          (100 * (@strike_price + @contract_price - @stock.value)).round(2)
      end
    end

  end

  class Put
    include Option
    
  end

end
