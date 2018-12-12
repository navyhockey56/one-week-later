module Tools

  def self.difference(list, rounding=2)
    diff = []
    for i in 0..(list.length - 2)
      diff << (list[i + 1] - list[i]).round(rounding)
    end
    diff
  end

  def self.diff_percent_change(list, rounding=4)
    change = []
    diff = difference(list, rounding)
    for i in 0..(diff.length - 1)
      change << (diff[i]/list[i]).round(rounding)
    end
    change
  end

  def self.percent_change_from(from_val, list, rounding=4)
    list.map {|val| ((val - from_val)/from_val).round(rounding)}
  end

  def self.map_to_xy(values)
    i = 0
    values.map {|val| {x: i +=1, y: val}}
  end

end