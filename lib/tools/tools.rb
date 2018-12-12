module Tools

  def self.difference(list, rounding=2)
    diff = []
    for i in 0..(list.length - 2)
      diff << (list[i + 1] - list[i]).round(rounding)
    end
    diff
  end

  def self.diff_percent_change(list, rounding=4)
    diff = difference(list, rounding)
    (0..(diff.length - 1)).map { |i| (diff[i]/list[i]).round(rounding) }
  end

  def self.percent_change_from(from_val, list, rounding=4)
    list.map {|val| ((val - from_val)/from_val).round(rounding)}
  end

  def self.map_to_xy(values)
    i = 0
    values.map {|val| {x: i +=1, y: val}}
  end

  def self.as_date(milliseconds)
    Time.at(milliseconds / 1000)
  end

end