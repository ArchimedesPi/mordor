module Mordor
  class Gist
    def git_url(gist_id)
      "https://gist.github.com/#{gist_id}.git"
    end

    def web_url(gist_id)
      "https://gist.github.com/#{gist_id}"
    end
  end
end
