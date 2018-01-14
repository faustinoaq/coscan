require "http"
require "colorize"

require "./coscan/*"

module Coscan
  def self.start
    Coscan::CLI.start
    Coscan::Workers.start
    Coscan::Masscan.start
    Coscan::LastLine.start
    Coscan::GetInfo.start
  end
end

Coscan.start
