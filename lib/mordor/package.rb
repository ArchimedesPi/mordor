module Mordor
  # Package class for handling a package
  # Its data will be fetched from a gist or something similar.
  # @author Liam M
  class Package
    # @return [Hash] the status of the package
    attr_reader :status
    # @return [String] the URL of the package download
    attr_reader :url

    def initialize
      @status = {:fetched => false, :installed => false}
    end

    # Fetch the package from the package's @url.
    def fetch
      @status[:fetched] = true
    end

    # Reverses .fetch. Purges the package's download from the local filesystem
    def purge
      @status[:fetched] = false
    end

    # Install a package (ie run the buildscripts)
    def install
      @status[:installed] = true
    end

    # Remove a package that's been installed (ie run the destroyscripts)
    def remove
      @status[:installed] = false
    end
  end
end
