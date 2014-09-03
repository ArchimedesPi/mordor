require 'mordor/package'

RSpec.describe Mordor::Package do
  describe '#fetch' do
    it "fetches the package and sets @status['fetched'] to true" do
      package = Mordor::Package.new
      package.fetch
      expect(package.status['fetched']).to eq(true)
    end
  end
end
