module Coscan
  class GetInfo
    class_property pattern = "[-A-Za-z0-9]+(DESKTOP|PC)[-A-Za-z0-9]+"

    @binaries = [] of String
    @ch = Channel(String).new
    @counter = 0

    def initialize
      puts "Analyzing downloaded files..."
      list_binaries
      analyze_binaries
      @binaries.each do
        puts @ch.receive
      end
      puts "#{@counter} dat files found!".colorize(:yellow)
    end

    def list_binaries
      @binaries = Dir.glob("bin/*.bin")
    end

    def analyze_binaries
      @binaries.each do |file|
        spawn data_search(file)
      end
    end

    def data_search(file)
      basename = File.basename(file, ".bin")
      msg = "#{basename} analyzed!, pattern found: "
      `hexdump -c #{file} | sed -r 's/\\S+//1' | sed ':a;N;$!ba;s/\\n//g' | sed 's/ //g' | grep -o -E "#{@@pattern}" | sort -u | tee > dat/#{basename}.dat`
      if File.read("dat/#{basename}.dat").blank?
        msg += "false".colorize(:red).to_s
      else
        msg += "true".colorize(:green).to_s
        @counter += 1
      end
      @ch.send msg
    end

    def self.start
      GetInfo.new
    end
  end
end
