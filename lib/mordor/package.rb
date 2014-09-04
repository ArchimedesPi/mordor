module Mordor
  class Package
    attr_reader :status
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
