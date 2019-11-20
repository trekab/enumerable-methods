module Enumerable

  def my_each
    return self.to_enum unless block_given?
    for item in self
      yield(item)
    end
    self
  end


end