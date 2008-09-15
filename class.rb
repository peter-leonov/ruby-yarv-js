
class A
  CONST = "/" + "a/"
  class B
    puts CONST
    puts A::CONST
    CONST = CONST + "b/"
    puts CONST
    puts A::CONST
  end
end

class C < A
end