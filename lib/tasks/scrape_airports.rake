require 'httparty'
require 'nokogiri'
require 'json'

namespace :scrape do
  desc "Scrape airport pages and save extracted info as JSON"
  task airport_json: :environment do
    airports = ["ipoh","nosy-be","port-of-spain-trinidad","wick","milingimbi","wellington","ouarzazate","ndola","nakashibetsu","midland","mianyang","malang","makale","linyi","long-beach","luanda","chisinau","constanta","little-cayman","kahului","guangzhou","fairbanks","fort-leonard-wood","cedar-rapids","singapore","spokane","san-luis","roma","dushanbe","dublin","khasab","hao-island","san-andres-island","timaru","turbat","tacloban","penang","beirut","puerto-madryn","ponce","bucharest","pleiku","ballalae","batam","ostersund","antananarivo","indore","el-paso","huambo","denizli","hafr-al-batin","ouargla","wabush","hokitika","hobart","new-york","napier","myrtle-beach","mayaguez","mangalore","manaus","male","mackay","matsuyama","learmonth","london","kelowna","kyaukpyu","concepcion","kolkata","kristiansund","funafuti-atol","fort-lauderdale","guernsey","tripoli","charlottesville","sangley-point","santa-barbara","rockhampton","durango","daytona-beach","hail","gisborne","pensacola","pune","bucaramanga","bismarck","birmingham","pamplona","oranjemund","ithaca","dakhla","bagan","gunung-sitoli","horn-island","harrisburg","nukus","nagasaki","myitkyina","moncton","monaco","mukah","malmo","maringa","lewiston","luderitz","lafayette","college-station","krabi","campbell-river","kalgoorlie","valencia","vadodara","shijiazhuang","sylhet-osmani","st-vincent","zamboanga","riohacha","recife","ronneby","redding","dominica","hervey-bay","juneau","jorhat","geneva","gibraltar","jackson","tokushima","trat","punta-gorda","baotou","apia","ua-huka","agra","aurangabad","kristianstad","orsta-volda","iringa","wolf-point","solwesi","kowanyama","najaf","coxs-bazar","mc-allen-mission","hailar","noumea","nassau","monroe","muscat","angeles-city","maceio","ljubljana"]
    results = {}

    airports.each do |name|
      url = "https://www.cleartrip.ae/tourism/airports/#{name}-airport.html"
      puts "Fetching #{url}..."

      begin
        response = HTTParty.get(url)
        if response.code == 200
          doc = Nokogiri::HTML(response.body)

          # Extracting content 
  
          first_h2 = doc.at_css('.unique-content.fadingCls h2')
          city_code = first_h2.text[/\((.*)\)/, 1] if first_h2
          h1_title = first_h2.text.split('(')[0].strip if first_h2
          offers = doc.at_css('.offers-bar')&.text.strip
          content_div = doc.at_css('.unique-content.fadingCls')
          content = content_div ? content_div.to_html.strip : nil

          name_value = h1_title

          domestic_flight_schedules = doc.css('.bento-lcard:contains("Top Domestic Routes") ul.list-unstyled li a').map do |a|
            { "text" => a.text.strip, "href" => a["href"] }
          end

          international_flight_schedules = doc.css('.bento-lcard:contains("Top International Routes") ul.list-unstyled li a').map do |a|
            { "text" => a.text.strip, "href" => a["href"] }
          end

          results["#{name}-airport"] = {
            "city_code" => city_code,
            "offers" => offers,
            "h1_title" => h1_title,
            "content" => content,
            "name" => name_value,
            "domestic_flight_schedules" => domestic_flight_schedules,
            "international_flight_schedules" => international_flight_schedules
          }
          puts "Extracted: #{name}-airport"
        else
          puts "Failed to fetch #{name}: Status #{response.code}"
        end
      rescue => e
        puts "Error fetching #{name}: #{e.message}"
      end
    end

    # Save results to a single JSON file
    File.write("result.json", JSON.pretty_generate(results))
    puts "Saved: result.json"
  end
end
