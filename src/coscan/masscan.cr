module Coscan
  class Masscan
    class_property range = "198.7.200.0-198.7.255.255"
    class_property name = ""

    def initialize
      cmd_run
      File.read_lines("tmp/#{@@name}.tmp").each do |line|
        if line.includes? "open"
          ip = line.split(" ")[1]
          File.open("tmp/#{@@name}.ips", "a") do |f|
            f << "#{ip}\n"
          end
        end
      end
    end

    def cmd_run
      `masscan --wait 0 -p8080 --range #{@@range} -oG tmp/#{name}.tmp`
    end

    def name
      r = @@range.split(".")
      @@name = r.first(2).join(".")
    end

    def self.start
      Masscan.new
    end
  end
end
