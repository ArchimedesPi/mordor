require 'thor'
require 'mordor'
require 'term/ansicolor'

include Term::ANSIColor

module Mordor
  class CLI < Thor

    desc "status PACKAGE", "Status of a package"
    def status(package)
      puts blue { italic { "Status of #{package}" } }
      puts Mordor::Packages.by_name(package).status.to_s
    end

    desc "fetch PACKAGE", "Fetch a package's repo to the current directory"
    def fetch(package)
      puts green { italic { "Fetching ${package}" } }
      Mordor::Packages.by_name(package).fetch(Mordor.here)
    end

    desc "install PACKAGE", "Install a package"
    def install(package)
      Mordor::Packages.by_name(package).install
    end
  end
end
