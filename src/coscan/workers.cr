lib LibC
  fun getuid : UidT
end

module Coscan
  class Workers
    def initialize
      check_root
      check_dependencies
      check_internet
      create_dirs
      save_previous_scan
      confirm_start
    end

    def check_dependencies
      dependencies = ["masscan", "hexdump", "sed"]
      dependencies.each do |d|
        unless system("which #{d} &> /dev/null")
          puts "#{d} depencency is missing, please install it"
          exit 1
        end
      end
    end

    def check_internet
      ip = HTTP::Client.get("ipecho.net/plain").body
      puts "Successfully connected from #{ip}"
    rescue e : Socket::Error
      puts "Internet is desconected"
    end

    def create_dirs
      Dir.mkdir_p("tmp/tmp")
      Dir.mkdir_p("tmp/dat")
      Dir.mkdir_p("tmp/bin")
      Dir.mkdir_p("dat")
    end

    def save_previous_scan
      puts "Saving previous scan..."
      ["tmp/*.ips", "tmp/*.tmp", "tmp/*.header", "bin/*.bin", "dat/*.dat"].each do |files|
        dest = files.split("/").first
        `mv #{files} tmp/#{dest}/` unless Dir.glob(files).empty?
      end
    end

    def check_root
      if LibC.getuid != 0
        puts "You need to run this program as root"
        exit 1
      end
    end

    def confirm_start
      print "Are you sure you want to execute this scan? Y/N: "
      input = gets.to_s
      if input.upcase == "Y"
        puts "Starting scan..."
      else
        puts "Exiting..."
        exit
      end
    end

    def self.start
      Workers.new
    end
  end
end
