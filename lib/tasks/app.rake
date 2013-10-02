namespace :app do
  desc "scraping SFCardFan Station Code"
  task parse_stations: :environment do
    require 'open-uri'
    index_url = "http://www.denno.net/SFCardFan/index.php"
    index = Nokogiri::HTML(open(index_url))
    max_page = index.xpath('//table[caption="登録済駅コード一覧"]//a[@title="last page"]')[0].text.scan(/\d+/)[0].to_i
    page = 1
    stations = []

    puts "max_page: #{max_page}"

    while page <= max_page
      puts "scraping to page #{page}"
      doc = Nokogiri::HTML(open(index_url + "?pageID=#{page}"))
      lines = doc.xpath('//table[caption="登録済駅コード一覧"]/tr')
      lines.shift # skip page line
      lines.shift # skip header line
      lines.each do |l|
        a = l.children.map(&:text)
        stations << Station.new(area_code: a[0],
                    line_code: a[1],
                    station_code: a[2],
                    area_name: a[3],
                    line_name: a[4],
                    station_name: a[5])
      end
      page += 1
    end
    Station.import(stations)
  end
end
