load "lib.js";

class A
  # BASE = "/" + "opt/"
  class B
  
    # module Config
    #   HOME = BASE + "home/"
    # end
    #   
    # def hello
    #   puts HOME
    # end
    #   
    # def initialize
    #   # super
    #   @a = {}
    #   @b = {}
    # end
  end
end

class C < A
end