class Gist
  def self.git_url(gist_id)
    "https://gist.github.com/#{gist_id}.git"
  end

  def self.web_url(gist_id)
    "https://gist.github.com/#{gist_id}"
  end
end
