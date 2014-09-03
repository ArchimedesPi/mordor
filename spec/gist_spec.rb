require 'mordor/utilities/gist'

RSpec.describe Gist do
  describe '#git_url' do
    it "returns https://gist.github.com/foobar.git for foobar" do
      expect(Gist.git_url('foobar')).to eq('https://gist.github.com/foobar.git')
    end
  end
end
