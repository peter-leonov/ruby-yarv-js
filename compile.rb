#!/opt/ruby-1.9/bin/ruby

require 'yaml'

class Block
  
  @@indent = 2
  @@space = "  "
  
  def initialize
    @code = ""
    @s = []
    @locals = false
  end
  
  def warn_op op, str = ""
    warn "#{@@space * @@indent}#{op.first(5).select{|v|v.class!=Array}}#{str}, [#{@s}]"
  end
  
  def warn_str str
    warn "#{@@space * @@indent}#{str}"
  end
  
  def op_trace op
  end
  
  def op_putspecialobject op
  end
  
  def op_putnil op
    @s << nil
  end
  
  def op_putstring op
    @s << "#{op[1].inspect}"
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
  
  def op_setdynamic op
    last = @s.pop
    @s << "($local_#{op[1]} = #{last})"
  end
  
  def op_getlocal op
    @s << "$local_#{op[1]}"
  end
  
  def op_getdynamic op
    @s << "$local_#{op[1]}" # dynamic
  end
  
  def op_getconstant op
    @s << "#{op[1]}"
  end
  
  def op_dup op
  end
  
  def op_opt_plus op
    last = @s.pop
    prev = @s.pop
    # (...) may be needed
    @s << "#{prev} + #{last}"
  end
  
  def op_opt_minus op
    last = @s.pop
    prev = @s.pop
    # (...) may be needed
    @s << "#{prev} - #{last}"
  end
  
  def op_opt_mult op
    last = @s.pop
    prev = @s.pop
    # (...) may be needed
    @s << "#{prev} * #{last}"
  end
  
  def op_send op
    name = op[1]
    args = @s.last(op[2])
    op[2].times { @s.pop }
    last = @s.pop
    
    block = op[3]
    if block
      code = bakeclosure op
      args.unshift code
    end
    
    if last
      call = name == :new ? "#{name} (#{last})" : "(#{last}).#{name}"
    else
      call = "#{name}"
    end
    
    @s << "(#{call}(#{args.join(", ")}))"
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
    warn_str op.inspect
    sdf = op[3]
    args = sdf[4]
    block = sdf[11]
    warn_op block
    code = Block.new.walk block
    return "function (#{(args[:arg_size]..args[:local_size]).to_a.reverse.map{|v|"$local_#{v}"}.join(', ')}) { #{code} }"
  end
  
  def op_leave op
    @code << @s.join(', ') + ";"
  end
  
  def op_newline op
    @code << @s.join(', ') + ";"
    @s = []
  end
  
  
  
  def walk ops
    warn_str "block"
    @@indent += 1
    ops.each do |op|
      if op.class == Fixnum
        warn_str 'newline'
        op_newline op
      elsif op.class == Symbol
        # warn "label: #{op}"
      else
        optype = ("op_" + op[0].to_s).to_sym
        
        # p op
        if respond_to? optype
          warn_op op
          send optype, op
        else
          warn_op op, " UNKNOWN"
          # warn "unknow optype #{optype}"
        end
      end
      
    end
    warn_str "#{@code}"
    @@indent -= 1
    return @code + "\n"
  end
end

class Generator
  def start iseq
    return "(function (self) { self.prototype = {}; " + Block.new.walk(iseq.to_a.last) + " return self }) (this) ;"
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

# class Block; def warn_str; end; def warn_op; end ;end
warn "\n\n\n"
puts Generator.new.start RubyVM::InstructionSequence.compile(IO.read(ARGV[0]), "src", 1) #, OutputCompileOption

# p iseq.to_a.last.to_yaml