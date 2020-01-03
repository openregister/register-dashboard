RSpec.shared_context 'country stubs', shared_context: :metadata do
  before(:all) do
    country_data = File.read('./spec/support/country.rsf')
    stub_request(:get, 'https://country.register.gov.uk/download-rsf/0')
    .with(headers: {
        'Accept' => '*/*',
        'Accept-Encoding' => 'gzip, deflate, identity',
        'Host' => 'country.register.gov.uk',
        'User-Agent' => 'CL'
    })
    .to_return(status: 200, body: country_data, headers: {})
  end

  def populate_db
    register = ObjectsFactory.new.create_register('country', 'Beta')
    ForceFullRegisterDownloadJob.perform_now(register)
  end

  RSpec.configure do |rspec|
    rspec.include_context 'country stubs', include_shared: true
  end
end
