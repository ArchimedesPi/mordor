# "Global" class to host helper functions for doing Github Gist transactions
class Gist
  # Converts a Gist ID to a Git over HTTPS url
  # == Parameters:
  # gist_id::
  #   The ID of the Gist
  # == Returns::
  # A string with the Git over HTTPS url
  def self.git_url(gist_id)
    "https://gist.github.com/#{gist_id}.git"
  end

  # Converts a Gist ID to a url for the webpage of that Gist
  # == Parameters:
  # gist_id::
  #   The ID of the Gist
  # == Returns::
  # A string with the webpage url of the Gist
  def self.web_url(gist_id)
    "https://gist.github.com/#{gist_id}"
  end
end
