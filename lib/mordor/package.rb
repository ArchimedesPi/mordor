module Mordor
  class Package
    def fetch
      @status[:fetched] = true
    end

    def purge
      @status[:fetched] = false
    end

    def install!
      @status[:installed] = true
    end

    def remove!
      @status[:installed] = false
    end

    def status
      return @status
    end
  end
end
