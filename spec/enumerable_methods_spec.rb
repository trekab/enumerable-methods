# frozen_string_literal: true

require_relative '../enumerable_methods.rb'

describe(Enumerable) do
  let(:example_array) { [10, 20, 30, 40] }
  let(:example_range) { (1...5) }
  let(:rand_num) { rand(5) }
  let(:test_block) { proc { |element| element.even? } }

  describe('#my_each') do
    context('when called with a block') do
      it('returns an array when called on array') do
        expect(example_array.my_each { test_block }).to(eql(example_array.each { test_block }))
      end

      it('returns an range when called on a range') do
        expect(example_range.my_each { test_block }).to(eql(example_range.each { test_block }))
      end
    end

    context('when called without a block') do
      it('returns an array enumerator when called on an array without a block') do
        expect(example_array.my_each.class).to(eql(example_array.each.class))
      end

      it('returns a range enumerator when called on a range without a block') do
        expect(example_range.my_each.class).to(eql(example_range.each.class))
      end
    end
  end

  describe('#my_select') do
    context('when called with a block') do
      it('returns an array of values that yield true when called on array') do
        expect(example_array.my_select { test_block }).to(eql(example_array.select { test_block }))
      end

      it('returns an array of values that yield true when called on a range') do
        expect(example_range.my_select { test_block }).to(eql(example_range.select { test_block }))
      end
    end

    context('when called without a block') do
      it('returns an array enumerator when called on an array without a block') do
        expect(example_array.my_select.class).to(eql(example_array.select.class))
      end

      it('returns a range enumerator when called on a range without a block') do
        expect(example_range.my_select.class).to(eql(example_range.select.class))
      end
    end
  end
end
