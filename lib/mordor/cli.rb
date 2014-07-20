require 'thor'

module Mordor
  class CLI < Thor
    desc "zap", "Remove Mordor from this computer"
    def zap
      puts "I have been zapped <arrrgh!>"
    end
  end
end