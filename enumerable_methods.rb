# frozen_string_literal: true

module Enumerable

  def my_each
    return self.to_enum unless block_given?
    i = 0
    while self[i]
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return self.to_enum(:my_each_with_index) unless block_given?
    self.my_each { |e| yield(index(e), e) }
    self
  end

  def my_select
    return self.to_enum(:my_select) unless block_given?
    selected_items = []
    self.my_each { |item| selected_items << item if yield(item) }
    selected_items
  end

  def my_all?
    self.my_each { |item| return false unless yield(item) }
    true
  end

  def my_any?
    self.my_each { |item| return true if yield(item) }
    false
  end

  def my_none?
    return true unless block_given?
    self.my_each { |item| return true unless yield(item) }
    false
  end

end

arr = [4, 'hey', 2, 'Hi there!']

p arr.my_none?{|e| e==99}
