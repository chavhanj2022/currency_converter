class HomeController < ApplicationController
  def index
    result = time_series
    exchange = do_exchange('USD', 'INR', "1")

    @result = {"time_frame" => result, "exchange" => exchange}
  end

  def fetch_exchange_rates
    base_currency = IsoCountryCodes.find(params['base']).currency
    target_currency = IsoCountryCodes.find(params['target']).currency
    amount = params['amount']
    if base_currency.blank? || target_currency.blank? || amount.blank?
        @result = {"time_frame" => [], "exchange" => ""}
    else
        time_series = time_series(base_currency, target_currency)
        exchange = do_exchange(base_currency, target_currency, amount)
        @result = {"time_frame" => time_series, "exchange" => exchange}
       
    end
  end

  private
  def time_series(base_currency = 'INR', target_currency = 'USD')
    start_date = (Time.now.to_date - 11.months).strftime('%Y-%m-%d')
    end_date = Time.now.to_date.strftime('%Y-%m-%d')

    url = URI.parse("#{ENV['CURRENCY_LAYER']}/timeframe?access_key=#{ENV['CURRENCY_LAYER_KEY']}&currencies=#{target_currency},#{base_currency}&start_date=#{start_date}&end_date=#{end_date}")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
    data = JSON.parse(response.body)

    return result = [{ name: '', data: [] }] unless response.code.to_i == 200 && data['success']

    time_and_values = data['quotes'].map do |date_str, quote_data|
      timestamp = Date.parse(date_str.to_s).strftime('%Q').to_i

      value = quote_data.values[0]
      [timestamp, value]
    end

    result = [{ name: '', data: time_and_values }]
  rescue StandardError => e
    error = "An error occurred: #{e.message}"
    puts error
    result = [{ name: '', data: [] }]
  end

  def do_exchange(base_currency = 'INR', target_currency = 'USD', amount = '10')
    
    url = URI.parse("#{ENV['CURRENCY_LAYER']}/convert?access_key=#{ENV['CURRENCY_LAYER_KEY']}&from=#{base_currency}&to=#{target_currency}&amount=#{amount}")
    http = Net::HTTP.new(url.host, url.port)
    request = Net::HTTP::Get.new(url.request_uri)
    response = http.request(request)
    data = JSON.parse(response.body)
    conversion = if response.code.to_i == 200 && data['success']
                   data['result']
                 else
                   nil
                 end
  rescue StandardError => e
    error = "An error occurred: #{e.message}"
    return conversion = nil
    puts error
  end
end
