
class A

  startTime = Time.new.to_f
  
  sum = ""
  50000.times{|e| sum += e.to_s}
  
  endTime = Time.new.to_f
  puts (endTime - startTime).to_s + ' sec'
  puts sum.length.to_s + " = " + 238890.to_s
  
  
  startTime = Time.new.to_f
  
  sum = 0
  50000.times{|e| sum += e}
  
  endTime = Time.new.to_f
  puts (endTime - startTime).to_s + ' sec'
  puts sum.to_s + " = " + 1249975000.to_s
end