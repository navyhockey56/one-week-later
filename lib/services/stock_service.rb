module Services
  require 'net/http'

  Address = "https://api.iextrading.com/1.0"

  def self.stock_service
    Services::StockService.instance
  end

  def get(context_path = '', params={})
    uri = URI(Address + context_path)
    uri.query = URI.encode_www_form(params)
    puts uri
    Net::HTTP.get_response(uri)
  end

  def get_with_filers(context_path, filters=[])
    get(context_path, {filter: filters})
  end

  def response_body(response)
    eval(response.body.gsub('null', 'nil'))
  end

  class StockService
    require 'singleton'
    include Services
    include Singleton

    # Creates a new Stock for the given symbol
    # @param [String] symbol - The stock's symbol
    def stock(symbol)
      Stock.new(stock_quote(symbol))
    end

    # Retrieves the quote for the stock with the given symbol
    def stock_quote(symbol)
      puts "Looking up quote: #{symbol}"
      response = get("/stock/#{symbol}/quote")

      raise "Bad Request" unless response.is_a? Net::HTTPSuccess
      puts "Lookup of quote was successful: #{symbol}"
      
      response_body(response)
    end

    # Retrieves the company info for the stock with the given symbol
    def company_info(symbol)
      puts "Looking up company info: #{symbol}"
      response = get("/stock/#{symbol}/company")

      raise "Bad Request" unless response.is_a? Net::HTTPSuccess
      puts "Lookup of company info was successful: #{symbol}"

      response_body(response)
    end

    # Retrieves information on crypto currencies
    def crypto_info
      puts "Looking up crypto info"
      response = get("/stock/market/crypto")

      raise "Bad Request" unless response.is_a? Net::HTTPSuccess
      puts "Lookup of information on crypto was successful"
      
      response_body(response)
    end

    # Retrieves dividend history for the stock with the given symbol.
    # @param [String] symbol
    # @param [String] time_frame - One of ['5y', '2y', '1y', 'ytd', '6m', '3m', '1m']
    def dividends(symbol, time_frame)
      valid_times = ['5y', '2y', '1y', 'ytd', '6m', '3m', '1m']
      raise "Invalid time frame" unless valid_times.include? time_frame

      puts "Looking up dividends: #{symbol}"
      response = get("/stock/#{symbol}/dividends/#{time_frame}")

      raise "Bad Request" unless response.is_a? Net::HTTPSuccess
      puts "Lookup of dividends was successful"

      response_body(response)
    end

    # Retrieves price info over the given time_frame
    # @param [String] symbol
    # @param [String] time_frame - One of [nil, '5y', '2y', '1y', 'ytd', '6m', '3m', '1m', '1d', 'dynamic']
    def chart(symbol, time_frame=nil)
      valid_times = [nil, '5y', '2y', '1y', 'ytd', '6m', '3m', '1m', '1d', 'dynamic']
      raise "Invalid time frame" unless valid_times.include? time_frame

      puts "Looking up (#{time_frame}) chart: #{symbol}"
      response = get("/stock/#{symbol}/chart#{time_frame ? '/' + time_frame : ''}")

      raise "Bad Request" unless response.is_a? Net::HTTPSuccess
      puts "Lookup of the chart was successful"

      response_body(response)
    end

    def book(symbol)
      puts "Looking up book: #{symbol}"
      response = get("/stock/#{symbol}/book")

      raise "Bad Request" unless response.is_a? Net::HTTPSuccess
      puts "Lookup of book was successful"

      response_body(response)
    end

    def earnings(symbol)
      puts "Looking up earnings: #{symbol}"
      response = get("/stock/#{symbol}/earnings")

      raise "Bad Request" unless response.is_a? Net::HTTPSuccess
      puts "Lookup of earnings was successful"

      response_body(response)
    end

    def sector_performance
      puts "Looking up sector performace"
      response = get("/stock/market/sector-performance")

      raise "Bad Request" unless response.is_a? Net::HTTPSuccess
      puts "Lookup of sector performance was successful"

      response_body(response)
    end

    def market_list(list_name)
      raise 'Invalid list name' unless 
        ['mostactive', 'gainers', 'losers', 'iexvolume', 'iexpercent', 'infocus'].include? list_name
      
      puts "Looking up list #{list_name}"
      response = get("/stock/market/list/#{list_name}")
      
      raise "Bad Request" unless response.is_a? Net::HTTPSuccess
      puts "Lookup of list was successful"

      response_body(response)
    end


=begin

    This endpoint is bad. Should check it in the future for a fix.

    # @param [String] date_stamp - yyyyMMdd format
    def chart_date(symbol, date_stamp)
      puts "Looking up (#{date_stamp}) chart: #{symbol}"
      response = get("/stock/#{symbol}/chart/date/#{date_stamp}")

      raise "Bad Request" unless response.is_a? Net::HTTPSuccess
      puts "Lookup of the chart was successful"

      response_body(response)
    end
=end

  end

end