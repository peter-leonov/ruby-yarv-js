# require 'barman'

load "lib.js";

class A

class EventsProcessor
  
  # module Config
  #   EVENTS_DIR = Barman::BASE_DIR + "Events/"
  # end
  
  # def hello
  # end
  
  # def initialize
  #   super
  #   @entities = {}
  #   @entity  = {} # currently processed bar
  # end
  # a = "555"
  
  # b = "555" + 888.toString(16, "777".split(puts)) + 999 * 5
  # b.match('aaa')
  # a = 555
  
  
  startTime = Time.new.to_f

  sum = ""
  50000.times{|e| sum += e.to_s}

  endTime = Time.new.to_f
  puts (endTime - startTime).to_s + ' sec'
  
  
  # sum = ""
  # b = Date.new
  # 50000.times{|v| sum += v.to_s}
  # # 3.times { |v| puts v+1 }
  # puts Date.new - b
  # 
  # alert 123
  
  # b = a
  # c = 777
  # a = c
  # d = c
  # b = 1.puts "Hello", " ".to_s.to_s , "World!"
end

end