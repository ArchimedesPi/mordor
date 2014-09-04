module Mordor
  class Package
    attr_reader :status
    attr_reader :url

    def initialize
      @status = {:fetched => false, :installed => false}
    end

    def fetch
      @status[:fetched] = true
    end

    def purge
      @status[:fetched] = false
    end

    def install
      @status[:installed] = true
    end

    def remove
      @status[:installed] = false
    end
  end
end
