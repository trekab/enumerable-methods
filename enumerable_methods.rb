# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while self[i]
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    my_each { |e| yield(e, index(e)) }
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    selected_items = []
    my_each { |item| selected_items << item if yield(item) }
    selected_items
  end

  def my_all?(*arg)
    return self.grep(arg.first).length == self.size unless arg.empty?

    my_each { |i| return false unless yield(i) } if block_given?
    my_each { |i| return false unless i } unless block_given?
    true
  end

  def my_any?(args = nil)
    my_each { |num| return true if yield(num) }
    return true unless args.nil?
    false
  end

  def my_none?
    return true unless block_given?

    my_each { |item| return true unless yield(item) }
    false
  end

  def my_count(arg = nil)
    matching_items = []

    if !arg.nil?
      my_each { |item| matching_items << item if arg == item }
    elsif block_given? == false
      my_each { |item| matching_items << item }
    else
      my_each { |item| matching_items << item if yield(item) }
    end
    matching_items.length
  end

  def my_map(&proc)
    return to_enum(:my_map) unless block_given?

    mapped_array = []
    my_each { |item| mapped_array << proc.call(item) }
    mapped_array
  end

  def my_inject(*args)
    my_arr = to_a
    if block_given?
      my_arr = dup.to_a
      result = args[0].nil? ? my_arr[0] : args[0]
      my_arr.shift if args[0].nil?
      my_arr.my_each { |number| result = yield(result, number) }
    else
      my_arr = to_a
      if args[1].nil?
        symbol = args[0]
        result = my_arr[0]
        my_arr[1..-1].my_each { |i| result = result.send(symbol, i) }
      else
        symbol = args[1]
        result = args[0]
        my_arr.my_each { |i| result = result.send(symbol, i) }
      end
    end
    result
  end
end

def multiply_els(arr)
  arr.my_inject { |acc, item| acc * item }
end
