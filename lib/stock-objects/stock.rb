class Stock
  def initialize(quote_or_symbol)
    @quote = quote_or_symbol if quote_or_symbol.class == Hash
    @quote ||= Services.stock_service.stock_quote(quote_or_symbol)

    @dividend_history = {}
    @charts = {}
  end

  def [](attribute)
    @quote[attribute]
  end

  def as_date(attribute)
    Tools.as_date(@quote[attribute])
  end

  def symbol
    @quote[:symbol]
  end

  def value
    @quote[:latestPrice]
  end

  def company
    @quote[:companyName]
  end

  def company_info
    @quote[:company_info] ||= Services.stock_service.company_info(symbol)
  end

  # Retrieves dividend info over the past five years
  # @param [String] time_frame - One of ['5y', '2y', '1y', 'ytd', '6m', '3m', '1m']
  def dividends(time_frame = '5y', force_update = false)
    values = @dividend_history[time_frame] unless force_update
    values ||= Services.stock_service.dividends(symbol, time_frame)
    @dividend_history[time_frame] = values
  end

  def chart(time_frame = nil)
    if time_frame
      @charts[time_frame] ||= Services.stock_service.chart(symbol, time_frame)
    else
      @charts['nil'] ||= Services.stock_service.chart(symbol, time_frame)
    end
  end

  def chart_attribute(attribute, time_frame = nil)
    ch = chart(time_frame)
    ch.map { |i| i[attribute] }
  end

  def scatter_attr(time_frame = nil, *attributes)
    plot = {}
    attributes.each do |attr|
      plot[attr] = Tools.map_to_xy(chart_attribute(attr, time_frame))
    end
    Graphs.scatter_plot(data: plot, title: "#{symbol} #{time_frame}")
  end

  def line_attr(time_frame = nil, *attributes)
    plot = {}
    attributes.each do |attr|
      plot[attr] = chart_attribute(attr, time_frame)
    end
    Graphs.line(data: plot, title: symbol)
  end

  def line_diff_percent_change(time_frame = nil, *attributes)
    plot = {}
    attributes.each do |attr|
      plot[attr] = Tools.diff_percent_change(chart_attribute(attr, time_frame))
    end
    Graphs.line(data: plot, title: symbol)
  end

  def line_percent_change(time_frame = nil, *attributes)
    plot = {}
    attributes.each do |attr|
      d = chart_attribute(attr, time_frame)
      plot[attr] = Tools.percent_change_from(d.first, d)
    end
    Graphs.line(data: plot, title: symbol)
  end

  def to_s
    "#{company} (#{symbol}) - #{value}"
  end

  def self.stocks_line_percent_change(time_frame = nil, stocks = [], *attributes)
    plot = {}
    stocks.each do |stock|
      attributes.each do |attr|
        d = stock.chart_attribute(attr, time_frame)
        plot[(stock.symbol.downcase + ' - ' + attr.to_s).to_sym] = Tools.percent_change_from(d.first, d)
      end
    end
    Graphs.line(data: plot, title: stocks.map(&:symbol).join(', '))
  end
end
