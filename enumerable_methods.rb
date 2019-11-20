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
    sum = 0
    i = 0
    raise ArgumentError, "wrong number of arguments (given 3, expected 0..2)" if args.length > 2

    if (args[1].is_a?(Symbol) && args[0].is_a?(Integer))
      sum = args[0]
      my_each { |item| sum = sum.method(args[1]).call(item) }
    elsif (args.length == 0 && block_given?)
      my_each do |item|
        (i == 0) ? sum += item : sum = yield(sum, item) 
        i += 1
      end
    elsif (args[0].is_a?(Integer) && block_given?)
      sum = args[0]
      my_each { |item| sum = yield(sum, item) }
    elsif (args.length == 1 && block_given? == false)
      if args[0].class != Symbol && args[0].class != String
        raise TypeError, "#{args[0]} (is neither a symbol nor a string)"
      elsif args[0].is_a?(Symbol)
        my_each do |item|
          (i == 0) ? sum += item : sum = sum.method(args[0]).call(item)
          i += 1
        end
      elsif args[0].is_a?(String)
        operators = [:+, :-, :*, :/, :==, :=~]
        if operators.my_any? { |o| o == args[0].to_sym }
          my_each do |item|
            (i == 0) ? sum += item : sum = sum.method(args[0].to_sym).call(item)
            i += 1
          end
        else
          raise NoMethodError, "undefined method '#{args[0]}' for 1:Integer"
        end
      end
    end
    sum
  end
end

def multiply_els(arr)
  arr.my_inject { |product, item| product + item }
end
