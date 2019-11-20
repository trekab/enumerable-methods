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

  def my_all?
    return true unless block_given?

    my_each { |item| return false unless yield(item) }
    true
  end

  def my_any?
    return true unless block_given?

    my_each { |item| return true if yield(item) }
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
    init = args.size.positive?
    acc = init ? args[0] : self[0]
    drop(init ? 0 : 1).my_each { |item| acc = yield(acc, item) }
    acc
  end
end

def multiply_els(arr)
  arr.my_inject { |acc, item| acc * item }
end
