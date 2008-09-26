1.times do |a1|
  a1 = 1111
  1.times do |a2|
    a2 = 2222
    1.times do |a3, b3|
      b = 00000
      c = 00000
      
      a3 = 3333
      b3 = 3333
      1.times do |a4|
        a4 = 4444
        1.times do |a5|
          b3 = 3333
          a3 = a4 = a5 = 5555
          puts a3, a4, a5
        end
      end
    end
    
  end
end
