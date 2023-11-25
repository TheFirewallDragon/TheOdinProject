def fibs(n)
  arr = [0,1]
  val = 2
  while val <= n
    next_num = arr[val - 1] + arr[val - 2]
    arr.push(next_num)
    val += 1
  end
    arr
end

def fibs(n)
  arr = [0, 1]
  (2..n).each do |i|
    arr.push(arr[i - 1] + arr[i - 2])
  end
  arr
end

def fibs_rec(n)
  if n == 0
    return [0]
  elsif n == 1
    return [0, 1]
  else
    arr = fibs_rec(n - 1)
    arr.push(arr[n - 1] + arr[n - 2])
    return arr
  end
end