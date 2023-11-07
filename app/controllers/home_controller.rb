class HomeController < ApplicationController
  def index
    url = URI.parse('http://api.currencylayer.com/live?access_key=35cd5d2f3a7d8d5bbfa9f5f1cf991f79&source=USD')
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)

    @live = if response.code.to_i == 200
              response.body
            else
              { "success": false }
            end
  rescue StandardError => e
    error = "An error occurred: #{e.message}"
    puts error
  end

  def fetch_exchange_rates
    puts params
  end
end
