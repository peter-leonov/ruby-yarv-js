# require 'barman'

load "lib.js";

class A

  startTime = Time.new.to_f

  sum = ""
  50000.times{|e| sum += e.to_s}

  endTime = Time.new.to_f
  puts (endTime - startTime).to_s + ' sec'
  
end