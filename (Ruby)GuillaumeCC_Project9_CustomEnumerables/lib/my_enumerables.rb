module Enumerable
  # Your code goes here
  def my_all?
    if block_given?
      self.my_each do |val|
        return false if yield(val) == false
      end
      true
    end    
  end

  def my_any?
    if block_given?
      self.my_each do |val|
        return true if yield(val) == true
      end
      false
    end
  end

  def my_count
    return size unless block_given?
    count = 0
    my_each { |val| count += 1 if yield(val) } 
    count
  end

  def my_each
    return array if block_given?
  end

  def my_none?
    self.my_each do |val|
      return false unless yield(val) == false
    end
    true
  end

  def my_each_with_index
    index = 0
    self.my_each do |value|
      yield(value, index)
      index += 1
    end
    self
  end

  def my_inject(arg)
    sum = arg
    self.my_each do |val|
      sum = yield(sum, val)
    end
    sum
  end

  def my_map(&block)
    arr = []
    if block_given?
      self.my_each do |val|
        arr << block.call(val)
      end
    arr
    end
  end

  def my_select
    arr = []
      self.my_each do |val|
        arr << val if yield(val)
      end
    arr
  end

end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  # Define my_each here
 include Enumerable

  def my_each
    for item in self
      yield(item)
    end
  end

end