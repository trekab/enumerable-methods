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

  describe('#my_all?') do
    context('when called with only a block') do
      it('returns true if all elements in the array yield true; otherwise, false') do
        expect(example_array.my_all? { test_block }).to(eql(example_array.all?{test_block}))
      end

      it('returns true if all elements in the range yield true; otherwise, false') do
        expect(example_range.my_all? { test_block }).to(eql(example_range.all?{test_block}))
      end
    end

    context('when called with only an argument') do
      it('returns true if the argument equals all the elements in the array; otherwise, false') do
        expect(example_array.my_all?(rand_num)).to(eql(example_array.all?(rand_num)))
      end

      it('returns true if the argument equals all the elements in the range; otherwise, false') do
        expect(example_range.my_all?(rand_num)).to(eql(example_range.all?(rand_num)))
      end
    end

    context('when called with a block and an argument') do
      it('neglects the block and use the argument') do
        expect(example_array.my_all?(rand_num) {test_block}).to(eql(example_array.all?(rand_num) {test_block}))
      end

      it('neglects the block and use the argument') do
        expect(example_range.my_all?(rand_num) {test_block}).to(eql(example_range.all?(rand_num) {test_block}))
      end
    end

    context('when called with no block and no argument') do
      it('returns true if all element of the array are truthy; otherwise, false') do
        expect(example_array.my_all?).to(eql(example_array.all?))
      end

      it('returns true if all element in the range are truthy; otherwise, false') do
        expect(example_range.my_all?).to(eql(example_range.all?))
      end
    end
  end
end
