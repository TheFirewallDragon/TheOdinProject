require "csv"
require 'google/apis/civicinfo_v2'
require "erb"


def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

def clean_phonenumber(phonenumber)

    phonenumber.gsub!(/[^\d]/,"")

    if phonenumber.length == 10
        phonenumber
    elsif phonenumber.length == 11 && phonenumber[0] == "1"
        phonenumber[1..10]
    else
        "Bad Number!!"
    end
end

def legislators_by_zipcode(zip)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

    begin
        civic_info.representative_info_by_address(
            address: zip,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
        ).officials
    rescue
        'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end  
end

def save_thank_you_letter(id, form_letter)
    
    unless Dir.exist?("output")
        Dir.mkdir("output")
    end

    filename = "output/thanks_#{id}.html"

    File.open(filename, "w") do |file|
        file.puts form_letter
    end
end

puts "Event Manager Initialized!"

contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)

template_letter = File.read("form_letter.erb")
erb_template = ERB.new template_letter

contents.each do |row|
    id = row[0]
    name = row[:first_name]

    zipcode = clean_zipcode(row[:zipcode])

    phonenumber = clean_phonenumber(row[:homephone])

    legislators = legislators_by_zipcode(zipcode)

    form_letter = erb_template.result(binding)

    save_thank_you_letter(id, form_letter)
end

def most_common_reg_day
    contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)
    reg_day_array = []
    contents.each do |row|
      reg_date = row[:regdate]
      reg_day = Time.strptime(reg_date, '%M/%d/%y %k:%M').strftime('%A')
      reg_day_array.push(reg_day)
    end
    most_common_day = reg_day_array.reduce(Hash.new(0)) do |hash, day|
      hash[day] += 1
      hash
    end
    most_common_day.max_by { |_k, v| v }[0]
  end
  
def most_common_hour
    contents = CSV.open("event_attendees.csv", headers: true, header_converters: :symbol)
    reg_hour_array = []
    contents.each do |row|
        reg_date = row[:regdate]
        reg_hour = Time.strptime(reg_date, '%M/%d/%y %k:%M').strftime('%k')
        reg_hour_array.push(reg_hour)
    end
    most_common_hour = reg_hour_array.reduce(Hash.new(0)) do |hash, hour|
        hash[hour] += 1
        hash
    end
    most_common_hour.max_by { |_k, v| v }[0]
end

puts "\nThe most common hour of registration is: #{most_common_hour}:00"

puts "\nThe most common registration day is: #{most_common_reg_day}"