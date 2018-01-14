require "option_parser"

module Coscan
  class CLI
    def initialize
      OptionParser.parse! do |parser|
        parser.banner = "Usage: coscan [arguments]"
        range(parser)
        username(parser)
        password(parser)
        pattern(parser)
        help(parser)
      end
    end

    def range(parser)
      parser.on("-r RANGE", "--range=RANGE", "Specify scan range") do |range|
        Masscan.range = range
      end
    end

    def username(parser)
      parser.on("-u USERNAME", "--user=USERNAME", "Specify masive target user") do |username|
        LastLine.username = username
      end
    end

    def password(parser)
      parser.on("-p PASSWORD", "--password=PASSWORD", "Specify masive target password") do |password|
        LastLine.password = password
      end
    end

    def pattern(parser)
      parser.on("-p PATTERN", "--pattern=PATTERN", "Specify masive target pattern") do |pattern|
        GetInfo.pattern = pattern
      end
    end

    def help(parser)
      parser.on("-h", "--help", "Show this help") do
        puts parser.to_s
        exit
      end
    end

    def self.start
      CLI.new
    end
  end
end
