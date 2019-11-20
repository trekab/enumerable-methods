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

  def my_select
    return self.to_enum(:my_select) unless block_given?
    selected_items = []
    self.my_each { |item| selected_items << item if yield(item) }
    selected_items
  end

  def my_all?(test=nil)
    matching_items = []

    if (test != nil)
      self.my_each do |item|
        matching_items << item if test === item 
        break if (test === item) == false
      end
    elsif (block_given? == false)
      self.my_each do |item|
        matching_items << item if item
        break if item == false
      end
    else
      self.my_each do |item|
        matching_items << item if yield(item)
        break if yield(item) == false
      end
    end
    (self.length > matching_items.length) ? false : true
  end


end