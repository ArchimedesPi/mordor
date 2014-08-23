require 'thor'
require 'mordor'
require 'term/ansicolor'

include Term::ANSIColor

module Mordor
  class CLI < Thor

    desc "status PACKAGE", "Status of a package"
    def status(package)
      puts "This *would* have been the status of #{package}"
    end

    desc "fetch PACKAGE", "Fetch a package's repo to the current directory"
    def fetch(package)
      puts "This *would* have fetched the package #{package}"
    end

    desc "install PACKAGE", "Install a package"
    def install(package)
      puts "Would install the package #{package}"
    end
  end
end
