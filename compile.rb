#!/opt/ruby-1.9/bin/ruby

require 'yaml'

class Block
  
  def initialize
    @code = ""
    @s = []
    @locals = false
  end
  
  def op_trace op
  end
  
  def op_putspecialobject op
  end
  
  def op_putnil op
    @s << nil
  end
  
  def op_putstring op
    @s << "\"#{op[1]}\""
  end
  
  def op_putobject op
    @s << op[1]
  end
  
  def op_setlocal op
    unless @locals
      @locals = true
      @code << "var " + (1..op[1]).map { |v| "$local_#{v}" }.join(', ') + ";"
    end
    last = @s.pop
    @s << "($local_#{op[1]} = #{last})"
  end
  
  def op_getlocal op
    @s << "$local_#{op[1]}"
  end
  
  def op_dup op
  end
  
  def op_opt_plus op
    last = @s.pop
    prev = @s.pop
    # (...) may be needed
    @s << "#{prev} + #{last}"
  end
  
  def op_opt_mult op
    last = @s.pop
    prev = @s.pop
    # (...) may be needed
    @s << "#{prev} * #{last}"
  end
  
  def op_send op
    block = op[3]
    if block
      bakeclosure op
    end
    
    args = @s.last(op[2])
    op[2].times { @s.pop }
    last = @s.pop
    @s << "(#{last and "(#{last})."}#{op[1]}(#{args.join(", ")}))"
  end
  
  def op_defineclass op
    # SimpleDataFormat
    sdf = op[2]
    block = sdf[11]
    # puts code.to_yaml
    code = Block.new.walk block
    @code << "(function (self) { self.prototype = {}; #{code} }) (self.#{op[1]} = function () {}) ;"
  end
  
  def bakeclosure op
    # SimpleDataFormat
    sdf = op[3]
    block = sdf[11]
    # puts code.to_yaml
    code = Block.new.walk block
    @code << "function () { #{code} }"
  end
  
  def op_leave op
  end
  
  def op_newline op
    @code << @s.join(', ') + ";"
    @s = []
  end
  
  
  
  def walk op_set
    op_set.each do |op|
      if op.class == Fixnum
        op_newline op
      else
        optype = ("op_" + op[0].to_s).to_sym
        
        # p op
        if respond_to? optype
          warn "    #{op}"
          send optype, op
        else
          warn "unknow optype #{optype}"
        end
      end
      
    end
    warn @code
    return @code
  end
end

class Generator
  def start iseq
    
    puts "load('r.js');"
    puts "(function (self) { self.prototype = {}; "
    puts Block.new.walk iseq.to_a.last
    puts " return self }) (this) ;"
  end
end

OutputCompileOption =
{
  :peephole_optimization    =>true,
  :inline_const_cache       =>false,
  :specialized_instruction  =>false,
  :operands_unification     =>false,
  :instructions_unification =>false,
  :stack_caching            =>false,
}


Generator.new.start RubyVM::InstructionSequence.compile(IO.read(ARGV[0]), "src", 1) #, OutputCompileOption

puts

# p iseq.to_a.last.to_yaml