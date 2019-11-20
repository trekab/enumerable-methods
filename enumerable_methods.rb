module Enumerable

  def my_each
    return self.to_enum unless block_given?
    for item in self
      yield(item)
    end
    self
  end

  def my_each_with_index
    return self.to_enum(:my_each_with_index) unless block_given?
    i = 0
    loop do
      yield(self[i], i)
      i += 1
      break if i > self.length - 1
    end
    self
  end


end