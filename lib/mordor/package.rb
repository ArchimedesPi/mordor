module Mordor
  class Package
    attr_reader :status
    attr_reader :url

    def initialize
      @status = {:fetched => false, :installed => false}
    end

    def fetch
      # Fetch the package from the package's @url.
      @status[:fetched] = true
    end

    def purge
      # Reverses .fetch. Purges the package's download from the local filesystem
      @status[:fetched] = false
    end

    def install
      # Install a package (ie run the buildscripts)
      @status[:installed] = true
    end

    def remove
      # Remove a package that's been installed (ie run the destroyscripts)
      @status[:installed] = false
    end
  end
end
