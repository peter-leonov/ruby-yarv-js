
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

