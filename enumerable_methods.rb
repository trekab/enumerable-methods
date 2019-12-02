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

  def my_all?(test = nil)
    matching_items = []

    if !test.nil?
      my_each do |item|
        matching_items << item if test === item 
        break if (test === item) == false
      end
    elsif !block_given?
      my_each do |item|
        matching_items << item if item
        break if item == false
      end
    else
      my_each do |item|
        matching_items << item if yield(item)
        break if yield(item) == false
      end
    end
    length <= matching_items.length
  end

  def my_any?(test = nil)
    matching_items = []

    if !test.nil?
      my_each do |item|
        matching_items << item if test === item
        break if (test === item) == false
      end
    elsif !block_given?
      my_each do |item|
        matching_items << item if item
        break if item
      end
    else
      my_each do |item|
        if yield(item)
          matching_items << item
          break
        end
      end
    end
    matching_items.length.zero? ? false : true
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
    initial = 0
    i = 0
    raise ArgumentError, 'wrong number of arguments (given 3, expected 0..2)' if args.length > 2

    if args[1].is_a?(Symbol) && args[0].is_a?(Integer)
      initial = args[0]
      my_each { |item| initial = initial.method(args[1]).call(item) }
    elsif args.length.zero? && block_given?
      my_each do |item|
        i.zero? ? initial += element : initial = yield(sum, item)
        i += 1
      end
    elsif args[0].is_a?(Integer) && block_given?
      initial = args[0]
      my_each { |item| initial = yield(initial, item) }
    elsif args.length == 1 && !block_given?
      raise TypeError, "#{args[0]} (is neither a symbol nor a string)" if args[0].class != Symbol && args[0].class != String
        
      if args[0].is_a?(Symbol)
        my_each do |item|
          i.zero? ? initial += item : initial = initial.method(args[0]).call(item)
          i += 1
        end
      elsif args[0].is_a?(String)
          operators = %i[:+ :- :* :/ :== :=~]
          if operators.my_any? { |o| o == args[0].to_sym }
            my_each do |item|
              i.zero? ? initial += item : initial = initial.method(args[0].to_sym).call(item)
              i += 1
            end
          else
            raise NoMethodError, "undefined method '#{args[0]}' for 1:Integer"
          end
      end
    end
    initial
  end
end

def multiply_els(arr)
  arr.my_inject { |acc, item| acc * item }
end
