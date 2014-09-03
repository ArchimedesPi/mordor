require 'mordor/utilities/gist'

RSpec.describe Gist do
  describe '#git_url' do
    it "returns https://gist.github.com/foobar.git for foobar" do
      expect(Gist.git_url('foobar')).to eq('https://gist.github.com/foobar.git')
    end
  end

  describe '#web_url' do
    it "returns https://gist.github.com/foobar for foobar" do
      expect(Gist.web_url('foobar')).to eq('https://gist.github.com/foobar')
    end
  end
end
