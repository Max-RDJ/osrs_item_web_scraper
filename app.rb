require "sinatra"
require "open-uri"
require "nokogiri"
require "json"

ITEMS = [
  {
    itemDescription: "Mithril platebody",
    itemName: "mithril+platebody",
    itemId: 1121,
    image: "https://secure.runescape.com/m=itemdb_oldschool/1730287781460_obj_big.gif?id=1121"
  },
  {
    itemDescription: "Mithril bar",
    itemName: "mithril+bar",
    itemId: 2359,
    image: "https://secure.runescape.com/m=itemdb_oldschool/1730287781460_obj_big.gif?id=2359"
  },
  {
    itemDescription: "Coal",
    itemName: "coal",
    itemId: 453,
    image: "https://secure.runescape.com/m=itemdb_oldschool/1730287781460_obj_big.gif?id=453"
  },
]

get "/" do
  erb :index
end

get "/search" do
  user_search = params[:itemDescription].to_s.downcase
  puts "User searched for: #{user_search}"
  item_found = ITEMS.find { |item| item[:itemDescription].downcase == user_search }

  if item_found
    puts "Item found details: #{item_found}"
    url = "https://secure.runescape.com/m=itemdb_oldschool/#{item_found[:itemName]}/viewitem?obj=#{item_found[:itemId]}"
    html = URI.open(url)
    doc = Nokogiri::HTML(html)

    item_name = doc.css(".item-description h2").text
    price = doc.css("h3 span").text

    content_type :json
    { item_name: item_name, price: price, url: url, image: item_found[:image] }.to_json
  else
    content_type :json
    { error: "No results found." }.to_json
  end
end


