
def substring(main_string, input_dictionary)
    substring_hash = Hash.new
    input_dictionary.each do|value|
        if(main_string.include?(value))
            if (substring_hash.has_key?(value))
                substring_hash[value] = substring_hash[value] + 1
            else
                substring_hash[value] = 1
            end
            
        end
    end
    puts substring_hash
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
substring("Howdy partner, sit down! How's it going?", dictionary)