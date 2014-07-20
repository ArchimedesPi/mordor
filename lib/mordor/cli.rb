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
  end
end