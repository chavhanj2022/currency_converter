class ConverterController < ApplicationController
    
  def fetch_exchange_rates
    url = URI.parse('http://data.fixer.io/api/latest?access_key=8b2f0c62d80d0ac19ed9800b069e950c')
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)

    if response.code.to_i == 200
      render json: response.body
    else
      render json: { error: 'Failed to fetch data from the API' }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
  ensure
    http.finish if http.started?
  end
end
