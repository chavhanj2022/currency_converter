require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  before do
    # Stub the time_series and do_exchange methods to return some mock data
    mock_time_series = [{ name: 'Mock Time Series 1', data: [1, 2, 3] }, { name: 'Mock Time Series 2', data: [4, 5, 6] }]
    allow(controller).to receive(:time_series).and_return(mock_time_series)
    allow(controller).to receive(:do_exchange).and_return('Mock Exchange Result')
  end

  shared_examples 'assigns result with expected structure' do
    it 'assigns @result' do
      get action, params: params, format: format

      result = assigns(:result)
      expect(result).to be_a(Hash)
      expect(result).to have_key('time_frame').and have_key('exchange')
      expect(result['time_frame']).to be_an(Array)

      result['time_frame'].each do |time_frame|
        expect(time_frame).to be_a(Hash)
        expect(time_frame).to have_key(:name).and have_key(:data)
        expect(time_frame[:data]).to be_a(Array)
        expect(time_frame['exchange']).to be_a(Float).or(be_a(Integer)).or(be_nil)
      end
    end
  end

  describe '#index' do
    let(:action) { :index }
    let(:params) { {} }
    let(:format) { :html } # Adjust the format if necessary

    include_examples 'assigns result with expected structure'
  end

  describe '#fetch_exchange_rates' do
    let(:action) { :fetch_exchange_rates }
    let(:params) { { 'base' => 'US', 'target' => 'IN', 'amount' => '1' } }
    let(:format) { :js }

    include_examples 'assigns result with expected structure'
  end
end
