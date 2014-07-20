require 'thor'

module Mordor
  class CLI < Thor
    desc "zap", "Remove Mordor from this computer"
    def zap
      puts "I have been zapped <arrrgh!>"
    end
    
    desc "status", "Status of a package"
    def status(package)
      puts "This *would* have been the status of #{package}"
    end
    
    desc "fetch", "Fetch a package's repo to the current directory"
    def fetch(package)
      puts "This *would* have fetched the package #{package}"
    end
    
    desc "install", "Install a package"
    def install(package)
      puts "Would install the package #{package}"
    end
  end
end