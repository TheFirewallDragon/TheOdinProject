def merge_sort(arr)
  return arr if arr.length < 2

  middle = arr.length/2
  left = arr[0...middle]
  right = arr[middle..-1]
  merge(merge_sort(left), merge_sort(right))
end

def merge(left, right)
  result = []
  until left.length == 0 || right.length == 0
    if left[0] < right[0]
      result << left.shift
    else
      result << right.shift
    end
  end
  result + left + right
end

merge_sort([20, 5, 1, 3, 78, 2, 53, 19, 4])
