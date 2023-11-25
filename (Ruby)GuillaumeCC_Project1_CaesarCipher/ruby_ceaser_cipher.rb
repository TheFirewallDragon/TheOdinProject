def encrypt_caesar_cipher(text_to_encrypt, shift_count)
    text_to_encrypt.each_char do |character|
        if character.match(/[a-zA-Z]/)
            shift = (character.downcase == character)? "a": "A"
            encrypted_char = (((character.ord - shift.ord + shift_count)  %26) + shift.ord).chr
            puts "A character is #{character} and encrypted is #{encrypted_char}"
        end
    end 
end

puts "Enter the string to convert: "
string_to_convert = gets.chomp

puts "Enter how many places you want to increment: "
places_count = gets.chomp
encrypt_caesar_cipher(string_to_convert, places_count.to_i)
  

