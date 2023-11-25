def stock_picker(stocks)
    profilt_days = [-1,-1]
    min_max = stocks.minmax()
    puts min_max
    # 0 index will contain minimum value and 1 index will contain it's index
    # similarly 2 index will contain maximum value and 3 index will contain it's index

    stocks.each_with_index do |value, index|
        # puts "value  is #{value } and idex is #{index}"
        if(value == min_max[0] )
            puts "value  is #{value } and idex is #{index}"
            profilt_days[0] = index
        end
        if (value == min_max[1])
            puts "value  is #{value } and idex is #{index}"
            profilt_days[1] = index
        end
    end
    profilt_days
end

p stock_picker([17,3,6,9,15,8,6,1,10])