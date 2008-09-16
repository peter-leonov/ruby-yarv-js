
class A
  CONST = "/" + "a/"
  class B
    puts CONST
    puts A::CONST
    CONST = CONST + "b/"
    puts CONST
    puts A::CONST
    
    def meth num
      puts "meth called for #{num}!"
    end
    
    def self.cmeth
      puts "class meth called!"
    end
  end
end

class C < A
  def meth num
    super num
    puts "super!"
  end
end

1.times do |a1|
  a1 = 1111
  # puts x
  # y = 5
  1.times do |a2|
    a2 = 2222
    # 2.times { |z| c + d }
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
        end
      end
    end
    # A::B.new.meth
    # C.new.meth x + y + z
  end
end
